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

    // MARK: GET tests
    func test_get_shouldReturnData() async throws {
        let expectedMethod = "GET"
        let expectedURL = "https://mock.com/get?page=5"
        let expectedResult = User(username: "fsalata",
                                  name: "Fábio Salata",
                                  age: 39)
        var userResponse: User?

        givenSession(session: session, data: userMock())

        let (user, _): (User, URLResponse) = try await sut.request(target: MockGETServiceTarget.get(page: 5))
        userResponse = user

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(userResponse, expectedResult)
    }

    func test_get_shouldReturnInternalServerError() async throws {
        let expectedResult = APIError.service(.internalServerError)
        var errorResponse: APIError?

        givenSession(session: session, data: userMock(), statusCode: 500)
        
        do {
            let (_, _): (User, URLResponse) = try await sut.request(target: MockGETServiceTarget.get(page: 0))
        } catch let error as APIError {
            errorResponse = error
        }

        XCTAssertEqual(errorResponse, expectedResult)
    }

    func test_get_shouldReturnNotFound() async throws {
        let expectedResult = APIError.network(.notConnectedToInternet)
        var errorResponse: APIError?

        givenSession(session: session, data: userMock(), error: URLError(.notConnectedToInternet))

        do {
            let (_, _): (User, URLResponse) = try await sut.request(target: MockGETServiceTarget.get(page: 0))
        } catch {
            errorResponse = APIError(error)
        }

        XCTAssertEqual(errorResponse, expectedResult)
    }

    func test_get_shouldReturnParseError() async throws {
        let debugDescription = "No value associated with key CodingKeys(stringValue: \"username\", intValue: nil) (\"username\")."
        let expectedResult = APIError.parse(.keyNotFound(debugDescription: debugDescription))
        var errorResponse: APIError?

        givenSession(session: session, data: malformedUserMock())

        do {
            let (_, _): (User, URLResponse) = try await sut.request(target: MockGETServiceTarget.get(page: 0))
        } catch {
            errorResponse = APIError(error)
        }

        XCTAssertEqual(errorResponse, expectedResult)
    }

    // MARK: POST tests
    func test_post_shouldReturnData() async throws {
        let expectedMethod = "POST"
        let expectedURL = "https://mock.com/post"
        let expectedResult = User(username: "fsalata",
                                  name: "Fábio Salata",
                                  age: 39)
        var userResponse: User?

        givenSession(session: session, data: userMock())

        let userMock = User(username: "fsalata", name: "Fábio Salata", age: 39)
        
        let (user, _): (User, URLResponse) = try await sut.request(target: MockPOSTServiceTarget.post(user: userMock))
        userResponse = user

        let httpBody = try? JSONDecoder().decode(User.self, from: session.dataTaskArgsRequest.first?.httpBody ?? Data())

        XCTAssertEqual(session.method, expectedMethod)
        XCTAssertEqual(session.url?.absoluteString, expectedURL)
        XCTAssertEqual(httpBody, user)
        XCTAssertEqual(userResponse, expectedResult)
    }
}
