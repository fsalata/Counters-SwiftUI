//
//  PrimayButtonStyle.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    var fullScreen: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: fullScreen ? .infinity : nil, maxHeight: fullScreen ? 60 : nil)
            .background(buttonBackground(isPressed: configuration.isPressed))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 8)
    }

    func buttonBackground(isPressed: Bool) -> Color {
        if !isEnabled || isPressed {
            return Color(named: .orange).opacity(0.5)
        }

        return Color(named: .orange)
    }
}
