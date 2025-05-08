//
//  AdRemoveIcon.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/07.
//

import SwiftUI

struct AdRemoveIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 30, height: 30)
            
            Text("Ad")
                .font(.system(size: 15, weight: .bold))
            
            Rectangle()
                .frame(width: 40, height: 2)
                .rotationEffect(.degrees(45))
        }
    }
}

