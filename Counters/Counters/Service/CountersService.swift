//
//  CountersService.swift
//  Counters
//

import Foundation
import Combine

final class CountersService {
    private let client: APIClient

    init(client: APIClient = APIClient(api: CountersApi())) {
        self.client = client
    }

    func fetch() async throws -> ([Counter], URLResponse) {
        try await client.request(target: CounterServiceTarget.counters)
    }

    func increment(id: String) async throws -> ([Counter], URLResponse) {
        let payload = CounterPayload(id: id, title: nil)
        return try await client.request(target: CounterServiceTarget.increment(payload: payload))
    }

    func decrement(id: String) async throws -> ([Counter], URLResponse) {
        let payload = CounterPayload(id: id, title: nil)
        return try await client.request(target: CounterServiceTarget.decrement(payload: payload))
    }

    @discardableResult
    func save(title: String) async throws -> ([Counter], URLResponse) {
        let payload = CounterPayload(id: nil, title: title)
        return try await client.request(target: CounterServiceTarget.save(payload: payload))
    }

    func delete(id: String) async throws -> ([Counter], URLResponse) {
        try await client.request(target: CounterServiceTarget.delete(payload: CounterPayload(id: id, title: nil)))
    }
}
