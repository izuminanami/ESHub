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
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    Text("ライブ名")
                    TextField("ex) 2025/5/1_ES大学軽音部_新歓ライブ", text: $liveName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("日付、団体名、ライブタイトルなどを含めて被らないものにしてください。")
                        .foregroundColor(.gray)
                        .padding()
                    
//                    Text("あいことば")
//                    TextField("あいことばを入力してください", text: $watchWord)
//                        .textFieldStyle(.roundedBorder)
//                        .padding()
//                    
//                    Text("容易に推測されるあいことばは使用しないでください。")
//                        .foregroundColor(.gray)
//                        .padding()
                    
                    NavigationLink {
                        ReceiveListView(liveName: liveName)
                    } label: {
                        SmallButtonLabelComponent(text: "ログイン")
                    }
                }
                VStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(width: 320, height: 50)
                }
            }
            .hideKeyboardOnTap()
        }
        .navigationTitle("ログイン")
    }
}

#Preview {
    ReceiveLoginView()
}
