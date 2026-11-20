//
//  ImageRepositoryProtocol.swift
//  ArtFinderKit
//

import Foundation

public protocol ImageRepositoryProtocol: Sendable {
    func loadImageData(from url: URL) async throws -> Data
}
