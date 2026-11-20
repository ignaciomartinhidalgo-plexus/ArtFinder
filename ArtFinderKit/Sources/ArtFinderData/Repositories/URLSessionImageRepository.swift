//
//  URLSessionImageRepository.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public final class URLSessionImageRepository: ImageRepositoryProtocol {

    // MARK: - Properties

    public static let cacheTimeToLive: TimeInterval = 30 * 60

    private let session: URLSession
    private let cache: InMemoryCache<URL, Data>

    // MARK: - Initializer

    public init(session: URLSession, cache: InMemoryCache<URL, Data>) {
        self.session = session
        self.cache = cache
    }

    public convenience init() {
        self.init(session: URLSession(configuration: .artFinder),
                  cache: InMemoryCache(timeToLive: Self.cacheTimeToLive))
    }

    // MARK: - ImageRepositoryProtocol

    public func loadImageData(from url: URL) async throws -> Data {
        if let cachedData = await cache.value(for: url) {
            return cachedData
        }

        var request = URLRequest(url: url)
        AICHeader.all.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        do {
            let data = try await session.validatedData(for: request)
            await cache.insert(data, for: url)
            return data
        } catch let error as ApiError {
            throw error.parseToDomainError()
        }
    }
}
