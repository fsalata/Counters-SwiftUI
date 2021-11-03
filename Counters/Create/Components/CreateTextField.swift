//
//  CreateTextField.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 03/11/21.
//

import SwiftUI

struct CreateTextField: View {
    @Binding var text: String

    var isLoading: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Cups of coffee", text: $text, prompt: Text("Cups of coffee"))
                .padding(16)
                .padding(.trailing, isLoading ? 20 : 0)
                .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color(hex6: 0xFDFDFD), lineWidth: 1)
                )
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.horizontal, 8)
            }
        }
    }
}

struct CreateTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(hex6: 0xC7C7C7)
                .ignoresSafeArea(edges: [.trailing, .bottom, .leading])

            CreateTextField(text: .constant(""), isLoading: true)
        }
    }
}
