//
//  CountersServiceTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import XCTest
@testable import Counters

class CountersServiceTests: XCTestCase {
    private var sut: CountersService!
    private var session: URLSessionSpy!

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        sut = CountersService(client: client)
    }

    override func tearDown() {
        sut = nil
        session = nil

        super.tearDown()
    }

    func test_fetchURL() {
        let expectedMethod = "GET"
        let expectedURL = "https://mock.com/api/v1/counters"

        sut.fetch(completion: { _, _ in })

        let httpBody = session.dataTaskArgsRequest.first?.httpBody

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertNil(httpBody)
    }

    func test_incrementURL() {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter/inc"
        let expectedBody = CounterPayload(id: "asd", title: nil)

        sut.increment(id: "asd") { _, _ in }

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_decrementURL() {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter/dec"
        let expectedBody = CounterPayload(id: "asd", title: nil)

        sut.decrement(id: "asd") { _, _ in }

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_saveURL() {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter"
        let expectedBody = CounterPayload(id: nil, title: "asd")

        sut.save(title: "asd") { _, _ in }

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_deleteURL() {
        let expectedMethod = "DELETE"
        let expectedURL = "https://mock.com/api/v1/counter"
        let expectedBody = CounterPayload(id: "asd", title: nil)

        sut.delete(id: "asd") { _, _ in }

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }
}
