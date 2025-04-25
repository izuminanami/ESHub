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
    let liveName: String
    var filteredRows: [[String]] {
        spreadSheetManager.spreadSheetResponse.values.filter { row in
            row.first == liveName
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView("loading...")
                } else if filteredRows.isEmpty {
                    Text("提出されたESはありません")
                } else {
                    VStack {
                        List {
                            ForEach(filteredRows, id: \.self) { row in
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
                                .fill(Color("primaryButtonColor"))
                                .frame(width: 100, height: 50)
                                .shadow(radius: 5)
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
        .navigationTitle("参加バンドリスト")
    }
}

#Preview {
    ReceiveListView(liveName: "東京理科大学")
}
