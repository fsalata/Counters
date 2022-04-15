//
//  URLSessionSpy.swift
//  NetworkLayerTests
//

import Foundation
@testable import Counters

class URLSessionSpy: URLSessionProtocol {
    var url: URL?
    var method: String?
    var dataTaskCallCount = 0
    var dataTaskArgsRequest: [URLRequest] = []

    var data: Data?
    var response: URLResponse?
    var error: URLError?
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        url = request.url
        method = request.httpMethod
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)
        
        if let error = error {
            throw error
        }
        
        guard let data = data,
              let response = response else {
            throw APIError.service(.clientError)
        }

        return (data, response)
    }
}
