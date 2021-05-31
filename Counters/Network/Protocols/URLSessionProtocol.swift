//
//  URLSessionProtocol.swift
//  Counters
//

import Foundation

typealias APIResponse = URLSession.DataTaskPublisher.Output

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
