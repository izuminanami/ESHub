//
//  NetworkManager.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/05.
//

import SwiftUI
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    private(set) var isConnected = true // 初期値は"接続あり"
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
