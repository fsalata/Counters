//
//  URL+Extension.swift
//  Counters
//

import Foundation

typealias JSON = [String: Any]

extension URL {
    init?(baseUrl: String, path: String, parameters: JSON?, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path

        components.queryItems = parameters?.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }

        guard let url = components.url else { return nil }

        self = url
    }
}
