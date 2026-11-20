//
//  ArtworkDomainModel+Create.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

extension ArtworkDomainModel {

    static func create(id: Int = 1,
                       title: String = "Water Lilies",
                       artist: String? = "Claude Monet\nFrench, 1840-1926",
                       date: String? = "1906",
                       medium: String? = "Oil on canvas",
                       dimensions: String? = "89.9 × 94.1 cm",
                       placeOfOrigin: String? = "France",
                       creditLine: String? = "Mr. and Mrs. Martin A. Ryerson Collection",
                       image: ArtworkImageDomainModel? = .create()) -> ArtworkDomainModel {
        .init(id: id,
              title: title,
              artist: artist,
              date: date,
              medium: medium,
              dimensions: dimensions,
              placeOfOrigin: placeOfOrigin,
              creditLine: creditLine,
              image: image)
    }
}

extension ArtworkImageDomainModel {

    static func create(altText: String? = "Painting of water lilies floating on a pond.",
                       aspectRatio: Double? = 1.5) -> ArtworkImageDomainModel? {
        guard let thumbnailURL = URL(string: "https://www.artic.edu/iiif/2/abc/full/200,/0/default.jpg"),
              let fullSizeURL = URL(string: "https://www.artic.edu/iiif/2/abc/full/843,/0/default.jpg") else {
            return nil
        }
        return .init(thumbnailURL: thumbnailURL,
                     fullSizeURL: fullSizeURL,
                     altText: altText,
                     aspectRatio: aspectRatio)
    }
}
