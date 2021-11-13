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
    var factory: MockDependencyFactory!

    var didSaveCounter = false

    override func setUp() {
        super.setUp()

        factory = MockDependencyFactory()
        sut = factory.makeCreateCounterViewModel()
    }

    override func tearDown() {
        sut = nil
        factory = nil
        didSaveCounter = false

        super.tearDown()
    }

    func test_initialState_shouldBeLoading() {
        XCTAssertEqual(sut.viewState, .loading)
    }

    func test_saveCounter_shouldSucceed() {
        let title = "Tea"
        givenSession(session: factory.session, data: CounterMocks.responseBody)

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
        givenSession(session: factory.session, data: CounterMocks.responseEmptyBody, error: URLError(.badServerResponse))

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
