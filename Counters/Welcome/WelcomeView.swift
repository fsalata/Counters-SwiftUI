//
//  WelcomeView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 30/10/21.
//

import SwiftUI

struct WelcomeView: View {
    private let viewModel = WelcomeViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                    Text("Counters")
                        .foregroundColor(Color(named: .orange))
                        .padding(.bottom, 16)
                }
                .font(.system(size: 33, weight: .bold))
                Spacer()
            }

            Text("An example app that syncs to a Node.js server running on your Mac.")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(named: .black))
                .padding(.bottom, 24)

            ForEach(viewModel.features, id: \.self) { feature in
                FeatureView(feature: feature)
            }

            Spacer()

            Button("Continue") {

            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding([.top, .leading, .trailing], 40)
        .padding(.bottom, 20)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()

    }
}
