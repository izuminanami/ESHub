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
                        InfoComponent(action: {showInfo = false})
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
