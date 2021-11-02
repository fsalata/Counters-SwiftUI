//
//  SelectAllButton.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 02/11/21.
//

import SwiftUI

struct SelectAllButton: View {
    @Environment(\.editMode) var editMode

    var selectAllAction: () -> Void

    private var isEditing: Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }

    var body: some View {
        if isEditing {
            Button("Select All") {
                selectAllAction()
            }
            .foregroundColor(Color(named: .orange))
        }
    }
}

struct SelectAllButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllButton(selectAllAction: {})
    }
}
