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
    var coordinator: CreateCounterCoordinatorMock!
    var session: URLSessionSpy!

    var createCounterCoordinatorDidFinish = false

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        let navigationcontroller = UINavigationController()
        coordinator = CreateCounterCoordinatorMock(navigationController: navigationcontroller)
        coordinator.start()
        coordinator.delegate = self

        session = URLSessionSpy()
        let client = APIClient(session: session, api: mockAPI)
        let service = CountersService(client: client)
        let viewModel = CreateCounterViewModel(service: service)

        sut = CreateCounterViewController(coordinator: coordinator, viewModel: viewModel)
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

        givenSession(session: session, data: CounterMocks.responseBody)

        if let saveButton = sut.navigationItem.rightBarButtonItem {
            _ = saveButton.target?.perform(saveButton.action, with: nil)

            XCTAssertFalse(coordinator.didDismiss)
        }
    }

    func test_tapSaveButtonServiceError_shouldNotSave() {
        sut.loadViewIfNeeded()

        sut.titleTextField.text = "beer"
        sut.titleTextField.sendActions(for: .editingChanged)

        givenSession(session: session, data: CounterMocks.responseBody, statusCode: 500)

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
