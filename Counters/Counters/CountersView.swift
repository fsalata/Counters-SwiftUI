//
//  CountersView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct CountersView: View {
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
            }
            .navigationTitle(Text("Counters"))
            .sheet(isPresented: $showWelcomeView) {
                WelcomeView()
            }
        }
    }
}

struct CountersView_Previews: PreviewProvider {
    static var previews: some View {
        CountersView()
    }
}
