//
//  CountersViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

final class CountersViewModel: ObservableObject {
    private let service: CountersService

    @Published private(set) var counters: [Counter] = []

    private var cache = Cache.shared
    private var countersCacheKey = "counters"

    @Published private(set) var viewState: ViewState = .loading

    // Init
    init(service: CountersService = CountersService()) {
        self.service = service
    }
}

// MARK: - Computed properties
extension CountersViewModel {
    var totalCountersText: String {
        guard counters.count > 0 else {
            return ""
        }

        let totalCounters = counters.count
        let totalTimes = counters.reduce(0) { $0 + $1.count }

        return """
               \(totalCounters) item\(totalCounters > 1 ? "s": "") \
               - Counted \(totalTimes) time\(totalTimes > 1 ? "s": "")
               """
    }

    var isCountersEmpty: Bool {
        return counters.count == 0
    }
}

// MARK: - Public methods
extension CountersViewModel {
    func shareItems(at indexPaths: [IndexPath]) -> [String] {
        return indexPaths.compactMap { counters[$0.row] }.map { "\($0.count) x \($0.title ?? "")" }
    }
}

// API calls
extension CountersViewModel {
    // MARK: - Fetch counters
    func fetchCounters() {
        viewState = .loading

        Task(priority: .medium) {
            do {
                let (counters, _) = try await service.fetch()
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }

    // MARK: - Increment counter
    func incrementCounter(_ counter: Counter) {
        guard let id = counter.id else { return }

        Task(priority: .medium) {
            do {
                let (counters, _) = try await service.increment(id: id)
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }

    // MARK: - Decrement counter
    func decrementCounter(_ counter: Counter) {
        guard let id = counter.id,
              counter.count > 0 else { return }

        Task(priority: .medium) {
            do {
                let (counters, _) = try await service.decrement(id: id)
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }

    // MARK: - Delete counter(s)
    func delete(counters: [Counter]) {
        viewState = .loading

        Task(priority: .medium) {
            let selectedCountersIds = counters.compactMap { $0.id }

            var remainingCounters: [Counter] = []
            var failedToDelete: (error: APIError, counter: Counter)?

            for id in selectedCountersIds {

                do {
                    (remainingCounters, _) = try await service.delete(id: id)
                } catch {
                    if let counter = self.counters.first(where: { $0.id == id }) {
                        failedToDelete = (error: APIError(error), counter: counter)
                    }
                }
            }

            if let failedToDelete = failedToDelete {
                let (error, counter) = failedToDelete
                self.errorHandler(error, in: .delete(counter))
            } else {
                self.receiveValueHandler(remainingCounters)
            }
        }
    }
}

// MARK: - Private methods
private extension CountersViewModel {
    // Received value handler
    func receiveValueHandler(_ counters: [Counter]) {
        DispatchQueue.main.async {
            self.counters = counters
            self.viewState = counters.isEmpty ? .noContent : .hasContent
            self.cache.set(key: self.countersCacheKey, object: counters)
        }
    }

    // MARK: - Received completion handler
    func errorHandler(_ error: APIError, in type: ViewErrorType) {
        DispatchQueue.main.async {
            if type == .fetch,
               case .network = error,
               let cachedCounters = self.cache.get(key: self.countersCacheKey) {
                self.receiveValueHandler(cachedCounters)
                return
            }

            var title: String?
            var message: String? = "The Internet connection appears to be offline."

            switch type {
            case .fetch:
                title = "Couldn’t update counters"
                self.counters = []

            case .increment(let counter):
                title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count + 1)"

            case .decrement(let counter):
                title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count - 1)"

            case .delete(let counter):
                title = "Couldn’t delete the counter \"\(counter.title ?? "")\""

            case .none:
                title = nil
                message = nil
            }

            let viewStateError = ViewStateError(title: title, message: message, type: type)
            self.viewState = .error(viewStateError)
        }
    }
}

// MARK: View State
extension CountersViewModel {
    enum ViewState: Equatable {
        case noContent
        case loading
        case hasContent
        case error(ViewStateError)
    }

    struct ViewStateError: Equatable {
        let title: String?
        let message: String?
        let type: ViewErrorType
    }

    enum ViewErrorType: Equatable {
        case fetch
        case increment(_ counter: Counter)
        case decrement(_ counter: Counter)
        case delete(_ counter: Counter)
        case none
    }
}
