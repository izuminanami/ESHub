//
//  InfoView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/05.
//

import SwiftUI

public struct InfoComponent: View {
    private let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    action() // 背景タップでも閉じられるように
                }
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation { // ToDo機能してない
                            action()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("primaryButtonColor"))
                            .font(.system(size: 30))
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("【ライブ主催者の方へ】")
                        .font(.headline)
                    
                    Text("「ライブを開催する」からライブ名と合言葉を設定してください。\n設定後、ライブ名を出演希望者に伝えてください。\n集まったESは「ESを確認する」から管理、出力できます。\n")
                    
                    Text("【出演希望者の方へ】")
                        .font(.headline)
                    
                    Text("「ESを提出する」から主催者に伝えられたライブ名を入力し、必要な情報を記入してESを提出してください。")
                }
                .font(.body)
                .multilineTextAlignment(.leading)
                
                
                Spacer()
            }
            .padding()
            .frame(width: 300, height: 500)
            .background(Color("popupColor"))
            .cornerRadius(20)
            .shadow(radius: 5)
        }
    }
}
