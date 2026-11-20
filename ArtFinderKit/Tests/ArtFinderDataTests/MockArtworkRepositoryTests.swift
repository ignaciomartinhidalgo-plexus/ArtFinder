//
//  MockArtworkRepositoryTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderData

@Suite("MockArtworkRepository")
struct MockArtworkRepositoryTests {

    // MARK: - Properties

    private let sut = MockArtworkRepository(delay: .zero)

    // MARK: - Tests

    @Test("Finds artworks by title or artist", arguments: [
        ("nighthawks", [111628]),
        ("monet", [16568]),
        ("american", [111628, 6565])
    ])
    func findsArtworks(query: String, expectedIDs: [Int]) async throws {
        let request = try #require(SearchQueryRequestDomainModel(query))

        let artworks = try await sut.searchArtworks(request: request)

        #expect(artworks.map(\.id) == expectedIDs)
    }

    @Test("The error query simulates a connection failure")
    func errorQuery() async throws {
        let request = try #require(SearchQueryRequestDomainModel(MockArtworkRepository.errorQuery))

        await #expect(throws: DomainError.noConnection) {
            try await sut.searchArtworks(request: request)
        }
    }
}
