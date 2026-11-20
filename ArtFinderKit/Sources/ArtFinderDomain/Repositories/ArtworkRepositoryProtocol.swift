//
//  ArtworkRepositoryProtocol.swift
//  ArtFinderKit
//

import Foundation

public protocol ArtworkRepositoryProtocol: Sendable {
    func searchArtworks(request: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel]
}
