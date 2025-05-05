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
let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

struct HomeView: View {
    @State private var showInfo = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Button {
                        requestReview()
                    } label: {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showInfo = true
                            }
                        } label: {
                            HStack {
                                Text("How to use")
                                
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 30))
                            }
                            .foregroundColor(Color("emphasisColor"))
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    NavigationLink{
                        LiveCreateView()
                    } label: {
                        LargeButtonLabelComponent(text: "ライブを開催する", systemName: "music.mic", fillColor: "primaryButtonColor", textColor: .white)
                    }
                    
                    NavigationLink{
                        ReceiveLoginView()
                    } label: {
                        LargeButtonLabelComponent(text: "ESを確認する", systemName: "doc.text.magnifyingglass", fillColor: "primaryButtonColor", textColor: .white)
                    }
                    
                    NavigationLink{
                        SubmitFormView()
                    } label: {
                        LargeButtonLabelComponent(text: "ESを提出する", systemName: "tray.and.arrow.up", fillColor: "popupColor", textColor: Color("textColor"))
                    }
                    
                    HStack {
                        Spacer()
                        Text("version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "???")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
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
