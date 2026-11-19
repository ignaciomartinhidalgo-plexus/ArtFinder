//
//  ArtworkDomainModel.swift
//  ArtFinderKit
//

import Foundation

public struct ArtworkDomainModel: Identifiable, Hashable, Sendable {

    // MARK: - Properties

    public let id: Int
    public let title: String
    public let artist: String?
    public let date: String?
    public let medium: String?
    public let dimensions: String?
    public let placeOfOrigin: String?
    public let creditLine: String?
    public let image: ArtworkImageDomainModel?

    // MARK: - Initializer

    public init(id: Int,
                title: String,
                artist: String? = nil,
                date: String? = nil,
                medium: String? = nil,
                dimensions: String? = nil,
                placeOfOrigin: String? = nil,
                creditLine: String? = nil,
                image: ArtworkImageDomainModel? = nil) {
        self.id = id
        self.title = title
        self.artist = artist
        self.date = date
        self.medium = medium
        self.dimensions = dimensions
        self.placeOfOrigin = placeOfOrigin
        self.creditLine = creditLine
        self.image = image
    }
}
