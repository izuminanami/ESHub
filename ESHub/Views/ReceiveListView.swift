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
    @State private var filteredRows: [[String]] = []
    let liveName: String
    private let orderKey: String
    
    init(liveName: String) {
        self.liveName = liveName
        self.orderKey = "sortedOrder_\(liveName)"
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
                                        Text(row[2])
                                        Spacer()
                                            .padding()
                                        Text(row[15])
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .onMove(perform: moveItem)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color("backgroundColor"))
                        
                        NavigationLink {
                            
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
                await loadData()
            }
        }
        .navigationTitle("参加バンドリスト")
        .toolbar {
            EditButton()
        }
    }

    private func loadData() async {
        isLoading = true
        do {
            try await spreadSheetManager.fetchGoogleSheetData()
            let rows = spreadSheetManager.spreadSheetResponse.values.filter { $0[1] == liveName }
            
            let savedOrder = UserDefaults.standard.stringArray(forKey: orderKey)
            if let savedOrder = savedOrder {
                filteredRows = rows.sorted {
                    guard let first = $0[safe: 2], let second = $1[safe: 2] else { return false }
                    return savedOrder.firstIndex(of: first) ?? Int.max < savedOrder.firstIndex(of: second) ?? Int.max
                }
            } else {
                filteredRows = rows
            }
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        filteredRows.move(fromOffsets: source, toOffset: destination)
        saveOrder()
    }

    private func saveOrder() {
        let order = filteredRows.compactMap { $0[safe: 2] }
        UserDefaults.standard.set(order, forKey: orderKey)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ReceiveListView(liveName: "模擬データ")
}
