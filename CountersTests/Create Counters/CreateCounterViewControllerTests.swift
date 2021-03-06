//
//  CreateCounterViewControllerTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 10/07/21.
//

import XCTest
@testable import Counters

class CreateCounterViewControllerTests: XCTestCase {

    var sut: CreateCounterViewController!
    var factory: MockDependencyFactory!
    var coordinator: CreateCounterCoordinatorMock!

    var createCounterCoordinatorDidFinish = false

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        factory = MockDependencyFactory()

        let navigationcontroller = UINavigationController()
        coordinator = CreateCounterCoordinatorMock(navigationController: navigationcontroller, factory: factory)
        coordinator.start()
        coordinator.delegate = self

        sut = factory.makeCreateCounterViewController(coordinator: coordinator)
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

        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.examplesButton)
    }

    func test_initValues() {
        let expectedTitle = "Create a counter"
        let expectedBackButtonTitle = "Create"

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.navigationItem.backButtonTitle, expectedBackButtonTitle)
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)

        XCTAssertEqual(sut.examplesButton.titleLabel?.text, CreateCounterStrings.examplesText)
    }

    func test_typeTextEnableSave_shouldBeTrue() {
        sut.loadViewIfNeeded()

        sut.titleTextField.text = "beer"
        sut.titleTextField.sendActions(for: .editingChanged)

        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.isEnabled ?? false)
    }

    func test_tapSaveButtonEmptyText_shouldNotSave() {
        sut.loadViewIfNeeded()

        if let saveButton = sut.navigationItem.rightBarButtonItem {
            _ = saveButton.target?.perform(saveButton.action, with: nil)

            XCTAssertFalse(coordinator.didDismiss)
        }
    }

    func test_tapSaveButton_shouldSave() {
        sut.loadViewIfNeeded()

        sut.titleTextField.text = "beer"
        sut.titleTextField.sendActions(for: .editingChanged)

        givenSession(session: factory.session, data: CounterMocks.responseBody)

        if let saveButton = sut.navigationItem.rightBarButtonItem {
            _ = saveButton.target?.perform(saveButton.action, with: nil)

            XCTAssertFalse(coordinator.didDismiss)
        }
    }

    func test_tapSaveButtonServiceError_shouldNotSave() {
        sut.loadViewIfNeeded()

        sut.titleTextField.text = "beer"
        sut.titleTextField.sendActions(for: .editingChanged)

        givenSession(session: factory.session, data: CounterMocks.responseBody, statusCode: 500)

        if let saveButton = sut.navigationItem.rightBarButtonItem {
            _ = saveButton.target?.perform(saveButton.action, with: nil)

            XCTAssertFalse(coordinator.didDismiss)
        }
    }

    func test_exampleButtonTap_shouldPresentExamples() {
        sut.loadViewIfNeeded()

        tap(sut.examplesButton)

        XCTAssertTrue(coordinator.didPresentExampleScreen)
    }

    func test_textFieldShouldReturn_shouldNotSave() {
        sut.loadViewIfNeeded()

        let shouldReturn = sut.titleTextField.delegate?.textFieldShouldReturn?(sut.titleTextField)

        XCTAssertTrue(shouldReturn ?? false)
        XCTAssertFalse(coordinator.didDismiss)
    }

    func test_textFieldShouldReturn_shouldSave() {
        sut.loadViewIfNeeded()

        sut.titleTextField.text = "beer"
        sut.titleTextField.sendActions(for: .editingChanged)

        let shouldReturn = sut.titleTextField.delegate?.textFieldShouldReturn?(sut.titleTextField)

        XCTAssertTrue(shouldReturn ?? false)
        XCTAssertFalse(coordinator.didDismiss)
    }
}

extension CreateCounterViewControllerTests: CreateCounterCoordinatorDelegate {
    func createCounterCoordinatorDidFinish(_ coordinator: CreateCounterCoordinator) {
        createCounterCoordinatorDidFinish = true
    }
}

// MARK: - Mock
class CreateCounterCoordinatorMock: CreateCounterCoordinator {
    var didPresentExampleScreen = false
    var didDismiss = false

    override func presentExamplesScreen() {
        super.presentExamplesScreen()
        didPresentExampleScreen = true
    }

    override func dismiss() {
        super.dismiss()
        didDismiss = true
    }
}
