//
//  ESHubApp.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

@main
struct ESHubApp: App {
    
    init() {
        _ = NetworkManager.shared // 起動時にネットワーク状態の初期確認を促す(初回guard回避のため)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
