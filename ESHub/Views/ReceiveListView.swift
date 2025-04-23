//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    var body: some View {
        List(0 ..< 10) { band in
            Text("バンド名")
        }
        NavigationLink{
            SubmitCompleteView()
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue)
                .frame(width: 100, height: 50)
                .overlay(Text("出力").font(.title))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ReceiveListView()
}
