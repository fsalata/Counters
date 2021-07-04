//
//  MockServiceTarget.swift
//  NetworkLayerTests
//
//  Created by Fabio Cezar Salata on 05/06/21.
//

import Foundation
@testable import Counters

struct MockAPI: APIProtocol {
    let baseURL = "https://mock.com"
}

enum MockGETServiceTarget: ServiceTargetProtocol {
    case get(page: Int)
}

extension MockGETServiceTarget {
    var path: String {
        "/get"
    }

    var method: RequestMethod {
        .GET
    }

    var header: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    var parameters: JSON? {
        var parameters: JSON = [:]
        switch self {
        case let .get(page):
            parameters["page"] = "\(page)"
        }

        return parameters
    }

    var body: Data? {
        return nil
    }
}

enum MockPOSTServiceTarget: ServiceTargetProtocol {
    case post(user: User)
}

extension MockPOSTServiceTarget {
    var path: String {
        "/post"
    }

    var method: RequestMethod {
        .POST
    }

    var header: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    var parameters: JSON? {
        return nil
    }

    var body: Data? {
        switch self {
        case .post(let user):
            return try? JSONEncoder().encode(user)
        }
    }
}
