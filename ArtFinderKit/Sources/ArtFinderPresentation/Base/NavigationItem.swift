//
//  NavigationItem.swift
//  ArtFinderKit
//

import Foundation

public struct NavigationItem<Object> {

    // MARK: - Properties

    public private(set) var viewModel: Object?
    private var onDismissAction: (() -> Void)?
    public var isActive: Bool = false {
        didSet {
            if !isActive {
                viewModel = nil
                onDismissAction?()
                onDismissAction = nil
            }
        }
    }

    // MARK: - Initializer

    public init(viewModel: Object? = nil,
                isActive: Bool = false) {
        self.viewModel = viewModel
        self.isActive = isActive
        self.onDismissAction = nil
    }

    // MARK: - Functions

    public mutating func navigate(to viewModel: Object, onDismissAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onDismissAction = onDismissAction
        self.isActive = true
    }

    public mutating func dismiss() {
        self.isActive = false
    }
}
