//
//  CreateCounterViewModelTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 05/07/21.
//

import XCTest
@testable import Counters

class CreateCounterViewModelTests: XCTestCase {
    var sut: CreateCounterViewModel!

    var session: URLSessionSpy!
    var service: CountersService!

    let mockAPI = MockAPI()

    var didSaveCounter = false

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        service = CountersService(client: client)
        sut = CreateCounterViewModel(service: service)
    }

    override func tearDown() {
        sut = nil
        session = nil
        service = nil
        didSaveCounter = false

        super.tearDown()
    }

    func test_initialState_shouldBeLoading() {
        XCTAssertEqual(sut.viewState, .loading)
    }

    func test_saveCounter_shouldSucceed() {
        let title = "Tea"
        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "save counters")

        sut.didSaveCounter = {
            if self.sut.viewState != .loading {
                self.didSaveCounter = true
                expectation.fulfill()
            }
        }

        sut.save(title: title)

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(sut.viewState, .loaded)
        XCTAssertTrue(didSaveCounter)
    }

    func test_saveCounter_shouldError() {
        let title = "Tea"
        givenSession(session: session, data: CounterMocks.responseEmptyBody, error: URLError(.badServerResponse))

        let expectation = self.expectation(description: "save counters")

        sut.didSaveCounter = {
            if self.sut.viewState != .loading {
                self.didSaveCounter = true
                expectation.fulfill()
            }
        }

        sut.save(title: title)

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(sut.viewState, .error)
        XCTAssertTrue(didSaveCounter)
    }
}
