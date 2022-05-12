//
//  CountersService.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation
import NetworkLayer

final class CountersRepository {
    private let client: APIClient
    private let userDefaults: UserDefaultsProtocol
    private let cache: Cache

    private let firstTimeOpenKey = "FirstOpen"
    private var countersCacheKey = "counters"

    init(client: APIClient,
         userDefaults: UserDefaultsProtocol,
         cache: Cache) {
        self.client = client
        self.userDefaults = userDefaults
        self.cache = cache
    }
}

// MARK: - API Calls
extension CountersRepository {
    func fetch(completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        client.request(target: CounterServiceTarget.counters, completion: completion)
    }

    func increment(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: id)
        client.request(target: CounterServiceTarget.increment(payload: payload), completion: completion)
    }

    func decrement(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: id)
        client.request(target: CounterServiceTarget.decrement(payload: payload), completion: completion)
    }

    func save(title: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(title: title)
        client.request(target: CounterServiceTarget.save(payload: payload), completion: completion)
    }

    func delete(id: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        let payload = CounterPayload(id: id)
        client.request(target: CounterServiceTarget.delete(payload: payload),
                       completion: completion)
    }
}

// MARK: - UserDefaults
extension CountersRepository {
    func getValueFor(key: String) -> Bool? {
        return userDefaults.object(forKey: firstTimeOpenKey) as? Bool
    }

    func set(value: Bool, for key: String) {
        userDefaults.setValue(value, forKey: firstTimeOpenKey)
    }

    func checkWelcomeWasShown() -> Bool {
        getValueFor(key: firstTimeOpenKey) ?? false
    }

    func setWelcomeWasShown() {
        set(value: true, for: firstTimeOpenKey)
    }
}

// MARK: - Cache
extension CountersRepository {
    func set(key: String, object: [Counter]) {
        cache.set(key: key, object: object)
    }

    func get(key: String) -> [Counter]? {
        return cache.get(key: key)
    }

    func setCacheFor(counters: [Counter]) {
        set(key: countersCacheKey, object: counters)
    }

    func getCachedCounters() -> [Counter]? {
        return get(key: countersCacheKey)
    }
}
