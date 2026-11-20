//
//  EnvironmentValuesExtension.swift
//  ArtFinderKit
//

import SwiftUI

private struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue: ImageLoaderProtocol? = nil
}

public extension EnvironmentValues {

    var imageLoader: ImageLoaderProtocol? {
        get {
            self[ImageLoaderKey.self]
        }
        set {
            self[ImageLoaderKey.self] = newValue
        }
    }
}
