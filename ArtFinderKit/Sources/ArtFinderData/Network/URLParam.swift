//
//  URLParam.swift
//  ArtFinderKit
//

import Foundation

struct URLParam: Sendable {

    enum ParamKeys: String, Sendable {
        case query = "q"
        case limit
        case fields
    }

    let key: ParamKeys
    let value: String
}
