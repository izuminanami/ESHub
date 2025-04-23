//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    @StateObject private var spreadSheetManager = SpreadSheetManager()
    var body: some View {
        VStack {
            ForEach(spreadSheetManager.spreadSheetResponse.values, id: \.self) { index in
                Text(index.description)
            }
        }
        .task {
            do {
                try await spreadSheetManager.fetchGoogleSheetData()
                print("success")
            } catch {
                print("error: \(error)")
            }
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
