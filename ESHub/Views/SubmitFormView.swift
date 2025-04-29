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
    
    private let url = "https://script.google.com/macros/s/AKfycbzR2gu1kHuewcT2t-QDAX_t0VGMysK8q1twXlRE-3hKcCmTb4BxPvdQSPPyzKDZ1bDI7A/exec"
    private let error: Int = 3
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        Text("ライブ名：")
                        TextField("ライブ名を入力してください", text: $liveName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        Text("バンド名：")
                        TextField("バンド名を入力してください", text: $bandName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Text("曲名")
                        Text("時間")
                        Text("音響要望")
                        Text("照明要望")
                    }
                    .padding()
                    
                    ForEach($songs) { $song in
                        HStack {
                            TextField("曲名", text: $song.title)
                                .textFieldStyle(.roundedBorder)
                            Button("\(song.minute)分 \(song.second)秒") {
                                selectedSong = song.id
                                withAnimation {
                                    showPicker = true
                                }
                            }
                            .foregroundColor(Color("primaryButtonColor"))
                            TextField("音響", text: $song.sound)
                                .textFieldStyle(.roundedBorder)
                            TextField("照明", text: $song.lighting)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("バンドメンバー")
                    
                    ForEach($members) { $member in
                        HStack {
                            Text(member.role)
                                .frame(width: 50, alignment: .leading)
                            Text(":")
                            TextField("いない場合は空欄", text: $member.name)
                                .textFieldStyle(.roundedBorder)
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
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    NavigationLink(destination: SubmitCompleteView(), isActive: $isSubmitted) {
                        Button{
                            sendData()
                            isSubmitted = true
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("primaryButtonColor"))
                                .frame(width: 100, height: 50)
                                .shadow(radius: 5)
                                .overlay(Text("提出").font(.title))
                                .foregroundColor(.white)
                        }
                    }
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
            }
        }
        .navigationTitle("ESフォーム")
    }
    func sendData() {
        guard !liveName.isEmpty, !bandName.isEmpty else {
            print("ライブ名とバンド名を入力してください")
            return
        }
        guard songs.contains(where: { !$0.title.isEmpty }) else {
            print("少なくとも1曲は入力してください")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let dateString = formatter.string(from: Date())
        
        var es: [String: Any] = [
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
            "lighting": songs.map {"\($0.lighting)"}.joined(separator: ", ")
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
            case .failure(let error):
                print("エラー: \(error)")
            }
        }
    }
}

#Preview {
    SubmitFormView()
}
