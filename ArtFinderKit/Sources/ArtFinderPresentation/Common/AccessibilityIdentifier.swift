//
//  AccessibilityIdentifier.swift
//  ArtFinderKit
//

import Foundation

enum AccessibilityIdentifier {
    static let searchList = "search.list"
    static let searchRetryButton = "search.retryButton"
    static let detailTitle = "detail.title"
    static let detailImage = "detail.image"

    static func searchRow(_ artworkID: Int) -> String {
        "search.row.\(artworkID)"
    }
}
