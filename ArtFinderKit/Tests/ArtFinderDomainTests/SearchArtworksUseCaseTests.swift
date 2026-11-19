//
//  SearchArtworksUseCaseTests.swift
//  ArtFinderKit
//

import Testing
@testable import ArtFinderDomain

@Suite("SearchArtworksUseCase")
struct SearchArtworksUseCaseTests {

    // MARK: - Properties

    private let query: SearchQueryRequestDomainModel

    // MARK: - Initializer

    init() throws {
        query = try #require(SearchQueryRequestDomainModel("Monet"))
    }

    // MARK: - Tests

    @Test("Forwards the query to the repository and returns its artworks")
    func returnsRepositoryResults() async throws {
        let artworks = [ArtworkDomainModel.create(id: 1), ArtworkDomainModel.create(id: 2, title: "Irises")]
        let repository = ArtworkRepositoryMock(result: .success(artworks))
        let sut = SearchArtworksUseCase(repository: repository)

        let result = try await sut.execute(query)

        #expect(result == artworks)
        #expect(await repository.receivedQueries == [query])
    }

    @Test("Propagates the repository errors")
    func propagatesErrors() async {
        let repository = ArtworkRepositoryMock(result: .failure(DomainError.noConnection))
        let sut = SearchArtworksUseCase(repository: repository)

        await #expect(throws: DomainError.noConnection) {
            try await sut.execute(query)
        }
    }
}
