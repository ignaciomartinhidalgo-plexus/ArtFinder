//
//  URLSessionImageRepositoryTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderData

extension URLProtocolStubTests {

    @Suite("URLSessionImageRepository")
    struct URLSessionImageRepositoryTests {

        // MARK: - Properties

        private let url: URL
        private let imageData = Data([0xFF, 0xD8, 0xFF, 0xE0])

        // MARK: - Initializer

        init() throws {
            URLProtocolStub.reset()
            url = try #require(URL(string: "https://www.artic.edu/iiif/2/b0fa4234-a3a4-8db1-60e6-55b6fb046fac/full/200,/0/default.jpg"))
        }

        // MARK: - Tests

        @Test("Downloads the image sending the AIC-User-Agent header the image server requires")
        func downloadsWithHeader() async throws {
            URLProtocolStub.respond(body: imageData)

            let data = try await makeSUT().loadImageData(from: url)

            let request = try #require(URLProtocolStub.requests.first)
            #expect(data == imageData)
            #expect(request.url == url)
            #expect(request.value(forHTTPHeaderField: AICHeader.name) == AICHeader.value)
        }

        @Test("Returns a cached image without a new request")
        func cacheHit() async throws {
            URLProtocolStub.respond(body: imageData)
            let sut = makeSUT()

            _ = try await sut.loadImageData(from: url)
            let cachedData = try await sut.loadImageData(from: url)

            #expect(cachedData == imageData)
            #expect(URLProtocolStub.requests.count == 1)
        }

        @Test("Maps a rejected request to a domain error")
        func mapsStatusCode() async {
            URLProtocolStub.respond(statusCode: 404)

            await #expect(throws: DomainError.server(statusCode: 404)) {
                try await makeSUT().loadImageData(from: url)
            }
        }

        @Test("Turns a cancelled download into CancellationError")
        func mapsCancellation() async {
            URLProtocolStub.fail(with: URLError(.cancelled))

            await #expect(throws: CancellationError.self) {
                try await makeSUT().loadImageData(from: url)
            }
        }

        // MARK: - Helpers

        private func makeSUT() -> URLSessionImageRepository {
            URLSessionImageRepository(session: URLProtocolStub.makeSession(),
                                      cache: InMemoryCache(timeToLive: URLSessionImageRepository.cacheTimeToLive))
        }
    }
}
