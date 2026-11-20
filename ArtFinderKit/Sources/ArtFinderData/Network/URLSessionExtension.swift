//
//  URLSessionExtension.swift
//  ArtFinderKit
//

import Foundation

extension URLSession {

    // MARK: - Properties

    private static let maxResponseSize = 10 * 1024 * 1024 // 10 MB

    // MARK: - Functions

    func validatedData(for request: URLRequest) async throws -> Data {
        let result: (Data, URLResponse)
        do {
            result = try await self.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch let error as URLError {
            throw ApiError(type: errorType(for: error), underlyingError: error)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw ApiError(type: .unknown, underlyingError: error)
        }

        let (responseData, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError(type: .unknown, message: "Response is not HTTP")
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ApiError(type: errorType(for: httpResponse.statusCode), statusCode: httpResponse.statusCode)
        }

        guard responseData.count <= Self.maxResponseSize else {
            throw ApiError(type: .unknown, message: "Response too large: \(responseData.count) bytes")
        }

        return responseData
    }

    // MARK: - Private functions

    private func errorType(for statusCode: Int) -> ApiErrorType {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .accessRestricted
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 408:
            return .timeout
        case 429:
            return .rateLimited
        case 503:
            return .serviceUnavailable
        case 500...599:
            return .serverError
        default:
            return .unknown
        }
    }

    private func errorType(for error: URLError) -> ApiErrorType {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost,
             .dnsLookupFailed, .internationalRoamingOff, .dataNotAllowed:
            return .noConnection
        case .timedOut:
            return .timeout
        default:
            return .unknown
        }
    }
}
