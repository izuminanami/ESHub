//
//  HomeView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI

struct HomeView: View {
    @State private var showInfo = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 50) {
                    HStack {
                        Spacer()
                        
                        Text("How to use")
                            .foregroundColor(Color("emphasisColor"))
                        
                        Button {
                            withAnimation {
                                showInfo = true
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(Color("emphasisColor"))
                                .font(.system(size: 30))
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    NavigationLink{
                        ReceiveLoginView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("primaryButtonColor"))
                            .frame(width: 300, height: 150)
                            .shadow(radius: 5)
                            .overlay(Text("ESを集める").font(.title))
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink{
                        SubmitFormView()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("popupColor"))
                            .frame(width: 300, height: 150)
                            .shadow(radius: 5)
                            .overlay(Text("ESを提出する").font(.title))
                            .foregroundColor(Color("textColor"))
                    }
                }
                if showInfo {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showInfo = false // 背景タップでも閉じられるように
                        }
                        VStack(spacing: 30) {
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation { // ToDo機能してない
                                        showInfo = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color("primaryButtonColor"))
                                        .font(.system(size: 30))
                                }
                            }
                            Text("使い方")
                            
                            Spacer()
                    }
                    .frame(width: 300, height: 500)
                    .background(Color("popupColor"))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}
