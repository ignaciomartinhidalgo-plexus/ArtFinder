//
//  ArtworkDataModelMappingTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderData

@Suite("ArtworkDataModel mapping")
struct ArtworkDataModelMappingTests {

    // MARK: - Tests

    @Test("Maps every field of a complete artwork")
    func mapsCompleteArtwork() throws {
        let artwork = try #require(try decodeArtworks().first)

        #expect(artwork.id == 16568)
        #expect(artwork.title == "Water Lilies")
        #expect(artwork.artist == "Claude Monet\nFrench, 1840-1926")
        #expect(artwork.date == "1906")
        #expect(artwork.medium == "Oil on canvas")
        #expect(artwork.dimensions == "89.9 × 94.1 cm (35 3/8 × 37 1/16 in.)")
        #expect(artwork.placeOfOrigin == "France")
        #expect(artwork.creditLine == "Mr. and Mrs. Martin A. Ryerson Collection")
    }

    @Test("Builds IIIF image URLs, alt text and aspect ratio")
    func mapsImage() throws {
        let image = try #require(try decodeArtworks().first?.image)

        #expect(image.thumbnailURL.absoluteString == "https://www.artic.edu/iiif/2/3c27b499-af56-f0d5-93b5-a7f2f1ad5813/full/200,/0/default.jpg")
        #expect(image.fullSizeURL.absoluteString == "https://www.artic.edu/iiif/2/3c27b499-af56-f0d5-93b5-a7f2f1ad5813/full/843,/0/default.jpg")
        #expect(image.altText == "Painting of a pond seen up close spotted with thickly painted pink and white water lilies.")
        #expect(image.aspectRatio == 1.5)
    }

    @Test("Missing or blank fields become nil and there is no image without image_id")
    func mapsIncompleteArtwork() throws {
        let artwork = try #require(try decodeArtworks().last)

        #expect(artwork.title.isEmpty)
        #expect(artwork.artist == nil)
        #expect(artwork.date == nil)
        #expect(artwork.medium == nil)
        #expect(artwork.image == nil)
    }

    @Test("Without config there is no IIIF base URL, so artworks are mapped without images")
    func mapsWithoutConfig() throws {
        let artworks = try JSONDecoder()
            .decode(ArtworkSearchResponseDataModel.self, from: ArtworkSearchJSON.withoutConfig)
            .parseToDomainModel()

        #expect(artworks.map(\.id) == [7])
        #expect(artworks.first?.image == nil)
    }

    @Test("Artworks without id are discarded")
    func discardsArtworksWithoutID() throws {
        let artworks = try JSONDecoder()
            .decode(ArtworkSearchResponseDataModel.self, from: ArtworkSearchJSON.withMissingID)
            .parseToDomainModel()

        #expect(artworks.map(\.id) == [1])
        #expect(artworks.first?.title == "Kept")
    }

    // MARK: - Helpers

    private func decodeArtworks() throws -> [ArtworkDomainModel] {
        try JSONDecoder()
            .decode(ArtworkSearchResponseDataModel.self, from: ArtworkSearchJSON.twoArtworks)
            .parseToDomainModel()
    }
}
