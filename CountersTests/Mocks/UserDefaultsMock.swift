//
//  UserDefaultsMock.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 07/07/21.
//

import Foundation
@testable import Counters

class UserDefaultsMock: UserDefaultsProtocol {
    var key: String?
    var value: Any?

    func object(forKey defaultName: String) -> Any? {
        key = defaultName
        return value
    }

    func setValue(_ value: Any?, forKey key: String) {
        self.key = key
        self.value = value
    }
}
