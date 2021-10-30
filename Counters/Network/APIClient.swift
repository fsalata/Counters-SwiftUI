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

    func request<T: Decodable>(target: ServiceTargetProtocol) -> AnyPublisher<T, APIError> {
        guard var urlRequest = try? URLRequest(baseURL: api.baseURL, target: target) else {
            return Fail(error: APIError.network(.badURL)).eraseToAnyPublisher()
        }

        urlRequest.allHTTPHeaderFields = target.header

        return session.erasedDataTaskPublisher(for: urlRequest)
            .retry(1)
            .mapError { error in
                return APIError(error)
            }
            .debugResponse(request: urlRequest)
            .extractData()
            .decode()
            .mapError { error in
                return error as? APIError ?? APIError.unknown
            }
            .eraseToAnyPublisher()
    }

    func request(target: ServiceTargetProtocol) -> AnyPublisher<URLResponse, APIError> {
        guard var urlRequest = try? URLRequest(baseURL: api.baseURL, target: target) else {
            return Fail(error: APIError.network(.badURL)).eraseToAnyPublisher()
        }

        urlRequest.allHTTPHeaderFields = target.header

        return session.erasedDataTaskPublisher(for: urlRequest)
            .retry(1)
            .mapError { error in
                return APIError(error)
            }
            .tryMap({ (_, response) in
                if let response = response as? HTTPURLResponse,
                   !(200..<300 ~= response.statusCode) {
                    throw APIError(response)
                }

                return response
            })
            .mapError { error in
                return error as? APIError ?? APIError.unknown
            }
            .eraseToAnyPublisher()
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
