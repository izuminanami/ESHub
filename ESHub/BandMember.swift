//
//  BandMember.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import Foundation

struct BandMember: Identifiable {
    let id = UUID()
    let role: String
    var name: String
}
