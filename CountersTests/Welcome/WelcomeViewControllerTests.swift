//
//  WelcomeViewControllerTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import XCTest
@testable import Counters

class WelcomeViewControllerTests: XCTestCase {
    var sut: WelcomeViewController!
    var factory: MockDependencyFactory!
    var coordinator: WelcomeCoordinatorMock!

    override func setUp() {
        super.setUp()

        factory = MockDependencyFactory()

        coordinator = WelcomeCoordinatorMock(navigationController: UINavigationController(), factory: factory)
        sut = factory.makeWelcomeViewController(coordinator: coordinator)
    }

    override func tearDown() {
        sut = nil
        factory = nil
        coordinator = nil

        super.tearDown()
    }

    func test_outlets_notNil() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.contentStackView)
        XCTAssertNotNil(sut.continueButton)
    }

    func test_stackViewFeaturesCount_shoudHave3() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.contentStackView.arrangedSubviews.count, 3)
    }

    func test_navBarIsHidden_shouldBeTrue() {
        coordinator.start()

        XCTAssertTrue(coordinator.navigationController.navigationBar.isHidden)
    }

    func test_tapDismissButton_ShouldBeTrue() {
        sut.loadViewIfNeeded()

        tap(sut.continueButton)

        XCTAssertTrue(coordinator.didTapDismiss)
        XCTAssertFalse(coordinator.navigationController.navigationBar.isHidden)
    }
}

// MARK: - Mock
class WelcomeCoordinatorMock: WelcomeCoordinator {
    var didTapDismiss = false

    override func dismiss() {
        super.dismiss()
        didTapDismiss = true
    }
}
