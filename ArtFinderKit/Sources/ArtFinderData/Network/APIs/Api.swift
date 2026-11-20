//
//  Api.swift
//  ArtFinderKit
//

import Foundation

enum Api {
    case searchArtworks(SearchArtworksRequestDataModel)
}

extension Api: ApiBuilder {

    var host: String {
        switch self {
        case .searchArtworks:
            return "api.artic.edu"
        }
    }

    var path: String {
        switch self {
        case .searchArtworks:
            return Endpoint.artworksSearch
        }
    }

    var httpMethod: HttpMethod {
        switch self {
        case .searchArtworks:
            return .get
        }
    }

    var parameters: Encodable? {
        switch self {
        case .searchArtworks(let request):
            return request
        }
    }

    var urlParameters: [URLParam] {
        switch self {
        case .searchArtworks:
            return []
        }
    }

    var headers: [String: String] {
        AICHeader.all
    }
}
