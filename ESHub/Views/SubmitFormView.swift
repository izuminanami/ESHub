//
//  SubmitFormView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitFormView: View {
    @State var inputName1 = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    HStack {
                        Text("ライブ名：")
                        TextField("ライブ名を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding()
                    
                    HStack {
                        Text("バンド名：")
                        TextField("バンド名を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .padding()
                    
                    HStack {
                        Text("曲順")
                        Text("時間")
                        Text("照明リクエスト")
                        Text("音響リクエスト")
                    }
                    .padding()
                    
                    HStack {
                        TextField("曲順を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                        TextField("時間を入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                        TextField("照明リクエストを入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                        TextField("音響リクエストを入力してください", text: $inputName1)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
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
                            .fill(.blue)
                            .frame(width: 100, height: 50)
                            .overlay(Text("提出").font(.title))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    SubmitFormView()
}
