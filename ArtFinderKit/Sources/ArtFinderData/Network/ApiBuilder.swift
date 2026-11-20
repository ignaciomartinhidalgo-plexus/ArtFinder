//
//  ApiBuilder.swift
//  ArtFinderKit
//

import Foundation

protocol ApiBuilder: Sendable {
    var host: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var parameters: Encodable? { get }
    var urlParameters: [URLParam] { get }
    var headers: [String: String] { get }
    var urlRequest: URLRequest? { get }
}

extension ApiBuilder {

    var urlRequest: URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path

        var queryItems = urlParameters.map {
            URLQueryItem(name: $0.key.rawValue, value: $0.value)
        }
        if httpMethod == .get {
            queryItems += parametersAsQueryItems
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        if httpMethod != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let parameters {
                request.httpBody = try? JSONEncoder().encode(parameters)
            }
        }
        return request
    }

    private var parametersAsQueryItems: [URLQueryItem] {
        guard let parameters,
              let data = try? JSONEncoder().encode(parameters),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }
        return dictionary
            .sorted { $0.key < $1.key }
            .map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
    }
}
