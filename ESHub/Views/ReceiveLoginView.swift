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
    @State var alertMessage = ""
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
                        displayData()
                    } label: {
                        SmallButtonLabelComponent(text: "表示")
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("表示エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .navigationDestination(isPresented: $isAuthorized) {
                        ReceiveListView(liveName: liveName)}
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
        .navigationTitle("ESを確認する")
    }
    private func displayData() {
        guard NetworkManager.shared.isConnected else {
            alertMessage = "ネットワークに接続されていません"
            showAlert = true
            return
        }
        guard !(liveName.isEmpty && watchWord.isEmpty) else {
            alertMessage = "ライブ名と合言葉を入力してください"
            showAlert = true
            return
        }
        guard !liveName.isEmpty else {
            alertMessage = "ライブ名を入力してください"
            showAlert = true
            return
        }
        guard spreadSheetManager.spreadSheetResponse.values.contains(where: { $0[0] == liveName}) else {
            alertMessage = "入力されたライブ名は存在しません"
            showAlert = true
            return
        }
        guard !watchWord.isEmpty else {
            alertMessage = "合言葉を入力してください"
            showAlert = true
            return
        }
        guard spreadSheetManager.spreadSheetResponse.values.contains(where: { $0[0] == liveName && $0[1] == watchWord }) else {
            alertMessage = "合言葉が正しくありません"
            showAlert = true
            return
        }
        isAuthorized = true
    }
}

#Preview {
    ReceiveLoginView()
}
