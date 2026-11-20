//
//  SearchViewModel.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

@Observable
@MainActor
public final class SearchViewModel: LifecycleViewProtocol {

    // MARK: - Properties

    public private(set) var searchText = ""
    public private(set) var state: ViewState<[ArtworkRowUIModel]> = .idle

    @ObservationIgnored public var isLoaded = false
    @ObservationIgnored private(set) var searchTask: Task<Void, Never>?
    @ObservationIgnored private var domainArtworks: [ArtworkDomainModel] = []
    @ObservationIgnored private weak var coordinator: SearchCoordinatorProtocol?
    private let searchArtworksUseCase: any UseCaseProtocol<SearchQueryRequestDomainModel, [ArtworkDomainModel]>
    private let debounce: Duration

    var accessibilityAnnouncement: String? {
        switch state {
        case .idle, .loading:
            return nil
        case .loaded(let artworks):
            return "search_results_announcement".localized(with: artworks.count)
        case .empty:
            return "search_empty_announcement".localized
        case .failure(let error):
            return error.title
        }
    }

    // MARK: - Initializer

    public init(searchArtworksUseCase: any UseCaseProtocol<SearchQueryRequestDomainModel, [ArtworkDomainModel]>,
                coordinator: SearchCoordinatorProtocol?,
                debounce: Duration = .milliseconds(400)) {
        self.searchArtworksUseCase = searchArtworksUseCase
        self.coordinator = coordinator
        self.debounce = debounce
    }

    // MARK: - Functions

    public func updateSearchText(_ text: String) {
        guard text != searchText else { return }
        searchText = text
        startSearch(debounced: true)
    }

    public func retrySearch() {
        startSearch(debounced: false)
    }

    public func didSelect(_ row: ArtworkRowUIModel) {
        guard let artwork = domainArtworks.first(where: { $0.id == row.id }) else { return }
        coordinator?.openArtworkDetail(artwork)
    }

    // MARK: - Private functions

    private func startSearch(debounced: Bool) {
        searchTask?.cancel()

        domainArtworks = []

        guard let request = SearchQueryRequestDomainModel(searchText) else {
            searchTask = nil
            state = .idle
            return
        }

        state = .loading
        let delay = debounced ? debounce : .zero

        searchTask = Task { [weak self] in
            do {
                if delay > .zero {
                    try await Task.sleep(for: delay)
                }
                let artworks = try await self?.searchArtworksUseCase.execute(request) ?? []
                try Task.checkCancellation()
                self?.showResults(artworks)
            } catch is CancellationError {
                // Replaced by a newer search or by clearing the text: nothing to show.
            } catch {
                guard !Task.isCancelled else { return }
                self?.state = .failure(.init(domainError: error as? DomainError ?? .unknown))
            }
        }
    }

    private func showResults(_ artworks: [ArtworkDomainModel]) {
        self.domainArtworks = artworks
        state = artworks.isEmpty ? .empty : .loaded(artworks.map {
            .init(domainModel: $0)
        })
    }
}
