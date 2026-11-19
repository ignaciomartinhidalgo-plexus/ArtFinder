//
//  SearchQueryRequestDomainModel.swift
//  ArtFinderKit
//

import Foundation

public struct SearchQueryRequestDomainModel: Hashable, Sendable {

    // MARK: - Properties

    public static let minimumLength = 2
    public let value: String

    // MARK: - Initializer

    public init?(_ rawValue: String) {
        let normalized = rawValue
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
            .lowercased()

        guard normalized.count >= Self.minimumLength else { return nil }
        self.value = normalized
    }
}
