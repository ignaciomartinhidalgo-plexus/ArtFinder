//
//  ApiError.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

enum ApiErrorType: Sendable {
    case badRequest
    case accessRestricted
    case forbidden
    case notFound
    case timeout
    case rateLimited
    case serverError
    case serviceUnavailable
    case noConnection
    case decoding
    case unknown
}

struct ApiError: Error {

    // MARK: - Properties

    let type: ApiErrorType
    let statusCode: Int?
    let message: String?
    let underlyingError: Error?

    // MARK: - Initializer

    init(type: ApiErrorType,
         statusCode: Int? = nil,
         message: String? = nil,
         underlyingError: Error? = nil) {
        self.type = type
        self.statusCode = statusCode
        self.message = message
        self.underlyingError = underlyingError
    }

    // MARK: - Functions

    func parseToDomainError() -> DomainError {
        switch type {
        case .noConnection, .timeout:
            return .noConnection
        case .rateLimited:
            return .rateLimited
        case .decoding:
            return .invalidResponse
        case .badRequest, .accessRestricted, .forbidden, .notFound, .serverError, .serviceUnavailable:
            guard let statusCode else { return .unknown }
            return .server(statusCode: statusCode)
        case .unknown:
            return .unknown
        }
    }
}
