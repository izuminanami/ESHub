//
//  LiveCreateCompleteView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

struct LiveCreateCompleteView: View {
    @State private var isShareSheetPresentedForPerformers = false
    @State private var isShareSheetPresentedForCoOrganizers = false
    let liveName: String
    let watchWord: String
    private let orderKeyLiveName: String
    private let orderKeyWatchWord: String
    
    init(liveName: String, watchWord: String) {
        self.liveName = liveName
        self.watchWord = watchWord
        self.orderKeyLiveName = "sortedOrder_\(liveName)"
        self.orderKeyWatchWord = "sortedOrder_\(watchWord)"
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("作成完了")
                        .font(.title)
                    
                    Button {
                        isShareSheetPresentedForPerformers = true
                    } label: {
                        Text("出演希望者に伝える").font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
                    }
                    .sheet(isPresented: $isShareSheetPresentedForPerformers) {
                        ShareSheet(activityItems: ["「"+liveName+"」でES募集を開始しました。提出お願いします！\nhttps://apps.apple.com/jp/app/eshub/id6745217075"])
                    }
                    
                    Button {
                        isShareSheetPresentedForCoOrganizers = true
                    } label: {
                        Text("ライブ名と合言葉を共有").font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
                    }
                    .sheet(isPresented: $isShareSheetPresentedForCoOrganizers) {
                        ShareSheet(activityItems: ["ライブ名："+liveName+"\n合言葉："+watchWord])
                    }
                    
                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("ホームに戻る").font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
                    }
                }
                VStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(width: 320, height: 50)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LiveCreateCompleteView(liveName: "模擬データ", watchWord: "あいことば")
}
