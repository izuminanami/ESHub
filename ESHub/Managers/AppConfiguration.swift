//
//  AppConfiguration.swift
//  ESHub
//
//  Created by 泉七海 on 2026/04/18.
//

import Foundation

enum AppConfiguration {
    static var adMobAppID: String {
        Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String ?? ""
    }
    
    static var bannerAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/2934735716"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "GADBannerAdUnitID") as? String ?? ""
        #endif
    }
    
    static var interstitialAdUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "GADInterstitialAdUnitID") as? String ?? ""
        #endif
    }
}
