//
//  ArtworkRowUIModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public struct ArtworkRowUIModel: Identifiable, Equatable, Sendable {

    // MARK: - Properties

    public let id: Int
    let title: String
    let artistName: String?
    let date: String?
    let thumbnailURL: URL?

    var accessibilityLabel: String {
        [title, artistName, date]
            .compactMap { $0 }
            .joined(separator: ", ")
    }

    // MARK: - Initializer

    init(domainModel: ArtworkDomainModel) {
        self.id = domainModel.id
        self.title = ArtworkFormatter.title(domainModel.title)
        self.artistName = ArtworkFormatter.artistName(domainModel.artist)
        self.date = ArtworkFormatter.value(domainModel.date)
        self.thumbnailURL = domainModel.image?.thumbnailURL
    }
}
