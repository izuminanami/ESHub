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
    @State var manageURLText = ""
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
                    
                    UnderlineTextFieldStyleComponent(title: "管理URL", placeholder: "管理用URLを入力してください", inputText: $manageURLText)
                    
                    Text("ライブ作成完了画面で共有される管理用URLを入力してください")
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
        let trimmedManageURL = manageURLText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard NetworkManager.shared.isConnected else {
            alertMessage = "ネットワークに接続されていません"
            showAlert = true
            return
        }
        guard !trimmedManageURL.isEmpty else {
            alertMessage = "管理URLを入力してください"
            showAlert = true
            return
        }
        
        Task {
            do {
                guard
                    let url = URL(string: trimmedManageURL),
                    let destination = DeepLinkDestination(url: url),
                    case .manage(let adminToken) = destination
                else {
                    await MainActor.run {
                        alertMessage = "管理URLが正しくありません"
                        showAlert = true
                    }
                    return
                }
                
                guard let live = try await FirestoreManager.shared.fetchLive(adminToken: adminToken) else {
                    await MainActor.run {
                        alertMessage = "入力されたライブは存在しません"
                        showAlert = true
                    }
                    return
                }
                
                await MainActor.run {
                    manageURLText = live.manageURL.absoluteString
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
