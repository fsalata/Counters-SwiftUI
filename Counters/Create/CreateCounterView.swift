//
//  CreateCounterView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 03/11/21.
//

import SwiftUI

struct CreateCounterView: View {
    @ObservedObject private var viewModel = CreateCounterViewModel()

    @State var title = ""

    @Environment(\.presentationMode) var presentationMode

    init(viewModel: CreateCounterViewModel = CreateCounterViewModel()) {
        self.viewModel = viewModel

        UINavigationBar.appearance().backgroundColor = .white
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(named: .lighterGrey)
                    .ignoresSafeArea(edges: [.trailing, .bottom, .leading])

                VStack(alignment: .leading) {
                    CreateTextField(text: $title, isLoading: viewModel.viewState == .loading)
                        .padding(.bottom, 16)

                    HStack {
                        NavigationLink {
                            ExamplesView(selected: $title)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(CreateCounterStrings.examplesText) + Text(CreateCounterStrings.examplesWord).underline() + Text(".")
                            }
                            .font(.system(size: 15))
                            .foregroundColor(Color(named: .darkSilver))
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                        }

                    }

                    Spacer()
                }
                .onChange(of: viewModel.viewState, perform: { state in
                    if state == .loaded {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .padding(16)
                .padding(.top, 8)
                .navigationTitle(Text("Create a counter"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(Color(named: .orange))
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.save(title: title)
                        }
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(named: .orange))
                    }
                }
            }
        }
    }
}

struct CreateCounterView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCounterView()
    }
}
