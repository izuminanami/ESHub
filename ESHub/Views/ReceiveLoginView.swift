//
//  ReceiveLoginView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct ReceiveLoginView: View {
    @StateObject private var store = Store()
    @State private var isAuthorized = false
    @State private var authorizedLive: LiveEvent?
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
                        if let authorizedLive {
                            ReceiveListView(live: authorizedLive)
                        }
                    }
                    
                    Spacer()
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
            .hideKeyboardOnTap()
        }
        .navigationTitle("ESを確認する")
    }
    private func displayData() {
        let trimmedLiveName = liveName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWatchWord = watchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard NetworkManager.shared.isConnected else {
            alertMessage = "ネットワークに接続されていません"
            showAlert = true
            return
        }
        guard !(trimmedLiveName.isEmpty && trimmedWatchWord.isEmpty) else {
            alertMessage = "ライブ名と合言葉を入力してください"
            showAlert = true
            return
        }
        guard !trimmedLiveName.isEmpty else {
            alertMessage = "ライブ名を入力してください"
            showAlert = true
            return
        }
        guard !trimmedWatchWord.isEmpty else {
            alertMessage = "合言葉を入力してください"
            showAlert = true
            return
        }
        
        Task {
            do {
                guard let live = try await FirestoreManager.shared.fetchLive(named: trimmedLiveName) else {
                    await MainActor.run {
                        alertMessage = "入力されたライブ名は存在しません"
                        showAlert = true
                    }
                    return
                }
                
                guard live.watchWord == trimmedWatchWord else {
                    await MainActor.run {
                        alertMessage = "合言葉が正しくありません"
                        showAlert = true
                    }
                    return
                }
                
                await MainActor.run {
                    liveName = live.name
                    watchWord = live.watchWord
                    authorizedLive = live
                    isAuthorized = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "表示失敗：\(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    ReceiveLoginView()
}
