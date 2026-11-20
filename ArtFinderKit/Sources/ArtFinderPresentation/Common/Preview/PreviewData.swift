//
//  PreviewData.swift
//  ArtFinderKit
//

#if DEBUG
import Foundation
import ArtFinderDomain

struct PreviewSearchArtworksUseCase: UseCaseProtocol {

    func execute(_ input: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        try await Task.sleep(for: .milliseconds(300))
        return ArtworkDomainModel.previewData
    }
}

extension ArtworkDomainModel {

    static let previewData: [ArtworkDomainModel] = [
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
              placeOfOrigin: "France")
    ]
}

extension SearchViewModel {

    static var preview: SearchViewModel {
        .init(searchArtworksUseCase: PreviewSearchArtworksUseCase(), coordinator: nil)
    }
}

extension ArtworkDetailViewModel {

    static var preview: ArtworkDetailViewModel {
        .init(artwork: ArtworkDomainModel.previewData[0])
    }
}
#endif
