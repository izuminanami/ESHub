//
//  AdMobInterstitialView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/01.
//

import SwiftUI
import UIKit
import GoogleMobileAds

class AdMobInterstitialView: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published  var interstitialLoaded: Bool = false
    var interstitialAd: InterstitialAd?
    
    override init() {
        super.init()
    }
    
    func loadInterstitial() {
        #if DEBUG
        let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
        #else
        let interstitialUnitID = "ca-app-pub-3453173920554262/5239304644"
        #endif
        
        InterstitialAd.load(with: interstitialUnitID, request: Request()) { (ad, error) in
            if let _ = error {
                print("読み込み失敗")
                self.interstitialLoaded = false
                return
            }
            print("読み込み成功")
            self.interstitialLoaded = true
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func presentInterstitial() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let root = windowScene?.windows.first!.rootViewController
        if let ad = interstitialAd {
            ad.present(from: root!)
            self.interstitialLoaded = false
        } else {
            print("広告の準備ができていません")
            self.interstitialLoaded = false
            self.loadInterstitial()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("表示失敗")
        self.loadInterstitial()
    }
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("表示成功")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("広告が閉じられた")
    }
}
