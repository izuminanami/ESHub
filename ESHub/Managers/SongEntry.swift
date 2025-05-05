//
//  SongEntry.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import Foundation

struct SongEntry: Identifiable {
    let id = UUID()
    var title: String
    var minute: Int
    var second: Int
    var sound: String
    var lighting: String
}
