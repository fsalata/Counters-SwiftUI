//
//  CountersView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import SwiftUI

struct CountersView: View {
    @ObservedObject private var viewModel: CountersViewModel

    @AppStorage("showWelcomeView") var showWelcomeView: Bool = false

    @State private var viewState: CountersViewModel.ViewState = .hasContent
    @State private var searchText: String = ""

    init(viewModel: CountersViewModel = CountersViewModel()) {
        self.viewModel = viewModel

        UINavigationBar.appearance().backgroundColor = .white
    }

    private var filteredCounters: [Counter] {
        searchText.isEmpty ? viewModel.counters : viewModel.counters.filter { $0.title.string.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - View
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex6: 0xC7C7C7)
                    .ignoresSafeArea(edges: [.trailing, .bottom, .leading])

                VStack {
                    switch viewModel.viewState {
                    case .noContent:
                        MessageView(title: "No counters yet",
                                    subtitle: "When I started counting my blessings, my whole life turned around.\n—Willie Nelson",
                                    buttonTitle: "Create a counter",
                                    action: {})
                            .padding(32)
                    case .loading:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2, anchor: .center)
                    case .hasContent:
                        if filteredCounters.isEmpty {
                            Text("No results")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex6: 0x888B90))
                        } else {
                            List(filteredCounters) { counter in
                                CounterCell(counter: counter)
                                    .listRowInsets(EdgeInsets())
                                    .listSectionSeparator(.hidden)
                            }
                            .listStyle(PlainListStyle())
                            .refreshable {
                                viewModel.fetchCounters()
                            }
                        }
                    case .error:
                        MessageView(title: "Couldn’t load the counters",
                                    subtitle: "The Internet connection appears to be offline.",
                                    buttonTitle: "Retry",
                                    action: viewModel.fetchCounters)
                            .padding(32)
                    }
                }
            }
            .navigationTitle(Text("Counters"))
            .sheet(isPresented: $showWelcomeView) {
                WelcomeView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            if !showWelcomeView {
                viewModel.fetchCounters()
            }
        }
    }
}

struct CountersView_Previews: PreviewProvider {
    static var previews: some View {
        CountersView()
    }
}
