//
//  SubmitFormView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitFormView: View {
    @ObservedObject  var interstitial = AdMobInterstitialView()
    @StateObject private var store = Store()
    @State private var showPicker = false
    @State private var isSubmitted = false
    @State private var entryURLText: String
    @State private var bandName: String = ""
    @State private var otherRequest: String = ""
    @State private var se = "あり"
    @State private var songs: [SongEntry] = (0..<10).map { _ in
        SongEntry(title: "", minute: 0, second: 0, sound: "", lighting: "")
    }
    @State private var selectedSong: UUID?
    @State private var members: [BandMember] = [
        BandMember(role: "Vo.", name: ""),
        BandMember(role: "Gt1.", name: ""),
        BandMember(role: "Gt2.", name: ""),
        BandMember(role: "Ba.", name: ""),
        BandMember(role: "Dr.", name: ""),
        BandMember(role: "Key.", name: "")
    ]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isButtonEnabled = true // 提出ボタン連打対策
    let live: LiveEvent?
    
    init(live: LiveEvent? = nil) {
        self.live = live
        _entryURLText = State(initialValue: live?.entryURL.absoluteString ?? "")
    }
    
    var body: some View {
        GeometryReader { geometry in
            let formWidth = geometry.size.width / 1.5
            let titleFormWidth = geometry.size.width / 5
            let requestFormWidth = geometry.size.width / 4
            let otherRequestFormWidth = geometry.size.width / 1.25
            NavigationStack {
                ZStack {
                    Color("backgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        Spacer()
                            .frame(height: 20)
                        
                        if let live {
                            HStack {
                                Text("ライブ名：")
                                Text(live.name)
                                    .frame(width: formWidth, alignment: .leading)
                                    .foregroundColor(Color("primaryButtonColor"))
                            }
                            .padding(.horizontal)
                        } else {
                            HStack {
                                Text("応募URL：")
                                UnderlineTextFieldStyleComponent(title: nil, placeholder: "共有されたURLを入力してください", inputText: $entryURLText)
                                    .frame(width: formWidth)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Text("バンド名：")
                            UnderlineTextFieldStyleComponent(title: nil, placeholder: "バンド名を入力してください", inputText: $bandName)
                                .frame(width: formWidth)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("曲名")
                                .frame(width: titleFormWidth, alignment: .leading)
                            Text("時間")
                                .frame(width: 80, alignment: .leading)
                            Text("音響要望")
                                .frame(width: requestFormWidth, alignment: .leading)
                            Text("照明要望")
                                .frame(width: requestFormWidth, alignment: .leading)
                        }
                        .padding()
                        
                        ForEach($songs) { $song in
                            HStack {
                                UnderlineTextFieldStyleComponent(title: nil, placeholder: "曲名", inputText: $song.title)
                                    .frame(width: titleFormWidth)
                                Button("\(song.minute)分\(song.second)秒") {
                                    selectedSong = song.id
                                    withAnimation {
                                        showPicker = true
                                    }
                                }
                                .foregroundColor(Color("primaryButtonColor"))
                                .frame(width: 80)
                                UnderlineTextFieldStyleComponent(title: nil, placeholder: "音響要望", inputText: $song.sound)
                                    .frame(width: requestFormWidth)
                                UnderlineTextFieldStyleComponent(title: nil, placeholder: "照明要望", inputText: $song.lighting)
                                    .frame(width: requestFormWidth)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("バンドメンバー")
                        Text("リーダーの名前の前に⭐︎をつけてください")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ForEach($members) { $member in
                            HStack {
                                Text(member.role)
                                    .frame(width: 50, alignment: .leading)
                                Text(":")
                                UnderlineTextFieldStyleComponent(title: nil, placeholder: "いない場合は空欄", inputText: $member.name)
                                    .frame(width: formWidth)
                            }
                            .padding(.horizontal)
                        }
                        
                        // ToDoセット図を実装
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("SE")
                        Picker("", selection: $se) {
                            ForEach(["あり", "なし"], id: \.self) { Text("\($0)") }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("その他")
                        UnderlineTextFieldStyleComponent(title: nil, placeholder: "その他要望があれば入力してください", inputText: $otherRequest)
                            .frame(width: otherRequestFormWidth)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Button{
                            sendData()
                        } label: {
                            SmallButtonLabelComponent(text: "提出")
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("提出エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        .navigationDestination(isPresented: $isSubmitted) {
                            SubmitCompleteView()
                        }
                        .onAppear() {
                            interstitial.loadInterstitial()
                        }.disabled(!isButtonEnabled)
                        
                        Spacer()
                            .frame(height: 70)
                    }
                    if showPicker {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showPicker = false // 背景タップでも閉じられるように
                            }
                        if let index = songs.firstIndex(where: { $0.id == selectedSong }) {
                            VStack(spacing: 20) {
                                HStack(spacing: 30) {
                                    Picker("分", selection: $songs[index].minute) {
                                        ForEach(0 ..< 20, id: \.self) { Text("\($0)分") }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 100)
                                    .clipped()
                                    
                                    Picker("秒", selection: $songs[index].second) {
                                        ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { Text("\($0)秒") }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 100)
                                    .clipped()
                                }
                                Button("完了") {
                                    withAnimation { // ToDo機能してない
                                        showPicker = false
                                    }
                                }
                                .frame(width: 60, height: 40)
                                .shadow(radius: 5)
                                .background(Color("primaryButtonColor"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .frame(width: 300, height: 400)
                            .background(Color("popupColor"))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                        }
                    }
                    
                    if isButtonEnabled == false {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Please wait...")
                    }
                    if !store.isPurchased {
                        AdBannerContainerView()
                    }
                }
                .hideKeyboardOnTap()
            }
            .navigationTitle("ESを提出する(横画面推奨)")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    func sendData() {
        guard isButtonEnabled else {
            return
        }
        
        isButtonEnabled = false
        
        let trimmedEntryURL = entryURLText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBandName = bandName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard NetworkManager.shared.isConnected else {
            alertMessage = "ネットワークに接続されていません"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard live != nil || !trimmedEntryURL.isEmpty else {
            alertMessage = "応募URLを入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard !trimmedBandName.isEmpty else {
            alertMessage = "バンド名を入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard songs.contains(where: \.hasTitle) else {
            alertMessage = "少なくとも1曲は入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        
        let draft = LiveEntryDraft(
            bandName: trimmedBandName,
            members: members,
            songs: songs,
            seEnabled: se == "あり",
            otherRequest: otherRequest
        )
        
        Task {
            do {
                let targetLive: LiveEvent
                if let live {
                    targetLive = live
                } else {
                    guard
                        let url = URL(string: trimmedEntryURL),
                        let destination = DeepLinkDestination(url: url),
                        case .entry(let liveID) = destination,
                        let fetchedLive = try await FirestoreManager.shared.fetchLive(id: liveID)
                    else {
                        await MainActor.run {
                            alertMessage = "応募URLが正しくありません"
                            showAlert = true
                            isButtonEnabled = true
                        }
                        return
                    }
                    
                    targetLive = fetchedLive
                }
                
                guard !targetLive.name.isEmpty else {
                    await MainActor.run {
                        alertMessage = "入力されたライブは存在しません"
                        showAlert = true
                        isButtonEnabled = true
                    }
                    return
                }
                
                _ = try await FirestoreManager.shared.submitEntry(to: targetLive, draft: draft)
                
                await MainActor.run {
                    if !store.isPurchased {
                        interstitial.presentInterstitial() // インタースティシャル広告表示
                    }
                    isSubmitted = true // SubmitCompleteViewへ遷移
                    isButtonEnabled = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "提出失敗：\(error.localizedDescription)"
                    showAlert = true
                    isButtonEnabled = true // 提出ボタン使用可能に。
                }
            }
        }
    }
}

#Preview {
    SubmitFormView()
}
