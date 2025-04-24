//
//  ReceiveLoginView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveLoginView: View {
    @State var liveName = ""
    @State var watchWord = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    Text("ライブ名")
                    TextField("ex) 2025/5/1_◯◯大学軽音部_新歓ライブ", text: $liveName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("日付、団体名、ライブタイトルなどを含めて被らないものにしてください。")
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("あいことば")
                    TextField("あいことばを入力してください", text: $watchWord)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("容易に推測されるパスワードは使用しないでください。")
                        .foregroundColor(.gray)
                        .padding()
                    
                    NavigationLink{
                        ReceiveListView(liveName: liveName)
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
        .navigationTitle("ログイン")
    }
}

#Preview {
    ReceiveLoginView()
}
