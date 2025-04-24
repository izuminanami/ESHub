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
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 50) {
                    HStack {
                        Spacer()
                        
                        Text("How to use")
                            .foregroundColor(Color("accentColor"))
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color("accentColor"))
                            .font(.system(size: 30))
                    }
                    .padding(.horizontal, 50)
                    
                    NavigationLink{
                        ReceiveLoginView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("primaryButtonColor"))
                            .frame(width: 300, height: 150)
                            .overlay(Text("ESを集める").font(.title))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    NavigationLink{
                        SubmitFormView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("popupColor"))
                            .frame(width: 300, height: 150)
                            .overlay(Text("ESを提出する").font(.title))
                            .foregroundColor(Color("textColor"))
                            .shadow(radius: 5)
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
