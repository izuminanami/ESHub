//
//  SubmitCompleteView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct SubmitCompleteView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    Text("提出完了！")
                        .font(.title)
                    
                    NavigationLink{
                        HomeView()
                    } label: {
                        Text("ホームに戻る").font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SubmitCompleteView()
}
