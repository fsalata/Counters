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

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        url = request.url
        method = request.httpMethod
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)

        completionHandler(data, response, error)

        return URLSessionDataTaskSpy()
    }
}

class URLSessionDataTaskSpy: URLSessionDataTask {
    var calledResume = false

    override init() { }

    override func resume() {
        calledResume = true
    }
}
