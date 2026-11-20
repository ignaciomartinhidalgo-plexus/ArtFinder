//
//  SearchArtworksUseCase.swift
//  ArtFinderKit
//

import Foundation

public struct SearchArtworksUseCase: UseCaseProtocol {

    // MARK: - Properties

    private let repository: ArtworkRepositoryProtocol

    // MARK: - Initializer

    public init(repository: ArtworkRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - UseCaseProtocol

    public func execute(_ input: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        try await repository.searchArtworks(request: input)
    }
}
