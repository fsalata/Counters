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
    var userDefaults: UserDefaultsProtocol!

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        service = CountersService(client: client)
        userDefaults = UserDefaultsMock()
        sut = CountersViewModel(service: service, userDefaults: userDefaults)
    }

    override func tearDown() {
        sut = nil
        session = nil
        service = nil
        userDefaults = nil

        super.tearDown()
    }

    func test_initialValues() {
        let expectedViewState = CountersViewModel.ViewState.noContent

        var didChangeState = false

        sut.didChangeState = { state, error in
            didChangeState = true
        }

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertTrue(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertTrue(sut.totalCountersText.isEmpty)
        XCTAssertFalse(didChangeState)
    }

    // MARK: - Fetch counters
    func test_fetchCounters_shouldSucceed() {
        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.responseBody)!
        let expectedViewState = CountersViewModel.ViewState.hasContent
        let expectedCountersText = "3 items - Counted 0 time"

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "fetch with success")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            expectation.fulfill()
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNil(receivedError)
    }

    func test_fetchCounters_shouldError() {
        let expectedCounters: [Counter] = []
        let expectedViewState = expectedViewStateError(type: .fetch)
        let expectedCountersText = ""

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        givenSession(session: session, data: CounterMocks.responseEmptyBody, statusCode: 500)

        let expectation = self.expectation(description: "fetch with error")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            expectation.fulfill()
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertTrue(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNotNil(receivedError)
    }

    // MARK: - Increment counter
    func test_incrementCounters_shouldSucceed() {
        let counterToIncrement = Counter(id: "kqquwv6f", title: "Coffee")

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.incrementResponseBody)!
        let expectedViewState = CountersViewModel.ViewState.hasContent
        let expectedCountersText = "3 items - Counted 1 time"
        let expectedCount = 1

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        givenSession(session: session, data: CounterMocks.incrementResponseBody)

        let expectation = self.expectation(description: "increment")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            expectation.fulfill()
        }

        sut.incrementCounter(counterToIncrement)

        wait(for: [expectation], timeout: timeout)

        let incrementedCounter = sut.counters.first

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertEqual(incrementedCounter?.count, expectedCount)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNil(receivedError)
    }

    func test_incrementCounters_shouldError() {
        let counterToIncrement = Counter(id: "kqquwv6f", title: "Coffee")

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.responseBody)!
        let expectedViewState = expectedViewStateError(type: .increment(counterToIncrement))
        let expectedCountersText = "3 items - Counted 0 time"
        let expectedCount = 0
        let expectedError = CountersViewModel.ViewStateError(title: "Couldn’t update the \"Coffee\" counter to 1",
                                                             message: "The Internet connection appears to be offline.",
                                                             type: .increment(counterToIncrement))

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch")
        let incrementExpectation = expectation(description: "increment")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            receivedViewState = viewState
            receivedError = error

            viewState == .hasContent ? fetchExpectation.fulfill() : incrementExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.responseBody, statusCode: 500)

        sut.incrementCounter(counterToIncrement)

        wait(for: [incrementExpectation], timeout: timeout)

        let incrementedCounter = sut.counters.first

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertEqual(incrementedCounter?.count, expectedCount)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError, expectedError)
    }

    // MARK: - Decrement counter
    func test_decrementCounters_shouldSucceed() {
        let counterToDecrement = Counter(id: "kqquwv6f", title: "Coffee", count: 1)

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.responseBody)!
        let expectedViewState = CountersViewModel.ViewState.hasContent
        let expectedCountersText = "3 items - Counted 0 time"
        let expectedCount = 0

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch success")
        let decrementExpectation = expectation(description: "decrement success")

        sut.didChangeState = {[weak self] viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            self?.sut.counters.first?.count == 1 ? fetchExpectation.fulfill()
                                                 : decrementExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.incrementResponseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.decrementCounter(counterToDecrement)

        wait(for: [decrementExpectation], timeout: timeout)

        let incrementedCounter = sut.counters.first

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertEqual(incrementedCounter?.count, expectedCount)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNil(receivedError)
    }

    func test_decrementCounterWith0count_shouldNotSucceed() {
        let counterToDecrement = Counter(id: "kqquwv6f", title: "Coffee", count: 0)

        var decrementCalled = false

        sut.didChangeState = { _, _ in
            decrementCalled = true
        }

        sut.decrementCounter(counterToDecrement)

        XCTAssertFalse(decrementCalled)
    }

    func test_decrementCounters_shouldError() {
        let counterToDecrement = Counter(id: "kqquwv6f", title: "Coffee", count: 1)

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.responseBody)!
        let expectedViewState = expectedViewStateError(type: .decrement(counterToDecrement))
        let expectedCountersText = "3 items - Counted 0 time"
        let expectedCount = 0
        let expectedError = CountersViewModel.ViewStateError(title: "Couldn’t update the \"Coffee\" counter to 0",
                                                             message: "The Internet connection appears to be offline.",
                                                             type: .decrement(counterToDecrement))

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch success")
        let incrementExpectation = expectation(description: "decrement error")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            receivedViewState = viewState
            receivedError = error

            viewState == .hasContent ? fetchExpectation.fulfill() : incrementExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.responseBody, statusCode: 500)

        sut.decrementCounter(counterToDecrement)

        wait(for: [incrementExpectation], timeout: timeout)

        let incrementedCounter = sut.counters.first

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertEqual(incrementedCounter?.count, expectedCount)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError, expectedError)
    }

    // MARK: - Delete counter
    func test_deleteCounter_shouldSucceed() {
        let indexPathToDelete = [IndexPath(row: 0, section: 0)]

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.deleteResponseBody)!
        let expectedViewState = CountersViewModel.ViewState.hasContent
        let expectedCountersText = "2 items - Counted 0 time"

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch success")
        let deleteExpectation = expectation(description: "delete success")

        sut.didChangeState = {[weak self] viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            self?.sut.counters.first?.id == "kqquwv6f" ? fetchExpectation.fulfill() : deleteExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.deleteResponseBody)
        sut.deleteCounters(at: indexPathToDelete) {}

        wait(for: [deleteExpectation], timeout: timeout)

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNil(receivedError)
    }

    func test_deleteMultipleCounter_shouldSucceed() {
        let indexPathToDelete = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.deleteResponseBody)!
        let expectedViewState = CountersViewModel.ViewState.hasContent
        let expectedCountersText = "2 items - Counted 0 time"

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch success")
        let deleteExpectation = expectation(description: "delete success")

        sut.didChangeState = {[weak self] viewState, error in
            guard viewState != .loading else { return }
            receivedViewState = viewState
            receivedError = error
            self?.sut.counters.first?.id == "kqquwv6f" ? fetchExpectation.fulfill() : deleteExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.deleteResponseBody)
        sut.deleteCounters(at: indexPathToDelete) {}

        wait(for: [deleteExpectation], timeout: timeout)

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNil(receivedError)
    }

    func test_deleteCounterCallClosure_shouldSucceed() {
        let indexPathToDelete = [IndexPath(row: 0, section: 0)]

        var closureCalled = false

        let fetchExpectation = expectation(description: "fetch success")
        let deleteExpectation = expectation(description: "delete success")

        sut.didChangeState = {[weak self] viewState, error in
            guard viewState != .loading else { return }
            self?.sut.counters.first?.id == "kqquwv6f" ? fetchExpectation.fulfill() : deleteExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.deleteResponseBody)
        sut.deleteCounters(at: indexPathToDelete) {
            closureCalled = true
        }

        wait(for: [deleteExpectation], timeout: timeout)

        XCTAssertTrue(closureCalled)
    }

    func test_deleteCounter_shouldError() {
        let counterToDelete = Counter(id: "kqquwv6f", title: "Coffee")
        let indexPathToDelete = [IndexPath(row: 0, section: 0)]

        let expectedCounters: [Counter] = expectedModel(mock: CounterMocks.responseBody)!
        let expectedViewState = expectedViewStateError(type: .delete(counterToDelete))
        let expectedCountersText = "3 items - Counted 0 time"
        let expectedCount = 0
        let expectedError = CountersViewModel.ViewStateError(title: "Couldn’t delete the counter \"Coffee\"",
                                                             message: "The Internet connection appears to be offline.",
                                                             type: .delete(counterToDelete))

        var receivedViewState = CountersViewModel.ViewState.noContent
        var receivedError: CountersViewModel.ViewStateError?

        let fetchExpectation = expectation(description: "fetch success")
        let deleteExpectation = expectation(description: "delete error")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            receivedViewState = viewState
            receivedError = error

            viewState == .hasContent ? fetchExpectation.fulfill() : deleteExpectation.fulfill()
        }

        givenSession(session: session, data: CounterMocks.responseBody)
        sut.fetchCounters()

        wait(for: [fetchExpectation], timeout: timeout)

        givenSession(session: session, data: CounterMocks.responseBody, statusCode: 500)

        sut.deleteCounters(at: indexPathToDelete) {}

        wait(for: [deleteExpectation], timeout: timeout)

        let incrementedCounter = sut.counters.first

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)

        XCTAssertEqual(sut.counters, expectedCounters)
        XCTAssertFalse(sut.isCountersEmpty)
        XCTAssertTrue(sut.isFilteredCountersEmpty)
        XCTAssertEqual(incrementedCounter?.count, expectedCount)

        XCTAssertEqual(sut.totalCountersText, expectedCountersText)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError, expectedError)
    }

    // Public methods
    func test_checkFirstTimeUser_shouldReturnTrue() {
        XCTAssertTrue(sut.checkFirstTimeUse())
    }

    func test_checkFirstTimeUser_shouldReturnFalse() {
        _ = sut.checkFirstTimeUse()

        XCTAssertFalse(sut.checkFirstTimeUse())
    }

    func test_filterCounters_shouldReturn1Counter() {
        let expectedFilteredCounter = [Counter(id: "kqqux3m1", title: "Tea")]
        let expectedViewState = CountersViewModel.ViewState.searching

        var receivedViewState = CountersViewModel.ViewState.noContent

        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "fetch with success")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            if viewState == .searching {
                receivedViewState = viewState
                return
            }

            expectation.fulfill()
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        sut.searchCounters(title: "tea")

        XCTAssertEqual(sut.filteredCounters, expectedFilteredCounter)
        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)
    }

    func test_filterCounters_shouldReturn0Counter() {
        let expectedFilteredCounter: [Counter] = []
        let expectedViewState = CountersViewModel.ViewState.searching

        var receivedViewState = CountersViewModel.ViewState.noContent

        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "fetch with success")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            if viewState == .searching {
                receivedViewState = viewState
                return
            }

            expectation.fulfill()
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        sut.searchCounters(title: "whisky")

        XCTAssertEqual(sut.filteredCounters, expectedFilteredCounter)
        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState, expectedViewState)
    }

    func test_didEndFiltering_shouldReturnHasContent() {
        let expectedViewState = CountersViewModel.ViewState.hasContent

        var receivedViewState: [CountersViewModel.ViewState] = []

        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "fetch with success")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading,
                  viewState != .searching else { return }

            receivedViewState.append(viewState)

            if receivedViewState.count == 1 {
                expectation.fulfill()
            }
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        sut.searchCounters(title: "tea")

        sut.didEndFiltering()

        XCTAssertEqual(sut.viewState, expectedViewState)
        XCTAssertEqual(receivedViewState.last, expectedViewState)
        XCTAssertTrue(sut.filteredCounters.isEmpty)
    }

    func test_shareItems_shoudReturnItemsToShare() {
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        let expectedSharedItems = ["0 x Coffee", "0 x Tea"]

        givenSession(session: session, data: CounterMocks.responseBody)

        let expectation = self.expectation(description: "fetch with success")

        sut.didChangeState = { viewState, error in
            guard viewState != .loading else { return }

            expectation.fulfill()
        }

        sut.fetchCounters()

        waitForExpectations(timeout: timeout, handler: nil)

        let sharedItems = sut.shareItems(at: indexPaths)

        XCTAssertEqual(sharedItems, expectedSharedItems)
    }
}

// MARK: - Helpers
extension CountersViewModelTests {
    func expectedModel<T: Decodable>(mock: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: mock)
    }

    func expectedViewStateError(type: CountersViewModel.ViewErrorType) -> CountersViewModel.ViewState {
        var title: String?
        var message: String? = "The Internet connection appears to be offline."

        switch type {
        case .fetch:
            title = "Couldn’t update counters"

        case .increment(let counter):
            title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count + 1)"

        case .decrement(let counter):
            title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count - 1)"

        case .delete(let counter):
            title = "Couldn’t delete the counter \"\(counter.title ?? "")\""

        case .none:
            title = nil
            message = nil
        }

        return CountersViewModel.ViewState.error(.init(title: title, message: message, type: type))
    }
}
