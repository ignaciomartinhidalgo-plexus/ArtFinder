//
//  ErrorUIModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public struct ErrorUIModel: Equatable, Sendable {

    // MARK: - Properties

    let title: String
    let message: String
    let systemImage: String

    // MARK: - Initializer

    init(domainError: DomainError) {
        switch domainError {
        case .noConnection:
            title = "error_no_connection_title".localized
            message = "error_no_connection_message".localized
            systemImage = "wifi.slash"
        case .rateLimited:
            title = "error_rate_limited_title".localized
            message = "error_rate_limited_message".localized
            systemImage = "hourglass"
        case .server, .invalidResponse, .unknown:
            title = "error_generic_title".localized
            message = "error_generic_message".localized
            systemImage = "exclamationmark.triangle"
        }
    }
}
