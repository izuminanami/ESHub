//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    @StateObject private var spreadSheetManager = SpreadSheetManager()
    @State private var isLoading = true
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView("loading...")
                } else {
                    VStack {
                        List {
                            ForEach(spreadSheetManager.spreadSheetResponse.values, id: \.self) { row in
                                if row.count > 1 {
                                    NavigationLink {
                                        ReceiveDetailView(row: row)
                                    } label: {
                                        Text(row[1])
                                    }
                                }
                            }
                        }
                        NavigationLink{
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.blue)
                                .frame(width: 100, height: 50)
                                .overlay(Text("出力").font(.title))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .task {
                isLoading = true
                do {
                    try await spreadSheetManager.fetchGoogleSheetData()
                    print("Success")
                } catch {
                    print("Error: \(error)")
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    ReceiveListView()
}
