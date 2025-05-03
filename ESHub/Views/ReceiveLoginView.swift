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
                    TextField("ライブ名を入力してください", text: $liveName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("作成したライブ名を入力してください")
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("あいことば")
                    TextField("あいことばを入力してください", text: $watchWord)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("設定したあいことばを入力してください")
                        .foregroundColor(.gray)
                        .padding()
                    
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
