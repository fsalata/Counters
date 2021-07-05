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

    func set(key: Key, object: Object)
    func get(key: Key) -> Object?
}

final class Cache: Cacheable {
    static var shared: Cache = Cache()

    private var cache: NSCache<NSString, StructWrapper<[Counter]>>

    private init() {
        self.cache = NSCache()
    }

    func set(key: String, object: [Counter]) {
        let counterWrapper = StructWrapper(object)
        cache.setObject(counterWrapper, forKey: NSString(string: key))
    }

    func get(key: String) -> [Counter]? {
        let counterWrapper = cache.object(forKey: NSString(string: key))
        return counterWrapper?.value
    }
}

class StructWrapper<T>: NSObject {
    let value: T

    init(_ object: T) {
        self.value = object
    }
}
