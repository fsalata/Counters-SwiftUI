//
//  CreateItemViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import Foundation
import Combine

final class CreateCounterViewModel: ObservableObject {
    private let service: CountersService

    private(set) var viewState: ViewState = .loaded

    // Init
    init(service: CountersService = CountersService()) {
        self.service = service
    }

    // MARK: - Fetch Counters
    func save(title: String) {
        viewState = .loading

        Task(priority: .medium) {
            do {
                try await service.save(title: title)
                self.viewState = .loaded
            } catch {
                self.viewState = .error
            }
        }
    }
}

extension CreateCounterViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case error
    }
}
