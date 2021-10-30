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
            ForEach(viewModel.features, id: \.self) { feature in
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(feature.color)
                            .frame(width: 60, height: 60)

                        Image(systemName: feature.badge)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }

                    VStack(alignment: .leading) {
                        Text(feature.title)
                            .font(.title3)

                        Text(feature.subtitle)
                            .font(.caption)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
