//
//  CounterCell.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct CounterCell: View {
    var counter: Counter

    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: 10) {
                Text("\(counter.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(named: .orange))
                    .frame(width: 60, alignment: .trailing)
                    .padding(.top, 13)

                Rectangle()
                    .foregroundColor(Color(hex6: 0xC4C4C4))
                    .frame(maxWidth: 1, maxHeight: .infinity)

                Text(counter.title.string)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)

                VStack {
                    Spacer()

                    Picker("", selection: .constant(0)) {
                        Image(systemName: "minus")
                        Image(systemName: "plus")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    .padding([.trailing, .bottom], 16)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .frame(maxWidth: .infinity, minHeight: 96)
            .padding(16)
        }
        .background(Color(hex6: 0xC7C7C7))
    }
}

struct CounterCell_Previews: PreviewProvider {
    static var previews: some View {
        CounterCell(counter: Counter(id: "0", title: "Beers"))
            .previewLayout(.sizeThatFits)
    }
}
