//
//  LiveCreateView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct LiveCreateView: View {
    @ObservedObject  var interstitial = AdMobInterstitialView()
    @State private var isCreated = false
    @State private var liveName: String = ""
    @State private var watchWord: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isButtonEnabled = true // 提出ボタン連打対策
    private let url = "https://script.google.com/macros/s/AKfycbya3qm5dfs4yGttbQvCZFYjS-wxZ13bYwj8tsSF4QTis1vve7j2zgAv2NSszQ9G93vMPQ/exec"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    Text("ライブ名")
                        .font(.title2)
                    TextField("ex) 2025/5/1_ES大学軽音部_新歓ライブ", text: $liveName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("日付、団体名、ライブタイトルなどを含めて被らないものにしてください")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("合言葉")
                        .font(.title2)
                    TextField("合言葉を設定してください", text: $watchWord)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Text("合言葉は集まったESを確認するのに使用します")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Button{
                        sendData()
                    } label: {
                        SmallButtonLabelComponent(text: "作成")
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("作成エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .navigationDestination(isPresented: $isCreated) {
                        LiveCreateCompleteView(liveName: liveName, watchWord: watchWord)
                    }
                    .onAppear() {
                        interstitial.loadInterstitial()
                    }.disabled(!interstitial.interstitialLoaded)
                    
                    Spacer()
                        .frame(height: 70)
                }
                
                if isButtonEnabled == false {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Please wait...")
                }
                
                VStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(width: 320, height: 50)
                }
            }
            .hideKeyboardOnTap()
        }
        .navigationTitle("ライブ作成")
    }
    
    func sendData() {
        if isButtonEnabled {
            self.isButtonEnabled = false // 提出ボタン無効に。
            
            guard !liveName.isEmpty else {
                alertMessage = "ライブ名を入力してください"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            guard !watchWord.isEmpty else {
                alertMessage = "合言葉を入力してください"
                showAlert = true
                isButtonEnabled = true // 提出ボタン使用可能に。
                return
            }
            
            let live: [String: Any] = [
                "liveName": liveName,
                "watchWord": watchWord
            ]
            
            AF.request(url,
                       method: .post,
                       parameters: ["liveSheets": [live]],
                       encoding: JSONEncoding.default
            ).responseString { response in
                switch response.result {
                case .success(let str):
                    print("成功: \(str)")
                    
                    interstitial.presentInterstitial() // インタースティシャル広告表示
                    isCreated = true // LiveCreateCompleteViewへ遷移
                    
                case .failure(let error):
                    print("エラー: \(error)")
                    
                    alertMessage = "作成失敗：\(error.localizedDescription)"
                    showAlert = true
                    
                }
                isButtonEnabled = true // 提出ボタン使用可能に。
            }
        }
    }
}

#Preview {
    LiveCreateView()
}
