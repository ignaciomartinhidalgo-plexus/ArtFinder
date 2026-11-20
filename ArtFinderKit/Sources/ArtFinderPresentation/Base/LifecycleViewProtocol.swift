//
//  LifecycleViewProtocol.swift
//  ArtFinderKit
//

import Foundation

@MainActor
public protocol LifecycleViewProtocol: AnyObject {
    var isLoaded: Bool { get set }
    func onLoad()
    func onAppear()
    func onDisappear()
}

public extension LifecycleViewProtocol {
    func onLoad() {}
    func onAppear() {}
    func onDisappear() {}
}
