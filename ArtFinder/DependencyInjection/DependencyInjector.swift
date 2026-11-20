//
//  DependencyInjector.swift
//  ArtFinder
//

import Foundation
import ArtFinderDomain
import ArtFinderData
import ArtFinderPresentation

enum DependencyInjector {

    // MARK: - Configuration

    static let useMockDataArgument = "-useMockData"

    static var isUsingMockData: Bool {
        ProcessInfo.processInfo.arguments.contains(useMockDataArgument)
    }

    // MARK: - Repositories

    private static let artworkRepository: ArtworkRepositoryProtocol = {
        if isUsingMockData {
            return MockArtworkRepository()
        }
        return URLSessionRepository()
    }()

    private static let imageRepository: ImageRepositoryProtocol = URLSessionImageRepository()

    // MARK: - Image loading

    static func getImageLoader() -> ImageLoaderProtocol {
        ImageLoader(repository: imageRepository)
    }

    // MARK: - Use cases

    static func getSearchArtworksUseCase() -> any UseCaseProtocol<SearchQueryRequestDomainModel, [ArtworkDomainModel]> {
        SearchArtworksUseCase(repository: artworkRepository)
    }

    // MARK: - ViewModels

    static func getSearchViewModel(coordinator: SearchCoordinatorProtocol) -> SearchViewModel {
        .init(searchArtworksUseCase: getSearchArtworksUseCase(), coordinator: coordinator)
    }

    static func getArtworkDetailViewModel(artwork: ArtworkDomainModel) -> ArtworkDetailViewModel {
        .init(artwork: artwork)
    }

    // MARK: - Coordinators

    static func getAppCoordinator() -> AppCoordinator {
        .init()
    }
}
