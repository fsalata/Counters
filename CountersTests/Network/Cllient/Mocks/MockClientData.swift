//
//  MockData.swift
//  NetworkLayerTests
//
//  Created by Fabio Cezar Salata on 06/06/21.
//

import Foundation

struct User: Codable, Equatable {
    var username: String
    var name: String
    var age: Int
}

func userMock() -> Data {
    return  """
            {
                "username" : "fsalata",
                "name" : "Fábio Salata",
                "age" : 39
            }
            """.data(using: .utf8)!
}

func malformedUserMock() -> Data {
    return  """
            {
                "user" : "fsalata",
                "name" : "Fábio Salata",
                "age" : 39
            }
            """.data(using: .utf8)!
}
