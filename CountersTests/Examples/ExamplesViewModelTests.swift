//
//  ExamplesViewModelTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 05/07/21.
//

import XCTest
@testable import Counters

class ExamplesViewModelTests: XCTestCase {
    var sut: ExamplesViewModel!

    var selectedExample: Example?

    override func setUp() {
        super.setUp()

        sut = ExamplesViewModel()
        sut.delegate = self
    }

    override func tearDown() {
        sut = nil
        selectedExample = nil

        super.tearDown()
    }

    func test_initalItemsCount_shouldReturn3() {
        XCTAssertEqual(sut.examples.count, 3)
    }

    func test_dictionaryKeysOrder_shouldBeAscending() {
        let expectedKeys = ["drinks", "food", "misc"]

        XCTAssertEqual(sut.sectionKeys, expectedKeys)
    }

    func test_selectExampleDelegate_ShouldReturnItem() {
        let expectedItem = Example(name: "beer")

        sut.didSelect(item: expectedItem)

        XCTAssertEqual(selectedExample, expectedItem)
    }
}

extension ExamplesViewModelTests: ExamplesViewModelDelegate {
    func examplesViewModel(didSelect item: Example, _ viewModel: ExamplesViewModel) {
        selectedExample = item
    }
}
