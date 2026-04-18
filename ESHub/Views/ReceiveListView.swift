//
//  ReceiveListView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveListView: View {
    @StateObject private var store = Store()
    @Environment(\.editMode) private var editMode
    @State private var isShareSheetPresentedForPerformers = false
    @State private var isLoading = true
    @State private var isShowingActionSheet = false
    @State private var filteredEntries: [LiveEntry] = []
    @State private var selectedTime = Date() // 選択された開始時間を保持
    @State private var selectedBreakTime: Int = 10
    
    let live: LiveEvent
    private let orderKey: String
    
    init(live: LiveEvent) {
        self.live = live
        self.orderKey = "sortedOrder_\(live.id)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                if isLoading {
                    ProgressView("loading...")
                } else if filteredEntries.isEmpty {
                    VStack(spacing: 30) {
                        Text("提出されたESはありません")
                        
                        Button {
                            isShareSheetPresentedForPerformers = true
                        } label: {
                            MiddleButtonLabelComponent(text: "告知をする")
                        }
                        .sheet(isPresented: $isShareSheetPresentedForPerformers) {
                            ShareSheet(activityItems: ["「"+live.name+"」でES募集を開始しています。提出お願いします！\nhttps://apps.apple.com/jp/app/eshub/id6745217075"])
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
                                filteredEntries.sort {
                                    $0.totalDurationSeconds < $1.totalDurationSeconds
                                }
                                saveOrder()
                            } label: {
                                Text("おまかせ並べ替え")
                                    .foregroundColor(Color("primaryButtonColor"))
                            }
                        }
                        .padding()
                        
                        List {
                            ForEach(filteredEntries) { entry in
                                NavigationLink {
                                    ReceiveDetailView(entry: entry)
                                } label: {
                                    HStack {
                                        Text(entry.bandName)
                                        Spacer()
                                            .padding()
                                        Text(entry.totalDurationText)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
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
            if !filteredEntries.isEmpty {
                EditButton()
            }
        }
    }
    
    private func loadData() async {
        isLoading = true
        do {
            let entries = try await FirestoreManager.shared.fetchEntries(for: live)
            
            let savedOrder = UserDefaults.standard.stringArray(forKey: orderKey)
            if let savedOrder = savedOrder {
                filteredEntries = entries.sorted {
                    (savedOrder.firstIndex(of: $0.id) ?? Int.max) < (savedOrder.firstIndex(of: $1.id) ?? Int.max)
                }
            } else {
                filteredEntries = entries
            }
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        filteredEntries.move(fromOffsets: source, toOffset: destination)
        saveOrder()
    }
    
    private func saveOrder() {
        let order = filteredEntries.map(\.id)
        UserDefaults.standard.set(order, forKey: orderKey)
    }
    
    private func exportTimeTable() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var currentTime = selectedTime
        
        let timeTable = filteredEntries.map { entry in
            let startStr = dateFormatter.string(from: currentTime)
            let endTime = currentTime.addingTimeInterval(TimeInterval(entry.totalDurationSeconds))
            let endStr = dateFormatter.string(from: endTime)
            
            currentTime = endTime.addingTimeInterval(TimeInterval(selectedBreakTime * 60)) // 転換時間を加えて次の開始時間を設定
            
            return "\(startStr)〜\(endStr)  \(entry.bandName)"
        }.joined(separator: "\n")
        
        let activityVC = UIActivityViewController(activityItems: [timeTable], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func exportSoundRequests() {
        let soundData = filteredEntries.map { entry in
            let paired = entry.songs
                .filter(\.hasTitle)
                .map { "「\($0.title)」\($0.sound)" }
                .joined(separator: "\n")
            
            return "- \(entry.bandName) \(entry.totalDurationText)\n\(paired)"
        }.joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(activityItems: [soundData], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func exportLightRequests() {
        let lightData = filteredEntries.map { entry in
            let paired = entry.songs
                .filter(\.hasTitle)
                .map { "「\($0.title)」\($0.lighting)" }
                .joined(separator: "\n")
            
            return "- \(entry.bandName) \(entry.totalDurationText)\n\(paired)"
        }.joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(activityItems: [lightData], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    ReceiveListView(live: LiveEvent(id: "preview-live", name: "模擬データ", watchWord: "あいことば"))
}
