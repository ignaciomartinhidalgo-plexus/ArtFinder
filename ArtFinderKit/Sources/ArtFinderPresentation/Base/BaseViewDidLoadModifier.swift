//
//  BaseViewDidLoadModifier.swift
//  ArtFinderKit
//

import SwiftUI

struct BaseViewDidLoadModifier: ViewModifier {

    // MARK: - Properties

    @State private var didLoad = false
    private let action: (() -> Void)?

    // MARK: - Initializer

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    // MARK: - Functions

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didLoad {
                    didLoad = true
                    action?()
                }
            }
    }
}
