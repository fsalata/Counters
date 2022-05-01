//
//  Cache.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 05/07/21.
//

import Foundation

protocol Cacheable {

    associatedtype Key
    associatedtype Object

    func set(key: Key, object: Object) async
    func get(key: Key) async -> Object?
}

@globalActor final actor CacheActor: Cacheable {
    static let shared = CacheActor()

    private var cache: NSCache<NSString, StructWrapper<[Counter]>>

    private init() {
        self.cache = NSCache()
    }

    nonisolated func set(key: String, object: [Counter]) async {
        let counterWrapper = StructWrapper(object)
        await cache.setObject(counterWrapper, forKey: NSString(string: key))
    }

    nonisolated func get(key: String) async -> [Counter]? {
        let counterWrapper = await cache.object(forKey: NSString(string: key))
        return counterWrapper?.value
    }
}

class StructWrapper<T>: NSObject {
    let value: T

    init(_ object: T) {
        self.value = object
    }
}
