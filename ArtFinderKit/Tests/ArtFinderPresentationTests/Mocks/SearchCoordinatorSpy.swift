//
//  SearchCoordinatorSpy.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain
@testable import ArtFinderPresentation

@MainActor
final class SearchCoordinatorSpy: SearchCoordinatorProtocol {

    // MARK: - Properties

    private(set) var shownArtworks: [ArtworkDomainModel] = []

    // MARK: - SearchCoordinatorProtocol

    func openArtworkDetail(_ artwork: ArtworkDomainModel) {
        shownArtworks.append(artwork)
    }
}
