//
//  UnderlineTextFieldStyleComponent.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/05.
//

import SwiftUI

public struct UnderlineTextFieldStyleComponent: View {
    private var title: String?
    private var placeholder: String
    @Binding private var inputText: String

    public init(title: String?, placeholder: String, inputText: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self._inputText = inputText
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.title2)
                    .foregroundColor(Color("textColor"))
                    .padding(.leading)
            }
                
            TextField(placeholder, text: $inputText)
                .padding(.vertical, 8)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("textColor")),
                    alignment: .bottom
                )
        }
        .padding(.horizontal)
    }
}
