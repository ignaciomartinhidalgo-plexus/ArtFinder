//
//  UIModelTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderPresentation

@Suite("ErrorUIModel")
struct ErrorUIModelTests {

    @Test("Maps each domain error to its message", arguments: [
        (DomainError.noConnection, "error_no_connection_title", "wifi.slash"),
        (DomainError.rateLimited, "error_rate_limited_title", "hourglass"),
        (DomainError.server(statusCode: 500), "error_generic_title", "exclamationmark.triangle"),
        (DomainError.invalidResponse, "error_generic_title", "exclamationmark.triangle"),
        (DomainError.unknown, "error_generic_title", "exclamationmark.triangle")
    ])
    func mapsDomainError(error: DomainError, titleKey: String, systemImage: String) {
        let sut = ErrorUIModel(domainError: error)

        #expect(sut.title == titleKey.localized)
        #expect(sut.systemImage == systemImage)
    }
}
