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

    @State private var searchText: String = ""
    @State private var selectedCounters = Set<Counter>()
    @State private var showDeleteConfirmation = false
    @State private var showCreateCounter = false

    @Environment(\.editMode) var editMode

    init(viewModel: CountersViewModel = CountersViewModel()) {
        self.viewModel = viewModel

        UINavigationBar.appearance().backgroundColor = .white
    }

    private var filteredCounters: [Counter] {
        searchText.isEmpty ? viewModel.counters : viewModel.counters.filter { $0.title.string.localizedCaseInsensitiveContains(searchText) }
    }

    private func deleteCounters() {
        guard !selectedCounters.isEmpty else { return }

        let counters = Array(selectedCounters)

        withAnimation {
            viewModel.delete(counters: counters)
        }
    }

    private func selectAll() {
        selectedCounters = Set(viewModel.counters)
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
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2, anchor: .center)
                        Spacer()

                    case .hasContent:
                        if filteredCounters.isEmpty {
                            Spacer()
                            Text("No results")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex6: 0x888B90))
                            Spacer()

                        } else {
                            List(filteredCounters, id: \.self, selection: $selectedCounters) { counter in
                                CounterCell(counter: counter)
                                    .tint(Color(named: .orange))
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

                    BottomBarView(showDeleteConfirmation: $showDeleteConfirmation, showCreateCounter: $showCreateCounter)
                }
            }
            .environmentObject(viewModel)
            .navigationTitle(Text("Counters"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .foregroundColor(Color(named: .orange))
                        .disabled(viewModel.isCountersEmpty)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    SelectAllButton(selectAllAction: selectAll)
                }
            }
            .sheet(isPresented: $showWelcomeView) {
                WelcomeView()
            }
            .fullScreenCover(isPresented: $showCreateCounter, content: {
                CreateCounterView()
            })
            .confirmationDialog("", isPresented: $showDeleteConfirmation, titleVisibility: .hidden) {
                Button(role: .destructive,
                       action: {
                    deleteCounters()
                }, label: {
                    Text("Delete \(selectedCounters.count) counter\(selectedCounters.count > 1 ? "s" : "")")
                        .font(.system(size: 20))
                        .foregroundColor(Color(named: .red))
                })

                Button(role: .cancel,
                       action: {},
                       label: {
                    Text("Cancel")
                        .font(.system(size: 20))
                        .foregroundColor(Color(named: .orange))
                })
                    .tint(Color(named: .orange))
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .task {
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
