//
//  CountersService.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

final class CountersRepository {
    private let client: APIClient
    private let userDefaults: UserDefaultsProtocol
    private let cache: CacheActor

    private let firstTimeOpenKey = "FirstOpen"
    private var countersCacheKey = "counters"

    init(client: APIClient,
         userDefaults: UserDefaultsProtocol,
         cache: CacheActor) {
        self.client = client
        self.userDefaults = userDefaults
        self.cache = cache
    }
}

// MARK: - API Calls
extension CountersRepository {
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
    func set(key: String, object: [Counter]) async {
        await cache.set(key: key, object: object)
    }

    func get(key: String) async -> [Counter]? {
        return await cache.get(key: key)
    }

    func setCacheFor(counters: [Counter]) async {
        await set(key: countersCacheKey, object: counters)
    }

    func getCachedCounters() async -> [Counter]? {
        return await get(key: countersCacheKey)
    }
}
