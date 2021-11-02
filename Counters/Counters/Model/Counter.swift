//
//  CounterModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

struct Counter: Decodable, Equatable, Hashable, Identifiable {
    let id: String?
    let title: String?
    var count: Int = 0
}

struct CounterPayload: Codable, Equatable {
    var id: String?
    var title: String?
}

extension Counter {
    static func getCounters() -> [Counter] {
        return [Counter(id: "0", title: "Beers"), Counter(id: "1", title: "Coffees")]
    }
}
