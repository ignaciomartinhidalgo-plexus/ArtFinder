//
//  BaseView.swift
//  ArtFinderKit
//

import SwiftUI

struct BaseView: ViewModifier {

    // MARK: - Properties

    let viewModel: LifecycleViewProtocol

    // MARK: - Functions

    func body(content: Content) -> some View {
        content
            .onLoad {
                guard !viewModel.isLoaded else { return }
                viewModel.isLoaded = true
                viewModel.onLoad()
            }
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}
