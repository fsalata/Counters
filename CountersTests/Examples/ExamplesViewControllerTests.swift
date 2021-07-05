//
//  ExamplesViewControllerTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 05/07/21.
//

import XCTest
@testable import Counters

class ExamplesViewControllerTests: XCTestCase {
    var sut: ExamplesViewController!

    var selectedItem: Example?

    override func setUp() {
        super.setUp()

        let navigationcontroller = UINavigationController()
        let viewModel = ExamplesViewModel()
        viewModel.delegate = self

        sut = ExamplesViewController(coordinator: ExamplesCoordinator(navigationController: navigationcontroller),
                                     viewModel: viewModel)
        navigationcontroller.pushViewController(sut, animated: false)
    }

    override func tearDown() {
        sut = nil
        selectedItem = nil

        super.tearDown()
    }

    func testOutlets() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.collectionView)
    }

    func test_initalValues() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.navigationController?.navigationBar.tintColor, .orange)
        XCTAssertEqual(sut.collectionView.backgroundColor, UIColor(named: .lighterGrey))
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertNotNil(sut.collectionView.dataSource)
    }

    func test_numberOfCollectionViewItens() {
        let expectedNumberofSections = 3
        let expectedRowsInSection = 4

        sut.loadViewIfNeeded()

        let sectionRowsCount = sut.collectionView.numberOfItems(inSection: 0)

        XCTAssertEqual(sut.collectionView.numberOfSections, expectedNumberofSections)
        XCTAssertEqual(sectionRowsCount, expectedRowsInSection)
    }

    func test_firstCell_shouldReturnCupsOfCoffee() {
        let expectedValue = "Cups of coffee"

        sut.loadViewIfNeeded()

        let cell = cellForRowInSection(in: sut.collectionView, row: 0, section: 0) as? ExampleCollectionViewCell

        XCTAssertEqual(cell?.titleLabel.text, expectedValue)
    }

    func test_selectItem_shoulReturnItem() {
        let expectedItem = Example(name: "cups of coffee")

        sut.loadViewIfNeeded()

        didSelectRow(in: sut.collectionView, row: 0, section: 0)

        XCTAssertEqual(selectedItem, expectedItem)
    }
}

extension ExamplesViewControllerTests: ExamplesViewModelDelegate {
    func examplesViewModel(didSelect item: Example, _ viewModel: ExamplesViewModel) {
        selectedItem = item
    }
}
