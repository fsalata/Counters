//
//  APIClientTests.swift
//  NetworkLayerTests
//
//  Created by Fabio Cezar Salata on 05/06/21.
//

import XCTest
@testable import Counters

class APIClientTests: XCTestCase {
    private var sut: APIClient!
    private var session: URLSessionSpy!

    let mockAPI = MockAPI()

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        sut = APIClient(session: session, api: mockAPI)
    }

    override func tearDown() {
        sut = nil
        session = nil

        super.tearDown()
    }

    func test_init_setsAPI() {
        let expectedURL = mockAPI.baseURL

        XCTAssertEqual(sut.api.baseURL, expectedURL)
    }

    func test_calledResume() {
        givenSession(session: session, data: nil)

        let expectation = self.expectation(description: "Resume called")

        let dataTask = sut.request(target: MockGETServiceTarget.get(page: 0)) { (result: Result<Int?, APIError>, response) in
            expectation.fulfill()
        } as! URLSessionDataTaskSpy

        wait(for: [expectation], timeout: timeout)

        XCTAssertTrue(dataTask.calledResume)
    }

    // MARK: GET tests
    func test_get_shouldReturnData() {
        let expectedMethod = "GET"
        let expectedURL = "https://mock.com/get?page=5"
        let expectedResult = User(username: "fsalata",
                                  name: "Fábio Salata",
                                  age: 39)
        var userResponse: User?

        givenSession(session: session, data: userMock())

        let expectation = self.expectation(description: "Resume called")

        sut.request(target: MockGETServiceTarget.get(page: 5)) { (result: Result<User, APIError>, response) in
            switch result {
            case .success(let user):
                userResponse = user
                expectation.fulfill()
            case .failure:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(userResponse, expectedResult)
    }

    func test_get_shouldReturnInternalServerError() {
        let expectedResult = APIError.service(.internalServerError)
        var errorResponse: APIError?

        givenSession(session: session, data: userMock(), statusCode: 500)

        let expectation = self.expectation(description: "Resume called")

        sut.request(target: MockGETServiceTarget.get(page: 0)) { (result: Result<User, APIError>, response) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                errorResponse = error
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(errorResponse, expectedResult)
    }

    func test_get_shouldReturnNotFound() {
        let expectedResult = APIError.network(.notConnectedToInternet)
        var errorResponse: APIError?

        givenSession(session: session, data: userMock(), error: URLError(.notConnectedToInternet))

        let expectation = self.expectation(description: "Resume called")

        sut.request(target: MockGETServiceTarget.get(page: 0)) { (result: Result<User, APIError>, response) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                errorResponse = error
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(errorResponse, expectedResult)
    }

    func test_get_shouldReturnParseError() {
        let debugDescription = "No value associated with key CodingKeys(stringValue: \"username\", intValue: nil) (\"username\")."
        let expectedResult = APIError.parse(.keyNotFound(debugDescription: debugDescription))
        var errorResponse: APIError?

        givenSession(session: session, data: malformedUserMock())

        let expectation = self.expectation(description: "Resume called")

        sut.request(target: MockGETServiceTarget.get(page: 0)) { (result: Result<User, APIError>, response) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                errorResponse = error
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)

        XCTAssertEqual(errorResponse, expectedResult)
    }

    // MARK: POST tests
    func test_post_shouldReturnData() {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/post"
        let expectedResult = User(username: "fsalata",
                                  name: "Fábio Salata",
                                  age: 39)
        var userResponse: User?

        givenSession(session: session, data: userMock())

        let user = User(username: "fsalata", name: "Fábio Salata", age: 39)

        let expectation = self.expectation(description: "Resume called")

        sut.request(target: MockPOSTServiceTarget.post(user: user)) { (result: Result<User, APIError>, response) in
            switch result {
            case .success(let user):
                userResponse = user
                expectation.fulfill()
            case .failure:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)

        let httpBody = try? JSONDecoder().decode(User.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, user)
        XCTAssertEqual(userResponse, expectedResult)
    }
}
