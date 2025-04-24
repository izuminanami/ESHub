//
//  HomeView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 50) {
                    HStack {
                        Spacer()
                        
                        Text("How to use")
                            .foregroundColor(.blue)
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                    }
                    .padding(.horizontal, 50)
                    
                    NavigationLink{
                        ReceiveLoginView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.orange)
                            .frame(width: 300, height: 150)
                            .overlay(Text("ESを集める").font(.title))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                    
                    NavigationLink{
                        SubmitFormView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray)
                            .frame(width: 300, height: 150)
                            .overlay(Text("ESを提出する").font(.title))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}
