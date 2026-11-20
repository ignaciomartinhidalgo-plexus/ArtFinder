//
//  UseCaseProtocol.swift
//  ArtFinderKit
//

import Foundation

// MARK: - Protocol

public protocol UseCaseProtocol<Input, Output>: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func execute(_ input: Input) async throws -> Output
}

// MARK: - Void Input Convenience

public extension UseCaseProtocol where Input == Void {

    func execute() async throws -> Output {
        try await execute(())
    }
}
