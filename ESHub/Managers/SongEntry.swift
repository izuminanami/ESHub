//
//  SongEntry.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import Foundation

struct SongEntry: Identifiable, Hashable {
    let id: UUID
    var title: String
    var minute: Int
    var second: Int
    var sound: String
    var lighting: String
    
    init(
        id: UUID = UUID(),
        title: String,
        minute: Int,
        second: Int,
        sound: String,
        lighting: String
    ) {
        self.id = id
        self.title = title
        self.minute = minute
        self.second = second
        self.sound = sound
        self.lighting = lighting
    }
    
    init?(data: [String: Any]) {
        guard let title = data["title"] as? String else {
            return nil
        }
        
        let durationSeconds = data["durationSeconds"] as? Int ?? 0
        
        self.init(
            title: title,
            minute: durationSeconds / 60,
            second: durationSeconds % 60,
            sound: data["soundRequest"] as? String ?? "",
            lighting: data["lightingRequest"] as? String ?? ""
        )
    }
    
    var durationInSeconds: Int {
        (minute * 60) + second
    }
    
    var formattedDuration: String {
        String(format: "%d:%02d", minute, second)
    }
    
    var hasTitle: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func firestoreData(displayOrder: Int) -> [String: Any] {
        [
            "title": title.trimmingCharacters(in: .whitespacesAndNewlines),
            "durationSeconds": durationInSeconds,
            "soundRequest": sound.trimmingCharacters(in: .whitespacesAndNewlines),
            "lightingRequest": lighting.trimmingCharacters(in: .whitespacesAndNewlines),
            "displayOrder": displayOrder
        ]
    }
}
