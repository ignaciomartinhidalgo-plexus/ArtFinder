//
//  ArtworkImageDomainModel.swift
//  ArtFinderKit
//

import Foundation

public struct ArtworkImageDomainModel: Hashable, Sendable {

    // MARK: - Properties

    public let thumbnailURL: URL
    public let fullSizeURL: URL
    public let altText: String?
    public let aspectRatio: Double?

    // MARK: - Initializer

    public init(thumbnailURL: URL,
                fullSizeURL: URL,
                altText: String? = nil,
                aspectRatio: Double? = nil) {
        self.thumbnailURL = thumbnailURL
        self.fullSizeURL = fullSizeURL
        self.altText = altText
        self.aspectRatio = aspectRatio
    }
}
