//
//  AppCoordinatorView.swift
//  ArtFinder
//

import SwiftUI
import ArtFinderPresentation

struct AppCoordinatorView: View {

    // MARK: - Properties

    @Bindable var coordinator: AppCoordinator

    // MARK: - Body

    var body: some View {
        NavigationStack {
            SearchView(viewModel: coordinator.searchViewModel)
                .navigationDestination(isPresented: $coordinator.artworkDetail.isActive) {
                    artworkDetailView
                }
        }
        .environment(\.imageLoader, DependencyInjector.getImageLoader())
    }

    // MARK: - Private

    @ViewBuilder
    private var artworkDetailView: some View {
        if let viewModel = coordinator.artworkDetail.viewModel {
            ArtworkDetailView(viewModel: viewModel)
        }
    }
}
