//
//  HomeView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/22.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}

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
                        LiveCreateView()
                    } label: {
                        LargeButtonLabelComponent(text: "ライブを開催する", color: "primaryButtonColor")
                    }
                    
                    NavigationLink{
                        ReceiveLoginView()
                    } label: {
                        LargeButtonLabelComponent(text: "ESを確認する", color: "primaryButtonColor")
                    }
                    
                    NavigationLink{
                        SubmitFormView()
                    } label: {
                        LargeButtonLabelComponent(text: "ESを提出する", color: "popupColor")
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
                        
                        Text("画面を横にすると入力や表示がしやすいです。")
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 300, height: 500)
                    .background(Color("popupColor"))
                    .cornerRadius(20)
                    .shadow(radius: 5)
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
    HomeView()
}
