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
                    VStack(spacing: 30) {
                        HStack {
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    showInfo = true
                                }
                            } label: {
                                HStack {
                                    Text("How to use")
                                        .foregroundColor(Color("emphasisColor"))
                                    
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(Color("emphasisColor"))
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        .padding(.horizontal, 50)
                        
                        HStack {
                            NavigationLink{
                                LiveCreateView()
                            } label: {
                                HomeMiddleButtonLabelComponent(text: "ライブを\n開催する")
                            }
                            
                            NavigationLink{
                                ReceiveLoginView()
                            } label: {
                                HomeMiddleButtonLabelComponent(text: "ESを\n確認する")
                            }
                        }
                        
                        NavigationLink{
                            SubmitFormView()
                        } label: {
                            LargeButtonLabelComponent(text: "ESを提出する", fillColor: "popupColor", textColor: Color("textColor"))
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
                            VStack(alignment: .leading, spacing: 10) {
                                Text("【ライブ主催者の方へ】")
                                    .font(.headline)
                                
                                Text("「ライブを開催する」からライブ名と合言葉を設定してください。\n設定後、ライブ名を出演希望者に伝えてください。\n集まったESは「ESを確認する」から管理できます。\n")
                                
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
