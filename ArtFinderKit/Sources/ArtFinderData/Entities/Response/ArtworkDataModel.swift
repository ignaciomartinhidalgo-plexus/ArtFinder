//
//  ArtworkDataModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

struct ArtworkDataModel: Decodable, Sendable {

    // MARK: - Properties

    static let requestedFields = CodingKeys.allCases.map(\.rawValue).joined(separator: ",")

    private static let thumbnailSize = "200,"
    private static let fullSize = "843,"

    let id: Int?
    let title: String?
    let artistDisplay: String?
    let dateDisplay: String?
    let mediumDisplay: String?
    let dimensions: String?
    let placeOfOrigin: String?
    let creditLine: String?
    let imageID: String?
    let thumbnail: ArtworkThumbnailDataModel?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case title
        case artistDisplay = "artist_display"
        case dateDisplay = "date_display"
        case mediumDisplay = "medium_display"
        case dimensions
        case placeOfOrigin = "place_of_origin"
        case creditLine = "credit_line"
        case imageID = "image_id"
        case thumbnail
    }

    // MARK: - Functions

    func parseToDomainModel(iiifBaseURL: URL?) -> ArtworkDomainModel? {
        guard let id else { return nil }
        return .init(id: id,
                     title: title ?? "",
                     artist: artistDisplay,
                     date: dateDisplay,
                     medium: mediumDisplay,
                     dimensions: dimensions,
                     placeOfOrigin: placeOfOrigin,
                     creditLine: creditLine,
                     image: parseImage(iiifBaseURL: iiifBaseURL))
    }

    // MARK: - Private functions

    private func parseImage(iiifBaseURL: URL?) -> ArtworkImageDomainModel? {
        guard let iiifBaseURL,
              let imageID,
              let thumbnailURL = Self.iiifURL(base: iiifBaseURL, imageID: imageID, size: Self.thumbnailSize),
              let fullSizeURL = Self.iiifURL(base: iiifBaseURL, imageID: imageID, size: Self.fullSize) else {
            return nil
        }
        return .init(thumbnailURL: thumbnailURL,
                     fullSizeURL: fullSizeURL,
                     altText: thumbnail?.altText,
                     aspectRatio: thumbnail?.aspectRatio)
    }

    private static func iiifURL(base: URL, imageID: String, size: String) -> URL? {
        URL(string: "\(base.absoluteString)/\(imageID)/full/\(size)/0/default.jpg")
    }
}
