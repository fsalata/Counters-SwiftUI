//
//  String+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 01/11/21.
//

import Foundation

extension Optional where Wrapped == String {
    var string: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}
