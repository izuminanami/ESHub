//
//  AdMobBannerView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/01.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        banner.adUnitID = "ca-app-pub-3453173920554262/1854000506"
        #endif
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
}
