//
//  ArtFinderApp.swift
//  ArtFinder
//

import SwiftUI

@main
struct ArtFinderApp: App {

    // MARK: - Properties

    @State private var coordinator = DependencyInjector.getAppCoordinator()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
