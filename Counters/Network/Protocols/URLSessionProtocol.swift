//
//  URLSessionProtocol.swift
//  PublicGists
//
//  Created by Fabio Cezar Salata on 13/04/21.
//

import Foundation

typealias APIResponse = URLSession.DataTaskPublisher.Output

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
