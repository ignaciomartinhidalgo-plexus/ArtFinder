//
//  URLSessionRepository+PerformRequest.swift
//  ArtFinderKit
//

import Foundation

extension URLSessionRepository {

    // MARK: - Functions

    func performRequest<T: Decodable & Sendable>(from endpoint: ApiBuilder) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw ApiError(type: .badRequest)
        }
        let data = try await session.validatedData(for: request)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError(type: .decoding, underlyingError: error)
        }
    }
}
