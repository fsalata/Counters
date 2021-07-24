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
    var coordinator: WelcomeCoordinatorMock!

    override func setUp() {
        super.setUp()

        coordinator = WelcomeCoordinatorMock(navigationController: UINavigationController())
        sut = WelcomeViewController(coordinator: coordinator, viewModel: WelcomeViewModel())
    }

    override func tearDown() {
        sut = nil
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

class WelcomeCoordinatorMock: WelcomeCoordinator {
    var didTapDismiss = false

    override func dismiss() {
        super.dismiss()
        didTapDismiss = true
    }
}
