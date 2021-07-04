//
//  CountersViewModelTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import XCTest
@testable import Counters

class CountersViewModelTests: XCTestCase {
    var sut: CountersViewModel!
    var session: URLSessionSpy!
    var service: CountersService!

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        service = CountersService(client: client)
        sut = CountersViewModel(service: service)
    }

    override func tearDown() {
        sut = nil
        session = nil
        service = nil

        super.tearDown()
    }
}

// MARK: - Helpers
extension CountersViewModelTests {
    func givenSession(url: URL, data: Data?, statusCode: Int = 200, error: URLError? = nil) {
        session.data = data
        session.response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.error = error
    }
}
