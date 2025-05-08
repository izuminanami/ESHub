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
    @StateObject private var store = Store()
    @State private var showInfo = false
    @State private var showAds = false
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
                        if !store.isPurchased {
                            Button {
                                withAnimation {
                                    showAds = true
                                }
                            } label: {
                                AdRemoveIcon()
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showInfo = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 30))
                            }
                        }
                    }
                    .foregroundColor(Color("emphasisColor"))
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
                
                if showAds {
                    ZStack {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showAds = false
                            }
                        VStack(spacing: 30) {
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation { // ToDo機能してない
                                        showAds = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color("primaryButtonColor"))
                                        .font(.system(size: 30))
                                }
                            }
                            VStack(spacing: 30) {
                                if let product = store.removeAdsProduct {
                                    Text("【ESHub Premium】")
                                        .font(.title)
                                    
                                    Text ("「プレミアム機能：広告の削除」\n一度の購入で、永続的に広告を非表示にできます")
                                    
                                    Text("¥320")
                                        .font(.headline)
                                    
                                    Button {
                                        Task {
                                            await store.purchase(product: product)
                                        }
                                    } label: {
                                        SmallButtonLabelComponent(text: "購入")
                                    }
                                } else {
                                    ProgressView("loading...")
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .frame(width: 300, height: 500)
                        .background(Color("popupColor"))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
        }
        .task {
            await store.loadProducts()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}
