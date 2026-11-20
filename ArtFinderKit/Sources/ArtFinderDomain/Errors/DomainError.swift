//
//  DomainError.swift
//  ArtFinderKit
//

import Foundation

public enum DomainError: Error, Equatable, Sendable {
    case noConnection
    case rateLimited
    case server(statusCode: Int)
    case invalidResponse
    case unknown
}
