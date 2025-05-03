//
//  ReceiveLoginView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveLoginView: View {
    @StateObject private var spreadSheetManager = LiveSheetManager()
    @State private var isAuthorized = false
    @State private var showAlert = false
    @State var liveName = ""
    @State var watchWord = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    Text("ライブ名")
                        .font(.title2)
                    TextField("ライブ名を入力してください", text: $liveName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("作成したライブ名を入力してください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("合言葉")
                        .font(.title2)
                    TextField("合言葉を入力してください", text: $watchWord)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("設定した合言葉を入力してください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Button {
                        if spreadSheetManager.spreadSheetResponse.values.contains(where: { $0[0] == liveName && $0[1] == watchWord }) {
                            isAuthorized = true
                        } else {
                            showAlert = true
                        }
                    } label: {
                        SmallButtonLabelComponent(text: "表示")
                    }
                    .navigationDestination(isPresented: $isAuthorized) {
                        ReceiveListView(liveName: liveName)}
                    .alert("ライブ名または合言葉が正しくありません", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
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
        .navigationTitle("ログイン")
    }
}

#Preview {
    ReceiveLoginView()
}
