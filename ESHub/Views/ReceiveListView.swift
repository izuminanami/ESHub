//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    @StateObject private var spreadSheetManager = ESSheetManager()
    @State private var isShareSheetPresentedForPerformers = false
    @State private var isLoading = true
    @State private var isShowingActionSheet = false
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
                    VStack(spacing: 30) {
                        Text("提出されたESはありません")
                        
                        Button {
                            isShareSheetPresentedForPerformers = true
                        } label: {
                            MiddleButtonLabelComponent(text: "告知をする")
                        }
                        .sheet(isPresented: $isShareSheetPresentedForPerformers) {
                            ShareSheet(activityItems: ["「"+liveName+"」でES募集を開始しています。提出お願いします！\nhttps://apps.apple.com/jp/app/eshub/id6745217075"])
                        }
                    }
                } else {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                filteredRows.sort {
                                    timeStringToSeconds($0[safe: 15] ?? "") < timeStringToSeconds($1[safe: 15] ?? "")
                                }
                                saveOrder()
                            } label: {
                                Text("おまかせ並べ替え")
                                    .foregroundColor(Color("primaryButtonColor"))
                            }
                        }
                        .padding()
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
                        
                        Button {
                            isShowingActionSheet = true
                        } label: {
                            SmallButtonLabelComponent(text: "出力")
                        }
                        .actionSheet(isPresented: $isShowingActionSheet) {
                            ActionSheet(
                                title: Text(""),
                                message: Text(""),
                                buttons: [
                                    .default(Text("タイムテーブルを出力")) {
                                        
                                    },
                                    .default(Text("音響要望のみを出力")) {
                                        
                                    },
                                    .destructive(Text("照明要望のみを出力")) {
                                        
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        
                        Spacer()
                            .frame(height: 70)
                    }
                }
                VStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(width: 320, height: 50)
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
    
    private func timeStringToSeconds(_ time: String) -> Int {
        let trimmedTime = time.trimmingCharacters(in: .whitespacesAndNewlines)
        let components = trimmedTime.split(separator: ":")
        guard components.count == 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]) else {
            return Int.min // 無効な値は最初に回す
        }
        return minutes * 60 + seconds
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
