//
//  LiveCreateCompleteView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

struct LiveCreateCompleteView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("作成完了")
                        .font(.title)
                    
                    Button {
                        
                    } label: {
                        Text("出演者に伝える").font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
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
    LiveCreateCompleteView()
}
