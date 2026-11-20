//
//  URLProtocolStub.swift
//  ArtFinderKit
//

import Foundation
import Testing

@Suite(.serialized)
enum URLProtocolStubTests {}

final class URLProtocolStub: URLProtocol {

    // MARK: - Properties

    nonisolated(unsafe) private static var result: Result<(statusCode: Int, body: Data), URLError>?
    nonisolated(unsafe) private(set) static var requests: [URLRequest] = []

    // MARK: - Functions

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    static func respond(statusCode: Int = 200, body: Data = Data()) {
        result = .success((statusCode, body))
    }

    static func fail(with error: URLError) {
        result = .failure(error)
    }

    static func reset() {
        result = nil
        requests = []
    }

    // MARK: - URLProtocol

    override static func canInit(with request: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.requests.append(request)

        switch Self.result {
        case .success(let response):
            guard let url = request.url,
                  let httpResponse = HTTPURLResponse(url: url, statusCode: response.statusCode, httpVersion: nil, headerFields: nil) else {
                client?.urlProtocol(self, didFailWithError: URLError(.badURL))
                return
            }
            client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: response.body)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        case nil:
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
        }
    }

    override func stopLoading() {}
}
