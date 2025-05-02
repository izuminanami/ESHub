//
//  LargeButtonLabelComponent.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

public struct LargeButtonLabelComponent: View {
    private var text: String
    private var color: String
    
    public init(text: String, color: String) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(color))
            .frame(width: UIScreen.main.bounds.size.width/1.25, height: UIScreen.main.bounds.size.height/5)
            .shadow(radius: 5)
            .overlay(Text(text).font(.title))
            .foregroundColor(.white)
    }
}
