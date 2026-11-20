//
//  ImageLoaderProtocol.swift
//  ArtFinderKit
//

import Foundation

public protocol ImageLoaderProtocol: Sendable {
    func loadImageData(from url: URL) async throws -> Data
}
