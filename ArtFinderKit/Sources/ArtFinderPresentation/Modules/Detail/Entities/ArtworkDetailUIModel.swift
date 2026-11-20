//
//  ArtworkDetailUIModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

struct ArtworkDetailUIModel: Equatable, Sendable {

    // MARK: - ImageUIModel

    struct ImageUIModel: Equatable, Sendable {
        let url: URL
        let aspectRatio: Double
        let accessibilityLabel: String
    }

    // MARK: - FieldUIModel

    struct FieldUIModel: Identifiable, Equatable, Sendable {
        let title: String
        let value: String
        var id: String {
            title
        }
    }

    // MARK: - Properties

    let title: String
    let image: ImageUIModel?
    let fields: [FieldUIModel]

    // MARK: - Initializer

    init(domainModel: ArtworkDomainModel) {
        let title = ArtworkFormatter.title(domainModel.title)
        self.title = title
        self.image = domainModel.image.map { image in
                .init(url: image.fullSizeURL,
                      aspectRatio: image.aspectRatio ?? 1,
                      accessibilityLabel: ArtworkFormatter.value(image.altText)
                      ?? "detail_image_fallback_label".localized(with: title))
        }
        self.fields = Self.makeFields(from: domainModel)
    }

    // MARK: - Private functions

    private static func makeFields(from artwork: ArtworkDomainModel) -> [FieldUIModel] {
        let candidates: [(String, String?)] = [
            ("detail_field_artist".localized, artwork.artist),
            ("detail_field_date".localized, artwork.date),
            ("detail_field_medium".localized, artwork.medium),
            ("detail_field_dimensions".localized, artwork.dimensions),
            ("detail_field_place_of_origin".localized, artwork.placeOfOrigin),
            ("detail_field_credit_line".localized, artwork.creditLine)
        ]
        return candidates.compactMap { title, value in
            ArtworkFormatter.value(value).map {
                .init(title: title, value: $0)
            }
        }
    }
}
