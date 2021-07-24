//
//  WelcomeViewModelTests.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import XCTest
@testable import Counters

class WelcomeViewModelTests: XCTestCase {
    var sut: WelcomeViewModel!

    override func setUp() {
        super.setUp()

        sut = WelcomeViewModel(features: WelcomeFeature.getFeatures())
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_featuresCount_shouldBe3() {
        XCTAssertEqual(sut.features.count, 3)
    }
}
