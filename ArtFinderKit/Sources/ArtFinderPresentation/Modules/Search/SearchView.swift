//
//  SearchView.swift
//  ArtFinderKit
//

import SwiftUI

public struct SearchView: View {

    // MARK: - Properties

    private let viewModel: SearchViewModel
    @State private var searchText: String

    // MARK: - Initializer

    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self._searchText = State(initialValue: viewModel.searchText)
    }

    // MARK: - Body

    public var body: some View {
        content
            .navigationTitle(Text(verbatim: "ArtFinder"))
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: Text("search_prompt".localized))
            .onChange(of: searchText) {
                viewModel.updateSearchText(searchText)
            }
            .onChange(of: viewModel.state) {
                announceStateChange()
            }
            .baseView(viewModel)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView {
                Label {
                    Text("search_idle_title".localized)
                } icon: {
                    Image(systemName: "paintpalette")
                }
            } description: {
                Text("search_idle_description".localized)
            }
        case .loading:
            ProgressView {
                Text("search_loading".localized)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let artworks):
            resultsList(artworks)
        case .empty:
            ContentUnavailableView.search(text: viewModel.searchText)
        case .failure(let error):
            ContentUnavailableView {
                Label(error.title, systemImage: error.systemImage)
            } description: {
                Text(error.message)
            } actions: {
                Button {
                    viewModel.retrySearch()
                } label: {
                    Text("common_try_again".localized)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier(AccessibilityIdentifier.searchRetryButton)
            }
        }
    }

    private func resultsList(_ artworks: [ArtworkRowUIModel]) -> some View {
        List(artworks) { artwork in
            Button {
                viewModel.didSelect(artwork)
            } label: {
                ArtworkRowView(artwork: artwork)
            }
            .accessibilityLabel(artwork.accessibilityLabel)
            .accessibilityHint("search_row_hint".localized)
            .accessibilityIdentifier(AccessibilityIdentifier.searchRow(artwork.id))
        }
        .listStyle(.plain)
        .accessibilityIdentifier(AccessibilityIdentifier.searchList)
    }

    // MARK: - Private functions

    private func announceStateChange() {
        guard let announcement = viewModel.accessibilityAnnouncement else { return }
        AccessibilityNotification.Announcement(announcement).post()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        SearchView(viewModel: .preview)
    }
}
#endif
