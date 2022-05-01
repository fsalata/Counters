//
//  APIClient.swift
//  Counters
//

import Foundation

class APIClient {
    private var session: URLSessionProtocol
    private(set) var api: APIProtocol

    init(session: URLSessionProtocol = URLSession.shared,
         api: APIProtocol) {
        self.session = session
        self.api = api
    }

    /// Async Request
    /// - Returns: (T: Decodable, URLResponse?)
    func request<T: Decodable>(target: ServiceTargetProtocol) async throws -> (T, URLResponse) {
        guard var urlRequest = try? URLRequest(baseURL: api.baseURL, target: target) else {
            throw APIError.network(.badURL)
        }

        urlRequest.allHTTPHeaderFields = target.header

        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        
        try Task.checkCancellation()

        if let response = response as? HTTPURLResponse,
           response.validationStatus != .success {
            throw APIError(response)
        }
        
        debugResponse(request: urlRequest, data: data, response: response, error: nil)
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)

        return (decodedData, response)
    }
}

extension APIClient {
    // Print API request/response data
    func debugResponse(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {
        #if DEBUG
        Swift.print("============================ REQUEST ============================")
        Swift.print("\nURL: \(request.url?.absoluteString ?? "")")

        Swift.print("\nMETHOD: \(request.httpMethod ?? "")")

        if let requestHeader = request.allHTTPHeaderFields {
            if let data = try? JSONSerialization.data(withJSONObject: requestHeader, options: .prettyPrinted) {
                Swift.print("\nHEADER: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }

        if let requestBody = request.httpBody {
            if let jsonObject = try? JSONSerialization.jsonObject(with: requestBody) {
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                    Swift.print("\nBODY: \(String(data: jsonData, encoding: .utf8) ?? "")")
                }
            }
        }

        Swift.print("\n============================ RESPONSE ============================")
        if let data = data,
           let jsonObject = try? JSONSerialization.jsonObject(with: data) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                Swift.print(String(data: jsonData, encoding: .utf8) ?? "")
            }
        }

        if let urlError = error as? URLError {
            print("\n❌ ======= ERROR =======")
            print("❌ CODE: \(urlError.errorCode)")
            print("❌ DESCRIPTION: \(urlError.localizedDescription)\n")
        }

        Swift.print("\n==================================================================\n")
        #endif
    }
}
