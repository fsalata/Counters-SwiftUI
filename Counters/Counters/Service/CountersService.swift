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

    func fetch() -> AnyPublisher<[Counter], APIError> {
        client.request(target: CounterServiceTarget.counters)
    }

    func increment(id: String) -> AnyPublisher<[Counter], APIError> {
        let payload = CounterPayload(id: id)
        return client.request(target: CounterServiceTarget.increment(payload: payload))
    }

    func decrement(id: String) -> AnyPublisher<[Counter], APIError> {
        let payload = CounterPayload(id: id)
        return client.request(target: CounterServiceTarget.decrement(payload: payload))
    }

    func save(title: String) -> AnyPublisher<[Counter], APIError> {
        let payload = CounterPayload(title: title)
        return client.request(target: CounterServiceTarget.save(payload: payload))
    }

    func delete(id: String) -> AnyPublisher<[Counter], APIError> {
        let payload = CounterPayload(id: id)
        return client.request(target: CounterServiceTarget.delete(payload: payload))
    }
}
