//
//  CounterMocks.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 05/07/21.
//

import Foundation

struct CounterMocks {
    static var responseBody: Data = """
                                    [
                                      {
                                        "id" : "kqquwv6f",
                                        "title" : "Coffee",
                                        "count" : 0
                                      },
                                      {
                                        "id" : "kqqux3m1",
                                        "title" : "Tea",
                                        "count" : 0
                                      },
                                      {
                                        "id" : "kqqux9xa",
                                        "title" : "Beer",
                                        "count" : 0
                                      }
                                    ]
                                    """.data(using: .utf8)!

    static var responseEmptyBody: Data = """
                                    [
                                    ]
                                    """.data(using: .utf8)!
}
