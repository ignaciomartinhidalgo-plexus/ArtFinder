//
//  AppCoordinator.swift
//  ArtFinder
//

import Foundation
import ArtFinderDomain
import ArtFinderPresentation

@Observable
@MainActor
final class AppCoordinator: SearchCoordinatorProtocol {

    // MARK: - Properties

    @ObservationIgnored private(set) lazy var searchViewModel = DependencyInjector.getSearchViewModel(coordinator: self)

    var artworkDetail: NavigationItem<ArtworkDetailViewModel> = .init()

    // MARK: - SearchCoordinatorProtocol

    func openArtworkDetail(_ artwork: ArtworkDomainModel) {
        artworkDetail.navigate(to: DependencyInjector.getArtworkDetailViewModel(artwork: artwork))
    }
}
