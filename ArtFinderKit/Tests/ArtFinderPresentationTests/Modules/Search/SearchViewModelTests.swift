//
//  SearchViewModelTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderPresentation

@MainActor
@Suite("SearchViewModel")
struct SearchViewModelTests {

    // MARK: - Properties

    private let monet = ArtworkDomainModel.create(id: 1, title: "Water Lilies")
    private let vanGogh = ArtworkDomainModel.create(id: 2, title: "The Bedroom")

    // MARK: - Initial state

    @Test("Starts idle without searching")
    func initialState() async {
        let useCase = SearchArtworksUseCaseMock()
        let sut = makeSUT(useCase: useCase)

        #expect(sut.state == .idle)
        #expect(sut.searchText.isEmpty)
        #expect(await useCase.receivedQueries.isEmpty)
    }

    @Test("Text shorter than the minimum length stays idle and doesn't search", arguments: [" ", "a", " b "])
    func invalidTextStaysIdle(text: String) async {
        let useCase = SearchArtworksUseCaseMock(result: .success([]))
        let sut = makeSUT(useCase: useCase)

        sut.updateSearchText(text)

        #expect(sut.state == .idle)
        #expect(sut.searchTask == nil)
        #expect(await useCase.receivedQueries.isEmpty)
    }

    // MARK: - Results

    @Test("Shows loading and then the results")
    func loadsResults() async {
        let useCase = SearchArtworksUseCaseMock(result: .success([monet]))
        let sut = makeSUT(useCase: useCase)

        sut.updateSearchText("  Monet ")
        #expect(sut.state == .loading)

        await sut.searchTask?.value

        #expect(sut.state == .loaded(rows([monet])))
        #expect(await useCase.receivedQueries == ["monet"])
    }

    @Test("Shows the empty state when nothing matches")
    func emptyResults() async {
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .success([])))

        sut.updateSearchText("zzzz")
        await sut.searchTask?.value

        #expect(sut.state == .empty)
    }

    @Test("Shows the domain error returned by the use case")
    func showsDomainError() async {
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .failure(DomainError.noConnection)))

        sut.updateSearchText("monet")
        await sut.searchTask?.value

        #expect(sut.state == .failure(ErrorUIModel(domainError: .noConnection)))
    }

    @Test("Unexpected errors are shown as unknown")
    func unexpectedError() async {
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .failure(URLError(.badURL))))

        sut.updateSearchText("monet")
        await sut.searchTask?.value

        #expect(sut.state == .failure(ErrorUIModel(domainError: .unknown)))
    }

    @Test("Retry searches the current text again")
    func retry() async {
        let useCase = SearchArtworksUseCaseMock(result: .failure(DomainError.noConnection))
        let sut = makeSUT(useCase: useCase)
        sut.updateSearchText("monet")
        await sut.searchTask?.value

        await useCase.setResult(.success([monet]))
        sut.retrySearch()
        await sut.searchTask?.value

        #expect(sut.state == .loaded(rows([monet])))
        #expect(await useCase.receivedQueries == ["monet", "monet"])
    }

    // MARK: - Cancellation

    @Test("A new search cancels the one in progress and its late result is never shown")
    func newSearchCancelsPrevious() async throws {
        let useCase = SearchArtworksUseCaseMock()
        let sut = makeSUT(useCase: useCase)

        sut.updateSearchText("monet")
        let firstSearch = try #require(sut.searchTask)
        try await useCase.waitForPendingRequest("monet")

        sut.updateSearchText("van gogh")
        let secondSearch = try #require(sut.searchTask)
        try await useCase.waitForPendingRequest("van gogh")
        #expect(firstSearch.isCancelled)

        await useCase.complete("van gogh", with: .success([vanGogh]))
        await secondSearch.value
        #expect(sut.state == .loaded(rows([vanGogh])))

        await useCase.complete("monet", with: .success([monet]))
        await firstSearch.value
        #expect(sut.state == .loaded(rows([vanGogh])))
    }

    @Test("A cancelled search finishing first (even with an error) doesn't replace the state of the new one")
    func cancelledSearchFinishingFirst() async throws {
        let useCase = SearchArtworksUseCaseMock()
        let sut = makeSUT(useCase: useCase)

        sut.updateSearchText("monet")
        let firstSearch = try #require(sut.searchTask)
        try await useCase.waitForPendingRequest("monet")
        sut.updateSearchText("van gogh")
        let secondSearch = try #require(sut.searchTask)
        try await useCase.waitForPendingRequest("van gogh")

        await useCase.complete("monet", with: .failure(DomainError.noConnection))
        await firstSearch.value
        #expect(sut.state == .loading)

        await useCase.complete("van gogh", with: .success([vanGogh]))
        await secondSearch.value
        #expect(sut.state == .loaded(rows([vanGogh])))
    }

    @Test("Clearing the text cancels the search in progress and goes back to idle")
    func clearingTextCancels() async throws {
        let useCase = SearchArtworksUseCaseMock()
        let sut = makeSUT(useCase: useCase)
        sut.updateSearchText("monet")
        let search = try #require(sut.searchTask)
        try await useCase.waitForPendingRequest("monet")

        sut.updateSearchText("")

        #expect(search.isCancelled)
        #expect(sut.state == .idle)

        await useCase.complete("monet", with: .success([monet]))
        await search.value
        #expect(sut.state == .idle)
    }

    @Test("Typing quickly only triggers one search thanks to the debounce")
    func debounce() async {
        let useCase = SearchArtworksUseCaseMock(result: .success([monet]))
        let sut = makeSUT(useCase: useCase, debounce: .milliseconds(100))

        sut.updateSearchText("mo")
        sut.updateSearchText("mon")
        sut.updateSearchText("monet")
        await sut.searchTask?.value

        #expect(await useCase.receivedQueries == ["monet"])
        #expect(sut.state == .loaded(rows([monet])))
    }

    // MARK: - Navigation

    @Test("Selecting a row asks the coordinator to show the detail of its artwork")
    func selectionNavigatesToDetail() async {
        let coordinator = SearchCoordinatorSpy()
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .success([monet, vanGogh])), coordinator: coordinator)
        sut.updateSearchText("monet")
        await sut.searchTask?.value

        sut.didSelect(ArtworkRowUIModel(domainModel: vanGogh))

        #expect(coordinator.shownArtworks == [vanGogh])
    }

    @Test("Selecting a row that isn't in the current results does nothing")
    func selectionOfUnknownRow() async {
        let coordinator = SearchCoordinatorSpy()
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .success([monet])), coordinator: coordinator)
        sut.updateSearchText("monet")
        await sut.searchTask?.value

        sut.didSelect(ArtworkRowUIModel(domainModel: vanGogh))

        #expect(coordinator.shownArtworks.isEmpty)
    }

    @Test("Doesn't retain its coordinator (no retain cycle)")
    func doesNotRetainCoordinator() {
        var coordinator: SearchCoordinatorSpy? = SearchCoordinatorSpy()
        let sut = makeSUT(coordinator: coordinator)
        weak let weakCoordinator = coordinator

        coordinator = nil

        withExtendedLifetime(sut) {
            #expect(weakCoordinator == nil)
        }
    }

    // MARK: - Accessibility

    @Test("Announces the number of results to VoiceOver")
    func announcesResults() async {
        let sut = makeSUT(useCase: SearchArtworksUseCaseMock(result: .success([monet, vanGogh])))

        sut.updateSearchText("monet")
        #expect(sut.accessibilityAnnouncement == nil)
        await sut.searchTask?.value

        #expect(sut.accessibilityAnnouncement == "search_results_announcement".localized(with: 2))
    }

    // MARK: - Helpers

    private func rows(_ artworks: [ArtworkDomainModel]) -> [ArtworkRowUIModel] {
        artworks.map {
            .init(domainModel: $0)
        }
    }

    private func makeSUT(useCase: SearchArtworksUseCaseMock = SearchArtworksUseCaseMock(result: .success([])),
                         coordinator: SearchCoordinatorProtocol? = nil,
                         debounce: Duration = .zero) -> SearchViewModel {
        .init(searchArtworksUseCase: useCase, coordinator: coordinator, debounce: debounce)
    }
}
