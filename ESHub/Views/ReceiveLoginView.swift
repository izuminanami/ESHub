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
    private let spacerHeight: CGFloat = 50
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    UnderlineTextFieldStyleComponent(title: "ライブ名", placeholder: "ライブ名を入力してください", inputText: $liveName)
                    
                    Text("作成したライブ名を入力してください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    UnderlineTextFieldStyleComponent(title: "合言葉", placeholder: "合言葉を入力してください", inputText: $watchWord)
                    
                    Text("設定した合言葉を入力してください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
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
                    
                    Spacer()
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
