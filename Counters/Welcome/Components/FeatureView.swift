//
//  FeatureView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 31/10/21.
//

import SwiftUI

struct FeatureView: View {
    var feature: WelcomeFeature

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            BadgeView(badge: feature.badge, color: feature.color)

            VStack(alignment: .leading, spacing: 8) {
                Text(feature.title)
                    .fontWeight(.bold)

                Text(feature.subtitle)
                    .foregroundColor(Color(hex6: 0x2B2B2B))
            }
        }
        .padding(.bottom, 16)
    }
}

struct FeatureView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureView(feature: WelcomeFeature.getFeatures().first!)
            .previewLayout(.sizeThatFits)
    }
}
