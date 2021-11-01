//
//  EmptyCounterView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct MessageView: View {
    var title: String
    var subtitle: String
    var buttonTitle: String
    var action: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(title)
                .font(.system(size: 22, weight: .bold))

            Text(subtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(named: .darkSilver))

            Button(buttonTitle) {
                action()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

struct EmptyCounterView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(title: "No counters yet",
                    subtitle: "When I started counting my blessings, my whole life turned around.\n—Willie Nelson",
                    buttonTitle: "Create a counter",
                    action: {})
            .previewLayout(.sizeThatFits)
    }
}
