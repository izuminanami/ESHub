//
//  LiveCreateCompleteView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

struct LiveCreateCompleteView: View {
    @StateObject private var store = Store()
    @State private var isShareSheetPresentedForPerformers = false
    @State private var isShareSheetPresentedForManagers = false
    let live: LiveEvent
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("作成完了")
                        .font(.title)
                    
                    HStack {
                        Button {
                            isShareSheetPresentedForManagers = true
                        } label: {
                            MiddleButtonLabelComponent(text: "管理URL共有")
                        }
                        .sheet(isPresented: $isShareSheetPresentedForManagers) {
                            ShareSheet(activityItems: [
                                "「\(live.name)」の応募管理URLです。\n主催者のみで共有してください。\n\(live.manageURL.absoluteString)"
                            ])
                        }
                        
                        Button {
                            isShareSheetPresentedForPerformers = true
                        } label: {
                            MiddleButtonLabelComponent(text: "応募URL共有")
                        }
                        .sheet(isPresented: $isShareSheetPresentedForPerformers) {
                            ShareSheet(activityItems: [
                                "「\(live.name)」のエントリーを開始しました。\nURLから提出してください。\n\(live.entryURL.absoluteString)\nインストール: https://apps.apple.com/jp/app/eshub/id6745217075"
                            ])
                        }
                    }
                    
                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("ホームに戻る").font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
                    }
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LiveCreateCompleteView(live: LiveEvent(id: "preview-live", name: "模擬データ"))
}
