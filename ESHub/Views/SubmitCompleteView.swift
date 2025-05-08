//
//  SubmitCompleteView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitCompleteView: View {
    @StateObject private var store = Store()
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("提出完了")
                        .font(.title)
                    
                    NavigationLink{
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
    SubmitCompleteView()
}
