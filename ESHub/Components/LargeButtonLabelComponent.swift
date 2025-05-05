//
//  LargeButtonLabelComponent.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/03.
//

import SwiftUI

public struct LargeButtonLabelComponent: View {
    private var text: String
    private var systemName: String
    private var fillColor: String
    private var textColor: Color
    
    public init(text: String, systemName: String, fillColor: String, textColor: Color) {
        self.text = text
        self.systemName = systemName
        self.fillColor = fillColor
        self.textColor = textColor
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 90)
                .fill(Color(fillColor))
                .frame(width: UIScreen.main.bounds.size.width / 1.2, height: UIScreen.main.bounds.size.height / 10)
                .shadow(radius: 5)
                HStack {
                    Image(systemName: systemName)
                        .font(.title)
                    Text(text.count > 7 ? text : text + "　　")
                        .font(.title2)
                }
                .foregroundColor(textColor)
        }
    }
}
