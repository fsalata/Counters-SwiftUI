//
//  BadgeView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 31/10/21.
//

import SwiftUI

struct BadgeView: View {
    var badge: String
    var color: Color

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .cornerRadius(10)

            Image(systemName: badge)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .padding(10)
        }
        .frame(width: 49, height: 49)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        let feature = WelcomeFeature.getFeatures().first!
        return BadgeView(badge: feature.badge, color: feature.color)
            .previewLayout(.sizeThatFits)
    }
}
