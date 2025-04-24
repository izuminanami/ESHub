//
//  SubmitFormView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitFormView: View {
    @State private var liveName = ""
    @State private var bandName = ""
    @State private var otherRequest = ""
    @State private var SE = "あり"
    @State private var memberNames: [String: String] = [:]
    @State private var showPicker = false
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
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Spacer()
                    HStack {
                        Text("ライブ名：")
                        TextField("ライブ名を入力してください", text: $liveName)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("バンド名：")
                        TextField("バンド名を入力してください", text: $bandName)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Text("曲名")
                        Text("時間")
                        Text("音響\nリクエスト")
                        Text("照明\nリクエスト")
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
                        .frame(height: 30)
                    
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
                        .frame(height: 30)
                    
                    Text("SE")
                    Picker("", selection: $SE) {
                        ForEach(["あり", "なし"], id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("その他")
                    TextField("その他要望があれば入力してください", text: $otherRequest)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    NavigationLink{
                        SubmitCompleteView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("primaryButtonColor"))
                            .frame(width: 100, height: 50)
                            .overlay(Text("提出").font(.title))
                            .foregroundColor(.white)
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
                                    ForEach(0 ..< 21, id: \.self) { Text("\($0)分") }
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
}

#Preview {
    SubmitFormView()
}
