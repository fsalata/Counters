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
    var coordinator: CountersCoordinatorMock!
    var session: URLSessionSpy!

    var createCounterCoordinatorDidFinish = false

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        let navigationcontroller = UINavigationController()
        coordinator = CountersCoordinatorMock(navigationController: navigationcontroller)
        coordinator.start()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        let service = CountersService(client: client)
        let viewModel = CountersViewModel(service: service)

        sut = CountersViewController(coordinator: coordinator, viewModel: viewModel)
        navigationcontroller.pushViewController(sut, animated: false)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        session = nil
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
