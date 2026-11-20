//
//  SearchCoordinatorProtocol.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

@MainActor
public protocol SearchCoordinatorProtocol: AnyObject {
    func openArtworkDetail(_ artwork: ArtworkDomainModel)
}
