//
//  ArtworkFormatter.swift
//  ArtFinderKit
//

import Foundation

enum ArtworkFormatter {

    static func title(_ title: String) -> String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTitle.isEmpty ? "artwork_untitled".localized : trimmedTitle
    }

    static func artistName(_ artist: String?) -> String? {
        guard let firstLine = artist?.split(separator: "\n").first else { return nil }
        let name = firstLine.trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? nil : name
    }

    static func value(_ value: String?) -> String? {
        guard let trimmedValue = value?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedValue.isEmpty else {
            return nil
        }
        return trimmedValue
    }
}
