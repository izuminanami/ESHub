//
//  SubmitFormView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct SubmitFormView: View {
    @ObservedObject  var interstitial = AdMobInterstitialView()
    @StateObject private var spreadSheetManager = LiveSheetManager()
    @State private var showPicker = false
    @State private var isSubmitted = false
    @State private var liveName: String = ""
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
    
    private let url = "https://script.google.com/macros/s/AKfycbzR2gu1kHuewcT2t-QDAX_t0VGMysK8q1twXlRE-3hKcCmTb4BxPvdQSPPyzKDZ1bDI7A/exec"
    
    var body: some View {
        GeometryReader { geometry in
            let formWidth = geometry.size.width / 1.5
            let titleFormWidth = geometry.size.width / 5
            let requestFormWidth = geometry.size.width / 4
            NavigationStack {
                ZStack {
                    Color("backgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Text("ライブ名：")
                            TextField("伝えられたライブ名を入力してください", text: $liveName)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: formWidth)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Text("バンド名：")
                            TextField("バンド名を入力してください", text: $bandName)
                                .textFieldStyle(.roundedBorder)
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
                                TextField("曲名", text: $song.title)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: titleFormWidth)
                                Button("\(song.minute)分\(song.second)秒") {
                                    selectedSong = song.id
                                    withAnimation {
                                        showPicker = true
                                    }
                                }
                                .foregroundColor(Color("primaryButtonColor"))
                                .frame(width: 80)
                                TextField("音響要望", text: $song.sound)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: requestFormWidth)
                                TextField("照明要望", text: $song.lighting)
                                    .textFieldStyle(.roundedBorder)
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
                                TextField("いない場合は空欄", text: $member.name)
                                    .textFieldStyle(.roundedBorder)
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
                        TextField("その他要望があれば入力してください", text: $otherRequest)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: formWidth)
                        
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
                    
                    VStack {
                        Spacer()
                        AdMobBannerView()
                            .frame(width: 320, height: 50)
                    }
                }
                .hideKeyboardOnTap()
                .task {
                    do {
                        try await spreadSheetManager.fetchGoogleSheetData()
                        print("success")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            .navigationTitle("ESを提出する(横画面推奨)")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    func sendData() {
        if isButtonEnabled {
            self.isButtonEnabled = false // 提出ボタン無効に。
            
            guard NetworkManager.shared.isConnected else {
                alertMessage = "ネットワークに接続されていません"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            guard !liveName.isEmpty else {
                alertMessage = "ライブ名を入力してください"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            guard !bandName.isEmpty else {
                alertMessage = "バンド名を入力してください"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            guard songs.contains(where: { !$0.title.isEmpty }) else {
                alertMessage = "少なくとも1曲は入力してください"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            guard spreadSheetManager.spreadSheetResponse.values.contains(where: { $0[0] == liveName }) else {
                alertMessage = "入力されたライブ名は存在しません"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let dateString = formatter.string(from: Date())
            
            let totalSeconds = songs.reduce(0) { $0 + ($1.minute * 60 + $1.second) }
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            let alltime = String(format: "%d:%02d:%02d", hours, minutes, seconds)
            
            let es: [String: Any] = [
                "date": dateString,
                "liveName": liveName,
                "bandName": bandName,
                "vo": members.count > 0 ? members[0].name : "",
                "gt1": members.count > 1 ? members[1].name : "",
                "gt2": members.count > 2 ? members[2].name : "",
                "ba": members.count > 3 ? members[3].name : "",
                "dr": members.count > 4 ? members[4].name : "",
                "key": members.count > 5 ? members[5].name : "",
                "se": se,
                "otherRequest": otherRequest,
                "title": songs.map {"\($0.title)"}.joined(separator: ", "),
                "time": songs.map { String(format: "%d:%02d", $0.minute, $0.second) }.joined(separator: ", "),
                "sound": songs.map {"\($0.sound)"}.joined(separator: ", "),
                "lighting": songs.map {"\($0.lighting)"}.joined(separator: ", "),
                "allTime": alltime
            ]
            
            let entrySheets = [es]
            
            AF.request(url,
                       method: .post,
                       parameters: ["entrySheets": entrySheets],
                       encoding: JSONEncoding.default
            ).responseString { response in
                switch response.result {
                case .success(let str):
                    print("成功: \(str)")
                    
                    interstitial.presentInterstitial() // インタースティシャル広告表示
                    isSubmitted = true // SubmitCompleteViewへ遷移
                    
                case .failure(let error):
                    print("エラー: \(error)")
                    
                    alertMessage = "提出失敗：\(error.localizedDescription)"
                    showAlert = true
                    
                }
                isButtonEnabled = true // 提出ボタン使用可能に。
            }
        }
    }
}

#Preview {
    SubmitFormView()
}
