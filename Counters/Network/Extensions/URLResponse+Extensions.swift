//
//  URLResponse+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/07/21.
//

import Foundation

enum ValidationStatus {
    case informational      // 100
    case success            // 200
    case redirection        // 300
    case clientError        // 400
    case serverError        // 500
    case unknown
}

extension URLResponse {
    var validationStatus: ValidationStatus {
        if let httpResponse = self as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 0...199:
                return .informational
            case 200...299:
                return .success
            case 300...399:
                return .redirection
            case 400...499:
                return .clientError
            case 500...599:
                return .serverError
            default:
                return .unknown
            }
        } else {
            return .unknown
        }
    }
}
