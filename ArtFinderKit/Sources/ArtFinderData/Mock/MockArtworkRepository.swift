//
//  MockArtworkRepository.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public struct MockArtworkRepository: ArtworkRepositoryProtocol {

    // MARK: - Properties

    public static let errorQuery = "error"

    private let artworks: [ArtworkDomainModel]
    private let delay: Duration

    // MARK: - Initializer

    public init(artworks: [ArtworkDomainModel] = MockArtworkRepository.sampleArtworks,
                delay: Duration = .milliseconds(300)) {
        self.artworks = artworks
        self.delay = delay
    }

    // MARK: - ArtworkRepositoryProtocol

    public func searchArtworks(request: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        try await Task.sleep(for: delay)

        if request.value == Self.errorQuery {
            throw DomainError.noConnection
        }

        return artworks.filter { artwork in
            artwork.title.lowercased().contains(request.value)
                || (artwork.artist?.lowercased().contains(request.value) ?? false)
        }
    }
}

// MARK: - Sample data

public extension MockArtworkRepository {

    static let sampleArtworks: [ArtworkDomainModel] = [
        .init(id: 16568,
              title: "Water Lilies",
              artist: "Claude Monet\nFrench, 1840-1926",
              date: "1906",
              medium: "Oil on canvas",
              dimensions: "89.9 × 94.1 cm (35 3/8 × 37 1/16 in.)",
              placeOfOrigin: "France",
              creditLine: "Mr. and Mrs. Martin A. Ryerson Collection"),
        .init(id: 28560,
              title: "The Bedroom",
              artist: "Vincent van Gogh\nDutch, 1853-1890",
              date: "1889",
              medium: "Oil on canvas",
              dimensions: "73.6 × 92.3 cm (29 × 36 5/8 in.)",
              placeOfOrigin: "France",
              creditLine: "Helen Birch Bartlett Memorial Collection"),
        .init(id: 27992,
              title: "A Sunday on La Grande Jatte — 1884",
              artist: "Georges Seurat\nFrench, 1859-1891",
              date: "1884–86",
              medium: "Oil on canvas",
              dimensions: "207.5 × 308.1 cm (81 3/4 × 121 1/4 in.)",
              placeOfOrigin: "France",
              creditLine: "Helen Birch Bartlett Memorial Collection"),
        .init(id: 111628,
              title: "Nighthawks",
              artist: "Edward Hopper\nAmerican, 1882-1967",
              date: "1942",
              medium: "Oil on canvas",
              dimensions: "84.1 × 152.4 cm (33 1/8 × 60 in.)",
              placeOfOrigin: "United States",
              creditLine: "Friends of American Art Collection"),
        .init(id: 6565,
              title: "American Gothic",
              artist: "Grant Wood\nAmerican, 1891-1942",
              date: "1930",
              medium: "Oil on beaver board",
              dimensions: "78 × 65.3 cm (30 3/4 × 25 3/4 in.)",
              placeOfOrigin: "United States",
              creditLine: "Friends of American Art Collection")
    ]
}
