//
//  ESHubApp.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}

@main
struct ESHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = Store()
    
    init() {
        _ = NetworkManager.shared // 起動時にネットワーク状態の初期確認を促す(初回guard回避のため)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
