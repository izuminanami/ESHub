//
//  AdMobBannerComponent.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/07.
//

import SwiftUI

struct AdBannerContainerView: View {
    
    var body: some View {
        VStack {
            Spacer()
            AdMobBannerView()
                .frame(width: 320, height: 50)
        }
    }
}
