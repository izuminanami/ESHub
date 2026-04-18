//
//  BandMember.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import Foundation

struct BandMember: Identifiable, Hashable {
    let id: String
    let role: String
    var name: String
    
    init(role: String, name: String = "") {
        self.id = role
        self.role = role
        self.name = name
    }
    
    init?(data: [String: Any]) {
        guard let role = data["role"] as? String else {
            return nil
        }
        
        self.init(
            role: role,
            name: data["name"] as? String ?? ""
        )
    }
    
    var firestoreData: [String: Any] {
        [
            "role": role,
            "name": name.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
    }
    
    var hasName: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
