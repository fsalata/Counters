//
//  CountersService.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation
import Combine

final class CountersService {
    private let client: APIClient

    init(client: APIClient = APIClient(api: CountersApi())) {
        self.client = client
    }

    func fetch(completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        client.request(target: CounterServiceTarget.counters, completion: completion)
    }

    func increment(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: id, title: nil)
        return client.request(target: CounterServiceTarget.increment(payload: payload), completion: completion)
    }

    func decrement(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: id, title: nil)
        return client.request(target: CounterServiceTarget.decrement(payload: payload), completion: completion)
    }

    func save(title: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: nil, title: title)
        return client.request(target: CounterServiceTarget.save(payload: payload), completion: completion)
    }

    func delete(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        client.request(target: CounterServiceTarget.delete(payload: CounterPayload(id: id, title: nil)),
                       completion: completion)
    }
}
