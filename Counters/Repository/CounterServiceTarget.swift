//
//  CounterServiceTarget.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

enum CounterServiceTarget {
    case counters
    case increment(payload: CounterPayload)
    case decrement(payload: CounterPayload)
    case save(payload: CounterPayload)
    case delete(payload: CounterPayload)
}

extension CounterServiceTarget: ServiceTargetProtocol {
    var path: String {
        switch self {
        case .counters:
            return "/api/v1/counters"
        case .increment:
            return "/api/v1/counter/inc"
        case .decrement:
            return "/api/v1/counter/dec"
        case .save, .delete:
            return "/api/v1/counter"
        }
    }

    var method: RequestMethod {
        switch self {
        case .counters:
            return .GET
        case .delete:
            return .DELETE
        default:
            return .POST
        }
    }

    var header: [String: String]? {
        switch self {
        case .counters:
            return nil
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var parameters: JSON? {
        return nil
    }

    var body: Data? {
        switch self {
        case .counters:
            return nil
        case .decrement(let payload), .increment(let payload), .save(let payload), .delete(let payload):
            return try? JSONEncoder().encode(payload)
        }
    }
}
