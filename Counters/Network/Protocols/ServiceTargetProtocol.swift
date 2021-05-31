//
//  ServiceTargetProtocol.swift
//  MovieDB
//
//  Created by Fábio Salata on 05/11/20.
//

import Foundation

protocol ServiceTargetProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var parameters: JSON? { get }
    var body: Data? { get }
}
