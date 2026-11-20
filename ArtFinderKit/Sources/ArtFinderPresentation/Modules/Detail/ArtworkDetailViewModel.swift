//
//  ArtworkDetailViewModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

@Observable
@MainActor
public final class ArtworkDetailViewModel: LifecycleViewProtocol {

    // MARK: - Properties

    @ObservationIgnored public var isLoaded = false
    let artworkDetail: ArtworkDetailUIModel

    // MARK: - Initializer

    public init(artwork: ArtworkDomainModel) {
        self.artworkDetail = .init(domainModel: artwork)
    }
}
