//
//  LiveCreateView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

struct LiveCreateView: View {
    @ObservedObject  var interstitial = AdMobInterstitialView()
    @StateObject private var store = Store()
    @State private var isCreated = false
    @State private var createdLive: LiveEvent?
    @State private var liveName: String = ""
    @State private var watchWord: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isButtonEnabled = true // 提出ボタン連打対策
    private let spacerHeight: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    UnderlineTextFieldStyleComponent(title: "ライブ名", placeholder: "ex) 2025/5/1_ES大学軽音部_新歓ライブ", inputText: $liveName)
                    
                    Text("日付、団体名、ライブタイトルなどを含めて被らないものにしてください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    UnderlineTextFieldStyleComponent(title: "合言葉", placeholder: "合言葉を設定してください", inputText: $watchWord)
                    
                    Text("合言葉は集まったESを確認するのに使用します")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    Button {
                        sendData()
                    } label: {
                        SmallButtonLabelComponent(text: "作成")
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("作成エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .navigationDestination(isPresented: $isCreated) {
                        if let createdLive {
                            LiveCreateCompleteView(liveName: createdLive.name, watchWord: createdLive.watchWord)
                        }
                    }
                    .onAppear() {
                        interstitial.loadInterstitial()
                    }.disabled(!isButtonEnabled)
                    
                    Spacer()
                }
                
                if isButtonEnabled == false {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Please wait...")
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
            .hideKeyboardOnTap()
        }
        .navigationTitle("ライブを開催する")
    }
    
    func sendData() {
        guard isButtonEnabled else {
            return
        }
        
        isButtonEnabled = false
        
        let trimmedLiveName = liveName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWatchWord = watchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard NetworkManager.shared.isConnected else {
            alertMessage = "ネットワークに接続されていません"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard !(trimmedLiveName.isEmpty && trimmedWatchWord.isEmpty) else {
            alertMessage = "ライブ名と合言葉を入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard !trimmedLiveName.isEmpty else {
            alertMessage = "ライブ名を入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        guard !trimmedWatchWord.isEmpty else {
            alertMessage = "合言葉を入力してください"
            showAlert = true
            isButtonEnabled = true
            return
        }
        
        Task {
            do {
                let live = try await FirestoreManager.shared.createLive(
                    name: trimmedLiveName,
                    watchWord: trimmedWatchWord
                )
                
                await MainActor.run {
                    liveName = live.name
                    watchWord = live.watchWord
                    createdLive = live
                    isCreated = true
                    
                    if !store.isPurchased {
                        interstitial.presentInterstitial() // インタースティシャル広告表示
                    }
                    isButtonEnabled = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "作成失敗：\(error.localizedDescription)"
                    showAlert = true
                    
                    isButtonEnabled = true // 提出ボタン使用可能に。
                }
            }
        }
    }
}

#Preview {
    LiveCreateView()
}
