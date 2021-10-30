//
//  APIClient.swift
//  Counters
//

import Foundation
import Combine

class APIClient {
    private var session: URLSessionProtocol
    private(set) var api: APIProtocol

    init(session: URLSessionProtocol = URLSession.shared,
         api: APIProtocol) {
        self.session = session
        self.api = api
    }

    /// Request
    /// - Parameters:
    ///   - target: ServiceTargetProtocol
    ///   - completion: (Result<T, APIError>, URLResponse?) -> Void
    @discardableResult
    func request<T: Decodable>(target: ServiceTargetProtocol,
                               completion: @escaping (Result<T, APIError>, URLResponse?) -> Void) -> URLSessionDataTask? {
        guard var urlRequest = try? URLRequest(baseURL: api.baseURL, target: target) else {
            completion(.failure(.network(.badURL)), nil)
            return nil
        }

        urlRequest.allHTTPHeaderFields = target.header

        let dataTask = session.dataTask(with: urlRequest) {[weak self] data, response, error in
            self?.debugResponse(request: urlRequest, data: data, response: response, error: error)

            if let error = error {
                completion(.failure(APIError(error)), response)
            } else {
                guard let data = data else {
                    completion(.failure(.service(.noData)), response)
                    return
                }

                if let response = response as? HTTPURLResponse,
                   response.validationStatus != .success {
                    completion(.failure(APIError(response)), response)
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData), response)
                } catch {
                    completion(.failure(APIError(error)), response)
                }
            }
        }

        dataTask.resume()

        return dataTask
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
