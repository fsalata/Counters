//
//  CountersServiceTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import XCTest
@testable import Counters

class CountersServiceTests: XCTestCase {
    private var sut: CountersRepository!
    private var factory: MockDependencyFactory!
    private var session: URLSessionSpy!

    override func setUp() {
        super.setUp()

        factory = MockDependencyFactory()
        sut = factory.makeCountersRepository()
        session = factory.session
    }

    override func tearDown() {
        sut = nil
        factory = nil
        session = nil

        super.tearDown()
    }

    func test_fetchURL() async throws {
        let expectedMethod = "GET"
        let expectedURL = "https://mock.com/api/v1/counters"
        
        
        givenSession(session: session, data: CounterMocks.responseBody)

        let (_, _) = try await sut.fetch()

        let httpBody = session.dataTaskArgsRequest.first?.httpBody

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertNil(httpBody)
    }

    func test_incrementURL() async throws {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter/inc"
        let expectedBody = CounterPayload(id: "asd", title: nil)
        
        givenSession(session: session, data: CounterMocks.responseBody)

        let (_, _) = try await sut.increment(id: "asd")

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_decrementURL() async throws{
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter/dec"
        let expectedBody = CounterPayload(id: "asd", title: nil)
        
        givenSession(session: session, data: CounterMocks.responseBody)

        let (_, _) = try await sut.decrement(id: "asd")

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_saveURL() async throws {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/api/v1/counter"
        let expectedBody = CounterPayload(id: nil, title: "asd")
        
        givenSession(session: session, data: CounterMocks.responseBody)

        let (_, _) = try await sut.save(title: "asd")

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }

    func test_deleteURL() async throws {
        let expectedMethod = "DELETE"
        let expectedURL = "https://mock.com/api/v1/counter"
        let expectedBody = CounterPayload(id: "asd", title: nil)
        
        givenSession(session: session, data: CounterMocks.responseBody)

        let (_, _) = try await sut.delete(id: "asd")

        let httpBody = try? JSONDecoder().decode(CounterPayload.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, expectedBody)
    }
}
