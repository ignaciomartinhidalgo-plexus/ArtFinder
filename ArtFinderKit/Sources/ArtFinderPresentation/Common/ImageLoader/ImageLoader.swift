//
//  ImageLoader.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

public struct ImageLoader: ImageLoaderProtocol {

    // MARK: - Properties

    private let repository: ImageRepositoryProtocol

    // MARK: - Initializer

    public init(repository: ImageRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - ImageLoaderProtocol

    public func loadImageData(from url: URL) async throws -> Data {
        try await repository.loadImageData(from: url)
    }
}
