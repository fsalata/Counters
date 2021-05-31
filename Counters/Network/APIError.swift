//
//  APIError.swift
//  Counters
//

import Foundation

enum APIError: Error, Equatable {
    case service(Service)
    case network(Network)
    case parse(Parse)
    case unknown

    enum Service: Error, Equatable {
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case requestTimeout
        case clientError
        case internalServerError
        case noData
        case unknown(String)
    }

    enum Network: Error, Equatable {
        case cancelled
        case networkConnectionLost
        case badURL
        case timedOut
        case notConnectedToInternet
        case unknown(String)
    }

    enum Parse: Error, Equatable {
        case typeMismatch(debugDescription: String)
        case valueNotFound(debugDescription: String)
        case keyNotFound(debugDescription: String)
        case dataCorrupted(debugDescription: String)
        case unknown
    }
}

extension APIError {
    init(_ error: HTTPURLResponse) {
        self = .service(Service(error))
    }

    init(_ error: URLError) {
        self = .network(Network(error))
    }

    init(_ error: DecodingError) {
        self = .parse(Parse(error))
    }

    init(_ error: Error) {
        switch error {
        case let serviceError as HTTPURLResponse:
            self.init(serviceError)
        case let urlError as URLError:
            self.init(urlError)
        case let decodingError as DecodingError:
            self.init(decodingError)
        default:
            self = APIError.unknown
        }
    }
}

extension APIError.Service {
    init(_ httpURLResponse: HTTPURLResponse) {
        switch httpURLResponse.statusCode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405, 406, 407, 409..<500: self = .clientError
        case 408: self = .requestTimeout
        case 500..<600: self = .internalServerError
        default: self = .unknown(httpURLResponse.debugDescription)
        }
    }
}

extension APIError.Network {
    init(_ urlError: URLError) {
        switch urlError.code {
        case .cancelled: self = .cancelled
        case .networkConnectionLost: self = .networkConnectionLost
        case .badURL: self = .badURL
        case .timedOut: self = .timedOut
        case .notConnectedToInternet: self = .notConnectedToInternet
        default: self = .unknown(urlError.localizedDescription)
        }
    }
}

extension APIError.Parse {
    init(_ decodingError: DecodingError) {
        switch decodingError {
        case let .typeMismatch( _, context): self = .typeMismatch(debugDescription: context.debugDescription)
        case let .valueNotFound( _, context): self = .valueNotFound(debugDescription: context.debugDescription)
        case let .keyNotFound( _, context): self = .keyNotFound(debugDescription: context.debugDescription)
        case let .dataCorrupted(context): self = .dataCorrupted(debugDescription: context.debugDescription)
        default: self = .unknown
        }
    }
}
