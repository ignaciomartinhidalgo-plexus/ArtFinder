//
//  ArtworkSearchResponseDataModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

struct ArtworkSearchResponseDataModel: Decodable, Sendable {

    // MARK: - Properties

    let data: [ArtworkDataModel]?
    let config: ConfigDataModel?

    // MARK: - Functions

    func parseToDomainModel() -> [ArtworkDomainModel] {
        data?.compactMap {
            $0.parseToDomainModel(iiifBaseURL: config?.iiifURL)
        } ?? []
    }
}

struct ConfigDataModel: Decodable, Sendable {

    // MARK: - Properties

    let iiifURL: URL?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case iiifURL = "iiif_url"
    }
}
