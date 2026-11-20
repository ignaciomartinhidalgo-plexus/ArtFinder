//
//  ViewState.swift
//  ArtFinderKit
//

import Foundation

public enum ViewState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case empty
    case failure(ErrorUIModel)
}
