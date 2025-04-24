//
//  ReceiveDetailView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import SwiftUI

struct ReceiveDetailView: View {
    let row: [String]
    var body: some View {
        ZStack {
            Color.gray.opacity(0.25)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(row.indices, id: \.self) { i in
                    Text("\(i+1)列目: \(row[i])")
                }
            }
            .navigationTitle("バンド詳細")
        }
    }
}

//#Preview {
//    ReceiveDetailView()
//}
