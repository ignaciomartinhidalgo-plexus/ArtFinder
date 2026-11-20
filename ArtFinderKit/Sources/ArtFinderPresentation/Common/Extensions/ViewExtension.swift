//
//  View+Extensions.swift
//  ArtFinderKit
//

import SwiftUI

public extension View {

    func baseView(_ viewModel: LifecycleViewProtocol) -> some View {
        modifier(BaseView(viewModel: viewModel))
    }

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(BaseViewDidLoadModifier(perform: action))
    }
}
