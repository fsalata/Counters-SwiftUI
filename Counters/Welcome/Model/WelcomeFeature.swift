//
//  WelcomeFeature.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 31/05/21.
//

import SwiftUI

struct WelcomeFeature: Hashable {
    let badge: String
    let color: Color
    let title: String
    let subtitle: String
}

extension WelcomeFeature {
    static func getFeatures() -> [WelcomeFeature] {
        return [
            .init(badge: "42.circle.fill",
                  color: Color("redColor"),
                  title: "Add almost anything",
                  subtitle: "Capture cups of lattes, frapuccinos, or anything else that can be counted."),
            .init(badge: "person.2.fill",
                  color: Color("yellowColor"),
                  title: "Count to self, or with anyone",
                  subtitle: "Others can view or make changes. There’s no authentication API."),
            .init(badge: "lightbulb.fill",
                  color: Color("greenColor"),
                  title: "Count your thoughts",
                  subtitle: "Possibilities are literally endless.")
        ]
    }
}
