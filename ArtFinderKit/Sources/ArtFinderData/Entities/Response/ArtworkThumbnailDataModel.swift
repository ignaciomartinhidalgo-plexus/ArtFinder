//
//  ArtworkThumbnailDataModel.swift
//  ArtFinderKit
//

import Foundation

struct ArtworkThumbnailDataModel: Decodable, Sendable {

    // MARK: - Properties

    let altText: String?
    let width: Double?
    let height: Double?

    var aspectRatio: Double? {
        guard let width, let height, width > .zero, height > .zero else {
            return nil
        }
        return width / height
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case altText = "alt_text"
        case width
        case height
    }
}
