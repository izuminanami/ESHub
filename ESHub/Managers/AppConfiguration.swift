//
//  AppConfiguration.swift
//  ESHub
//
//  Created by 泉七海 on 2026/04/18.
//

import Foundation
import Combine

enum AppConfiguration {
    static var adMobAppID: String {
        Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String ?? ""
    }
    
    static var bannerAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/2934735716"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "GADBannerAdUnitID") as? String ?? ""
        #endif
    }
    
    static var interstitialAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "GADInterstitialAdUnitID") as? String ?? ""
        #endif
    }
}

enum DeepLinkDestination: Hashable {
    case entry(liveID: String)
    case manage(adminToken: String)
    
    init?(url: URL) {
        guard url.scheme?.lowercased() == "eshub" else {
            return nil
        }
        
        let host = url.host?.lowercased() ?? ""
        let value = url.pathComponents.dropFirst().first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !value.isEmpty else {
            return nil
        }
        
        switch host {
        case "entry":
            self = .entry(liveID: value)
        case "manage":
            self = .manage(adminToken: value)
        default:
            return nil
        }
    }
    
    var pathValue: String {
        switch self {
        case .entry(let liveID):
            return liveID
        case .manage(let adminToken):
            return adminToken
        }
    }
    
    var url: URL {
        URL(string: "eshub://\(pathComponent)/\(pathValue)")!
    }
    
    private var pathComponent: String {
        switch self {
        case .entry:
            return "entry"
        case .manage:
            return "manage"
        }
    }
}

@MainActor
final class AppRouter: ObservableObject {
    @Published var entryLive: LiveEvent?
    @Published var manageLive: LiveEvent?
    @Published var alertMessage: String?
    
    func open(url: URL) async {
        guard let deepLink = DeepLinkDestination(url: url) else {
            alertMessage = "URLの形式が正しくありません"
            return
        }
        
        do {
            let live: LiveEvent?
            switch deepLink {
            case .entry(let liveID):
                live = try await FirestoreManager.shared.fetchLive(id: liveID)
            case .manage(let adminToken):
                live = try await FirestoreManager.shared.fetchLive(adminToken: adminToken)
            }
            
            guard let live else {
                alertMessage = "指定されたライブが見つかりません"
                return
            }
            
            switch deepLink {
            case .entry:
                manageLive = nil
                entryLive = live
            case .manage:
                entryLive = nil
                manageLive = live
            }
        } catch {
            alertMessage = "URLの読み込みに失敗しました: \(error.localizedDescription)"
        }
    }
}
