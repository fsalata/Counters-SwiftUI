//
//  BottomBarView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 02/11/21.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject private var viewModel: CountersViewModel
    @Environment(\.editMode) var editMode

    @Binding var showDeleteConfirmation: Bool
    @Binding var showCreateCounter: Bool

    private var isEditing: Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }

    var body: some View {
        VStack(alignment: .center) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black.opacity(0.15))

            HStack(alignment: .center) {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(Color(named: .orange))
                        .padding(5)
                }
                .opacity(isEditing ? 1 : 0)

                Spacer()

                Text(viewModel.totalCountersText)
                    .font(.system(size: 15))
                    .foregroundColor(Color(named: .darkSilver))

                Spacer()

                Button {
                    showCreateCounter = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22))
                        .foregroundColor(Color(named: .orange))
                        .padding(5)
                }

            }
            .padding(.horizontal, 8)

            Spacer()
        }
        .frame(height: 46)
        .background(Color.white)
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(showDeleteConfirmation: .constant(false), showCreateCounter: .constant(false))
            .environmentObject(CountersViewModel())
            .previewLayout(.sizeThatFits)
    }
}
