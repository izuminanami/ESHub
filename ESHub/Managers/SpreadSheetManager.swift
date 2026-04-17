//
//  SpreadSheetManager.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import Foundation
import FirebaseFirestore

struct LiveEvent: Identifiable, Hashable {
    let id: String
    let name: String
    let normalizedName: String
    let watchWord: String
    let createdAt: Date?
    
    init(
        id: String,
        name: String,
        normalizedName: String? = nil,
        watchWord: String,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.normalizedName = normalizedName ?? FirestoreManager.normalize(name)
        self.watchWord = watchWord
        self.createdAt = createdAt
    }
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let name = data["name"] as? String,
            let normalizedName = data["normalizedName"] as? String,
            let watchWord = data["watchWord"] as? String
        else {
            return nil
        }
        
        self.init(
            id: document.documentID,
            name: name,
            normalizedName: normalizedName,
            watchWord: watchWord,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue()
        )
    }
}

struct LiveEntryDraft: Hashable {
    var bandName: String
    var members: [BandMember]
    var songs: [SongEntry]
    var seEnabled: Bool
    var otherRequest: String
    
    var validSongs: [SongEntry] {
        songs.filter(\.hasTitle)
    }
    
    var totalDurationSeconds: Int {
        validSongs.reduce(0) { $0 + $1.durationInSeconds }
    }
    
    var firestoreData: [String: Any] {
        [
            "bandName": bandName.trimmingCharacters(in: .whitespacesAndNewlines),
            "members": members.map(\.firestoreData),
            "songs": validSongs.enumerated().map { index, song in
                song.firestoreData(displayOrder: index)
            },
            "seEnabled": seEnabled,
            "otherRequest": otherRequest.trimmingCharacters(in: .whitespacesAndNewlines),
            "totalDurationSeconds": totalDurationSeconds,
            "createdAt": FieldValue.serverTimestamp()
        ]
    }
}

struct LiveEntry: Identifiable, Hashable {
    let id: String
    let bandName: String
    let members: [BandMember]
    let songs: [SongEntry]
    let seEnabled: Bool
    let otherRequest: String
    let totalDurationSeconds: Int
    let createdAt: Date?
    
    init(
        id: String,
        bandName: String,
        members: [BandMember],
        songs: [SongEntry],
        seEnabled: Bool,
        otherRequest: String,
        totalDurationSeconds: Int,
        createdAt: Date?
    ) {
        self.id = id
        self.bandName = bandName
        self.members = members
        self.songs = songs
        self.seEnabled = seEnabled
        self.otherRequest = otherRequest
        self.totalDurationSeconds = totalDurationSeconds
        self.createdAt = createdAt
    }
    
    init(id: String, draft: LiveEntryDraft, createdAt: Date? = Date()) {
        self.init(
            id: id,
            bandName: draft.bandName.trimmingCharacters(in: .whitespacesAndNewlines),
            members: draft.members,
            songs: draft.validSongs,
            seEnabled: draft.seEnabled,
            otherRequest: draft.otherRequest.trimmingCharacters(in: .whitespacesAndNewlines),
            totalDurationSeconds: draft.totalDurationSeconds,
            createdAt: createdAt
        )
    }
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let bandName = data["bandName"] as? String
        else {
            return nil
        }
        
        let songData = data["songs"] as? [[String: Any]] ?? []
        let songs = songData
            .sorted { ($0["displayOrder"] as? Int ?? 0) < ($1["displayOrder"] as? Int ?? 0) }
            .compactMap(SongEntry.init(data:))
        
        let memberData = data["members"] as? [[String: Any]] ?? []
        let members = memberData.compactMap(BandMember.init(data:))
        
        self.init(
            id: document.documentID,
            bandName: bandName,
            members: members,
            songs: songs,
            seEnabled: data["seEnabled"] as? Bool ?? false,
            otherRequest: data["otherRequest"] as? String ?? "",
            totalDurationSeconds: data["totalDurationSeconds"] as? Int ?? songs.reduce(0) { $0 + $1.durationInSeconds },
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue()
        )
    }
    
    var totalDurationText: String {
        DurationTextFormatter.string(from: totalDurationSeconds)
    }
    
    var createdAtText: String {
        guard let createdAt else {
            return ""
        }
        
        return DateTextFormatter.submission.string(from: createdAt)
    }
}

enum DurationTextFormatter {
    static func string(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

enum DateTextFormatter {
    static let submission: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter
    }()
}

final class FirestoreManager {
    static let shared = FirestoreManager()
    
    private enum CollectionName {
        static let lives = "lives"
        static let entries = "entries"
    }
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func createLive(name: String, watchWord: String) async throws -> LiveEvent {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWatchWord = watchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let existingLive = try await fetchLive(named: trimmedName)
        guard existingLive == nil else {
            throw NSError(domain: "FirestoreManager", code: 409, userInfo: [
                NSLocalizedDescriptionKey: "入力されたライブ名は既に存在しています"
            ])
        }
        
        let document = database.collection(CollectionName.lives).document()
        let live = LiveEvent(
            id: document.documentID,
            name: trimmedName,
            watchWord: trimmedWatchWord,
            createdAt: Date()
        )
        
        try await document.setData([
            "name": live.name,
            "normalizedName": live.normalizedName,
            "watchWord": live.watchWord,
            "createdAt": FieldValue.serverTimestamp()
        ])
        
        return live
    }
    
    func fetchLive(named name: String) async throws -> LiveEvent? {
        let normalizedName = Self.normalize(name)
        guard !normalizedName.isEmpty else {
            return nil
        }
        
        let snapshot = try await database.collection(CollectionName.lives)
            .whereField("normalizedName", isEqualTo: normalizedName)
            .limit(to: 1)
            .getDocuments()
        
        return snapshot.documents.compactMap(LiveEvent.init(document:)).first
    }
    
    func fetchEntries(for live: LiveEvent) async throws -> [LiveEntry] {
        let snapshot = try await entriesCollection(for: live.id)
            .order(by: "createdAt")
            .getDocuments()
        
        return snapshot.documents.compactMap(LiveEntry.init(document:))
    }
    
    @discardableResult
    func submitEntry(to live: LiveEvent, draft: LiveEntryDraft) async throws -> LiveEntry {
        let document = try await entriesCollection(for: live.id).addDocument(data: draft.firestoreData)
        return LiveEntry(id: document.documentID, draft: draft)
    }
    
    private func entriesCollection(for liveID: String) -> CollectionReference {
        database.collection(CollectionName.lives)
            .document(liveID)
            .collection(CollectionName.entries)
    }
    
    static func normalize(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale: .current)
            .lowercased()
    }
}

enum FirestoreManagerError: LocalizedError {
    case sdkNotInstalled
    
    var errorDescription: String? {
        switch self {
        case .sdkNotInstalled:
            return "Firebase SDK が未導入です。Xcodeで FirebaseCore と FirebaseFirestore を追加してください。"
        }
    }
}
