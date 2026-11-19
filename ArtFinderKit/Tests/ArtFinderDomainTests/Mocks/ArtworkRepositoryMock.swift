//
//  ArtworkRepositoryMock.swift
//  ArtFinderKit
//

@testable import ArtFinderDomain

actor ArtworkRepositoryMock: ArtworkRepositoryProtocol {

    // MARK: - Properties

    private let result: Result<[ArtworkDomainModel], Error>
    private(set) var receivedQueries: [SearchQueryRequestDomainModel] = []

    // MARK: - Initializer

    init(result: Result<[ArtworkDomainModel], Error>) {
        self.result = result
    }

    // MARK: - ArtworkRepositoryProtocol

    func searchArtworks(request: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        receivedQueries.append(request)
        return try result.get()
    }
}
