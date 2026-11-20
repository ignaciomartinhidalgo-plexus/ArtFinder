//
//  SearchArtworksRequestDataModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

struct SearchArtworksRequestDataModel: Encodable, Sendable {

    // MARK: - Properties

    let query: String
    let limit: Int
    let fields: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case query = "q"
        case limit
        case fields
    }

    // MARK: - Initializer

    init(request: SearchQueryRequestDomainModel, limit: Int = 20) {
        self.query = request.value
        self.limit = limit
        self.fields = ArtworkDataModel.requestedFields
    }
}
