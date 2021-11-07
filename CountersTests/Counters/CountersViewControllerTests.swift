//
//  CountersViewControllerTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 13/07/21.
//

import XCTest
@testable import Counters

class CountersViewControllerTests: XCTestCase {
    var sut: CountersViewController!
    var factory: MockDependencyFactory!
    var coordinator: CountersCoordinatorMock!

    var createCounterCoordinatorDidFinish = false

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        factory = MockDependencyFactory()

        let navigationcontroller = UINavigationController()
        coordinator = CountersCoordinatorMock(navigationController: navigationcontroller, factory: factory)
        coordinator.start()

        sut = factory.makeCountersViewController(coordinator: coordinator)
        navigationcontroller.pushViewController(sut, animated: false)
    }

    override func tearDown() {
        sut = nil
        factory = nil
        coordinator = nil
        createCounterCoordinatorDidFinish = false

        super.tearDown()
    }

    func test_outlets_notNil() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.deleteButton)
        XCTAssertNotNil(sut.addNewButton)
        XCTAssertNotNil(sut.shareButton)
        XCTAssertNotNil(sut.totalCountLabel)
    }
}

// MARK: - Mock
class CountersCoordinatorMock: CountersCoordinator {
    var didPresentWelcomeScreen = false
    var didPresentCreateCounters = false

    override func presentWelcomeScreen() {
        super.presentWelcomeScreen()
        didPresentWelcomeScreen = true
    }

    override func presentCreateItem() {
        super.presentCreateItem()
        didPresentCreateCounters = true
    }
}
