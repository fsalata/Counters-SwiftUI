//
//  QuantityControl.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct QuantityControl: View {
    var counter: Counter

    @EnvironmentObject private var viewModel: CountersViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button {
                viewModel.decrementCounter(counter)
            } label: {
                Image(systemName: "minus")
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 38, height: 24)

            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color(hex6: 0x3C3C43).opacity(0.18))

            Button {
                viewModel.incrementCounter(counter)
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 38, height: 24)
        }
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(.black)
        .frame(width: 92, height: 24)
        .padding(8)
        .background(Color(hex6: 0x767680).opacity(0.12))
        .cornerRadius(8)
        .clipped()
    }
}

struct QuantityControl_Previews: PreviewProvider {
    static var previews: some View {
        QuantityControl(counter: Counter(id: "0", title: "Beers"))
            .previewLayout(.sizeThatFits)
    }
}
