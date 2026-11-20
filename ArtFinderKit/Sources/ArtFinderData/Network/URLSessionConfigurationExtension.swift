//
//  URLSessionConfigurationExtension.swift
//  ArtFinderKit
//

import Foundation

extension URLSessionConfiguration {

    static var artFinder: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return configuration
    }
}
