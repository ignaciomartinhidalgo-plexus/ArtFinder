//
//  URLSessionRepositoryTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderData

extension URLProtocolStubTests {

    @Suite("URLSessionRepository")
    struct URLSessionRepositoryTests {

        // MARK: - Properties

        private let query: SearchQueryRequestDomainModel

        // MARK: - Initializer

        init() throws {
            URLProtocolStub.reset()
            query = try #require(SearchQueryRequestDomainModel("Monet"))
        }

        // MARK: - Request

        @Test("Calls the search endpoint with query, limit, fields and the AIC-User-Agent header")
        func buildsSearchRequest() async throws {
            URLProtocolStub.respond(body: ArtworkSearchJSON.twoArtworks)

            _ = try await makeSUT().searchArtworks(request: query)

            let request = try #require(URLProtocolStub.requests.first)
            let url = try #require(request.url)
            let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
            let queryItems = components.queryItems ?? []

            #expect(request.httpMethod == "GET")
            #expect(components.host == "api.artic.edu")
            #expect(components.path == "/api/v1/artworks/search")
            #expect(queryItems.first { $0.name == "q" }?.value == "monet")
            #expect(queryItems.first { $0.name == "limit" }?.value == "20")
            #expect(queryItems.first { $0.name == "fields" }?.value == ArtworkDataModel.requestedFields)
            #expect(request.value(forHTTPHeaderField: AICHeader.name) == AICHeader.value)
        }

        @Test("Maps the API response into domain models")
        func mapsResponse() async throws {
            URLProtocolStub.respond(body: ArtworkSearchJSON.twoArtworks)

            let artworks = try await makeSUT().searchArtworks(request: query)

            #expect(artworks.map(\.id) == [16568, 1])
            #expect(artworks.first?.title == "Water Lilies")
        }

        // MARK: - Cache

        @Test("Returns the cached result without a network call while it's valid")
        func cacheHit() async throws {
            URLProtocolStub.respond(body: ArtworkSearchJSON.twoArtworks)
            let sut = makeSUT()

            let first = try await sut.searchArtworks(request: query)
            let second = try await sut.searchArtworks(request: query)

            #expect(second == first)
            #expect(URLProtocolStub.requests.count == 1)
        }

        @Test("Failures are not cached")
        func failuresAreNotCached() async throws {
            URLProtocolStub.respond(statusCode: 500)
            let sut = makeSUT()
            await #expect(throws: DomainError.self) {
                try await sut.searchArtworks(request: query)
            }

            URLProtocolStub.respond(body: ArtworkSearchJSON.twoArtworks)
            let artworks = try await sut.searchArtworks(request: query)

            #expect(artworks.count == 2)
            #expect(URLProtocolStub.requests.count == 2)
        }

        // MARK: - Errors

        @Test("Maps HTTP status codes to domain errors", arguments: [
            (429, DomainError.rateLimited),
            (500, DomainError.server(statusCode: 500)),
            (408, DomainError.noConnection)
        ])
        func mapsStatusCodes(statusCode: Int, expectedError: DomainError) async {
            URLProtocolStub.respond(statusCode: statusCode)

            await #expect(throws: expectedError) {
                try await makeSUT().searchArtworks(request: query)
            }
        }

        @Test("Maps connectivity errors to noConnection", arguments: [
            URLError.Code.notConnectedToInternet,
            .networkConnectionLost,
            .cannotFindHost,
            .timedOut
        ])
        func mapsConnectivityErrors(code: URLError.Code) async {
            URLProtocolStub.fail(with: URLError(code))

            await #expect(throws: DomainError.noConnection) {
                try await makeSUT().searchArtworks(request: query)
            }
        }

        @Test("Maps an undecodable response to invalidResponse", arguments: [
            ArtworkSearchJSON.invalid,
            ArtworkSearchJSON.wrongType
        ])
        func mapsDecodingErrors(body: Data) async {
            URLProtocolStub.respond(body: body)

            await #expect(throws: DomainError.invalidResponse) {
                try await makeSUT().searchArtworks(request: query)
            }
        }

        @Test("Turns a cancelled URLSession task into CancellationError instead of a domain error")
        func mapsCancellation() async {
            URLProtocolStub.fail(with: URLError(.cancelled))

            await #expect(throws: CancellationError.self) {
                try await makeSUT().searchArtworks(request: query)
            }
        }

        // MARK: - Helpers

        private func makeSUT() -> URLSessionRepository {
            .init(session: URLProtocolStub.makeSession(),
                  cache: .init(timeToLive: URLSessionRepository.cacheTimeToLive))
        }
    }
}
