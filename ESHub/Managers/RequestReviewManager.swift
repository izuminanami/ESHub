//
//  RequestReviewManager.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/05.
//

import SwiftUI
import StoreKit

func requestReview() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        SKStoreReviewController.requestReview(in: windowScene)
    }
}
