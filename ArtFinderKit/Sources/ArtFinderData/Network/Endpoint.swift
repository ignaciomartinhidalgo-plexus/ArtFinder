//
//  Endpoint.swift
//  ArtFinderKit
//

import Foundation

enum ApiVersion: String, Sendable {
    case v1
}

enum Endpoint {

    static let artworksSearch = "/api/\(ApiVersion.v1.rawValue)/artworks/search"
}
