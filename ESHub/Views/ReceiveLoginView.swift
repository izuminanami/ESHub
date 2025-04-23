//
//  ReceiveLoginView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveLoginView: View {
    var body: some View {
        @State var inputName11 = ""
        @State var inputName12 = ""
        NavigationStack {
            VStack(spacing: 10) {
                Text("ライブ名")
                TextField("ライブ名を入力してください", text: $inputName11)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Text("日付、団体名、ライブタイトルなどを含めて被らないものにしてください。")
                    .foregroundColor(.gray)
                    .padding()
                
                Text("パスワード")
                TextField("パスワードを入力してください", text: $inputName12)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Text("容易に推測されるパスワードは使用しないでください。")
                    .foregroundColor(.gray)
                    .padding()
                
                NavigationLink{
                    ReceiveListView()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .frame(width: 150, height: 50)
                        .overlay(Text("ログイン/作成").font(.title3))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ReceiveLoginView()
}
