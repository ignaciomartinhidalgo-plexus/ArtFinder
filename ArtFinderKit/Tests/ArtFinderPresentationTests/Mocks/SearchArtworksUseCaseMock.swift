//
//  SearchArtworksUseCaseMock.swift
//  ArtFinderKit
//

import Foundation
import ArtFinderDomain

actor SearchArtworksUseCaseMock: UseCaseProtocol {

    // MARK: - TimeoutError

    struct TimeoutError: Error {}

    // MARK: - Properties

    private var result: Result<[ArtworkDomainModel], Error>?
    private var pendingRequests: [String: CheckedContinuation<[ArtworkDomainModel], Error>] = [:]
    private(set) var receivedQueries: [String] = []

    // MARK: - Initializer

    init(result: Result<[ArtworkDomainModel], Error>? = nil) {
        self.result = result
    }

    // MARK: - UseCaseProtocol

    func execute(_ input: SearchQueryRequestDomainModel) async throws -> [ArtworkDomainModel] {
        receivedQueries.append(input.value)
        if let result {
            return try result.get()
        }
        return try await withCheckedThrowingContinuation { continuation in
            pendingRequests[input.value] = continuation
        }
    }

    // MARK: - Functions

    func setResult(_ result: Result<[ArtworkDomainModel], Error>?) {
        self.result = result
    }

    func waitForPendingRequest(_ query: String, timeout: Duration = .seconds(2)) async throws {
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: timeout)
        while pendingRequests[query] == nil {
            guard clock.now < deadline else {
                throw TimeoutError()
            }
            try await Task.sleep(for: .milliseconds(1))
        }
    }

    func complete(_ query: String, with result: Result<[ArtworkDomainModel], Error>) {
        pendingRequests.removeValue(forKey: query)?.resume(with: result)
    }
}
