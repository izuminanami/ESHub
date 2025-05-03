//
//  SmallButtonLabelComponent.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

public struct SmallButtonLabelComponent: View {
    private var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("primaryButtonColor"))
            .frame(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.height / 17)
            .shadow(radius: 5)
            .overlay(Text(text).font((text.count < 3) ? .title: .title3))
            .foregroundColor(.white)
    }
}
