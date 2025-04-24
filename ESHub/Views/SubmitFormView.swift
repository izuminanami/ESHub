//
//  SubmitFormView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitFormView: View {
    @State var inputName1 = ""
    @State var memberNames: [String: String] = [:]
    @State private var showPicker = false
    @State private var minute = 0
    @State private var second = 0
    let roles = ["Vo.", "LGt.", "BGt.", "Ba.", "Dr.", "Key."]
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    HStack {
                        Text("ライブ名：")
                        TextField("ライブ名を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("バンド名：")
                        TextField("バンド名を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 60) {
                        Text("曲名")
                        Text("時間")
                        Text("照明")
                        Text("音響")
                    }
                    .padding()
                    
                    ForEach(0 ..< 3) { row in
                        HStack {
                            TextField("曲名", text: $inputName1)
                                .textFieldStyle(.roundedBorder)
                            Button("\(minute)分 \(second)秒") {
                                    withAnimation {
                                        showPicker = true
                                    }
                                }
                            .foregroundColor(Color("primaryButtonColor"))
                            TextField("照明", text: $inputName1)
                                .textFieldStyle(.roundedBorder)
                            TextField("音響", text: $inputName1)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    ForEach(roles, id: \.self) { role in
                        HStack {
                            Text(role)
                                .frame(width: 50, alignment: .leading)
                            
                            Text(":")
                            
                            TextField("いない場合は空欄", text: Binding(
                                get: { memberNames[role] ?? "" },
                                set: { memberNames[role] = $0 }
                            ))
                            .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Text("セット図") //最初はなくても良いかも
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 300, height: 200)
                    
                    Text("その他")
                    TextField("その他要望を入力してください", text: $inputName1)
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
                VStack(spacing: 20) {
                        HStack(spacing: 30) {
                            Picker("分", selection: $minute) {
                                ForEach(0 ..< 21, id: \.self) { Text("\($0)分") }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                            .clipped()
                            
                            Picker("秒", selection: $second) {
                                ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { Text("\($0)秒") }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                            .clipped()
                        }
                        Button("完了") {
                            withAnimation {
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
                .cornerRadius(12)
                .shadow(radius: 10)
                }
            }
        }
        .navigationTitle("ESフォーム")
    }
}

#Preview {
    SubmitFormView()
}
