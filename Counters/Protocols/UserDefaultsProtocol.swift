//
//  UserDefaultsProtocol.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/07/21.
//

import Foundation

protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
}

extension UserDefaults: UserDefaultsProtocol { }
