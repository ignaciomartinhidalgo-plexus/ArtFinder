//
//  URLSessionRepository.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public final class URLSessionRepository: ArtworkRepositoryProtocol {

    // MARK: - Properties

    public static let cacheTimeToLive: TimeInterval = 5 * 60

    let session: URLSession
    private let cache: InMemoryCache<SearchQueryRequestDomainModel, [ArtworkDomainModel]>

    // MARK: - Initializer

    public init(session: URLSession,
                cache: InMemoryCache<SearchQueryRequestDomainModel, [ArtworkDomainModel]>) {
        self.session = session
        self.cache = cache
    }

    public convenience init() {
        self.init(session: URLSession(configuration: .artFinder),
                  cache: InMemoryCache(timeToLive: Self.cacheTimeToLive))
    }

    // MARK: - ArtworkRepositoryProtocol

    public func searchArtworks(request: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        if let cachedArtworks = await cache.value(for: request) {
            return cachedArtworks
        }

        do {
            let response: ArtworkSearchResponseDataModel = try await performRequest(
                from: Api.searchArtworks(.init(request: request))
            )
            let artworks = response.parseToDomainModel()
            await cache.insert(artworks, for: request)
            return artworks
        } catch let error as ApiError {
            throw error.parseToDomainError()
        }
    }
}
