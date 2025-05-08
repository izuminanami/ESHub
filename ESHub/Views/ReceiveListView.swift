//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    @StateObject private var spreadSheetManager = ESSheetManager()
    @StateObject private var store = Store()
    @Environment(\.editMode) private var editMode
    @State private var isShareSheetPresentedForPerformers = false
    @State private var isLoading = true
    @State private var isShowingActionSheet = false
    @State private var filteredRows: [[String]] = []
    @State private var selectedTime = Date() // 選択された開始時間を保持
    @State private var selectedBreakTime: Int = 10
    
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
                        HStack(alignment: .top) {
                            VStack (alignment: .leading){
                                HStack {
                                    Text("開始時間：")
                                        .lineLimit(1)
                                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.compact)
                                        .frame(width: 40)
                                }
                                HStack {
                                    Text("転換時間：")
                                        .lineLimit(1)
                                    Spacer()
                                    Picker("", selection: $selectedBreakTime) {
                                        ForEach(0..<31) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 50, height: 50)
                                    Text("分")
                                }
                            }
                            .padding()
                            
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
                                        HStack {
                                            Text(row[2])
                                            Spacer()
                                                .padding()
                                            Text(row[15])
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .onMove(perform: editMode?.wrappedValue.isEditing == true ? moveItem : nil)
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
                                        exportTimeTable()
                                    },
                                    .default(Text("音響要望のみを出力")) {
                                        exportSoundRequests()
                                    },
                                    .default(Text("照明要望のみを出力")) {
                                        exportLightRequests()
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        
                        Spacer()
                            .frame(height: 70)
                    }
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
            .task {
                await loadData()
            }
        }
        .navigationTitle("参加バンドリスト")
        .toolbar {
            if !filteredRows.isEmpty {
                EditButton()
            }
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
            return Int.max // 無効な値は最後に回す
        }
        return minutes * 60 + seconds
    }
    
    private func exportTimeTable() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var currentTime = selectedTime
        
        let timeTable = filteredRows.map { row in
            let bandName = row[safe: 2] ?? ""
            let totalTimeStr = row[safe: 15]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "00:00" // mm:ss
            
            let timeParts = totalTimeStr.components(separatedBy: ":")
            let minutes = Int(timeParts[safe: 0]?.trimmingCharacters(in: .whitespaces) ?? "0") ?? 0
            let seconds = Int(timeParts[safe: 1]?.trimmingCharacters(in: .whitespaces) ?? "0") ?? 0
            let durationInSeconds = (minutes * 60) + seconds
            
            let startStr = dateFormatter.string(from: currentTime)
            let endTime = currentTime.addingTimeInterval(TimeInterval(durationInSeconds))
            let endStr = dateFormatter.string(from: endTime)
            
            currentTime = endTime.addingTimeInterval(TimeInterval(selectedBreakTime * 60)) // 転換時間を加えて次の開始時間を設定
            
            return "\(startStr)〜\(endStr)  \(bandName)"
        }.joined(separator: "\n")
        
        let activityVC = UIActivityViewController(activityItems: [timeTable], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func exportSoundRequests() {
        let soundData = filteredRows.map { row in
            let bandName = row[safe: 2] ?? ""
            let totalTime = row[safe: 15] ?? ""
            let titles = (row[safe: 11] ?? "").components(separatedBy: ", ")
            let sounds = (row[safe: 13] ?? "").components(separatedBy: ", ")
            let paired = zip(titles, sounds)
                .filter { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty } // 空タイトルを除外
                .map { "「\($0)」\($1)" }
                .joined(separator: "\n")
            
            return "- \(bandName) \(totalTime)\n\(paired)"
        }.joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(activityItems: [soundData], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func exportLightRequests() {
        let lightData = filteredRows.map { row in
            let bandName = row[safe: 2] ?? ""
            let totalTime = row[safe: 15] ?? ""
            let titles = (row[safe: 11] ?? "").components(separatedBy: ", ")
            let lights = (row[safe: 14] ?? "").components(separatedBy: ", ")
            let paired = zip(titles, lights)
                .filter { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty } // 空タイトルを除外
                .map { "「\($0)」\($1)" }
                .joined(separator: "\n")
            
            return "- \(bandName) \(totalTime)\n\(paired)"
        }.joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(activityItems: [lightData], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: selectedTime)
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
