//
//  SearchQueryTests.swift
//  ArtFinderKit
//

import Testing
@testable import ArtFinderDomain

@Suite("SearchQuery")
struct SearchQueryTests {

    @Test("Normalizes whitespace and casing", arguments: [
        ("Monet", "monet"),
        ("  Claude   Monet  ", "claude monet"),
        ("VAN\tGOGH\n", "van gogh"),
        ("ab", "ab")
    ])
    func normalizesInput(raw: String, expected: String) throws {
        let query = try #require(SearchQueryRequestDomainModel(raw))

        #expect(query.value == expected)
    }

    @Test("Rejects empty or too short input", arguments: ["", "   ", "\n\t", "a", "  b  "])
    func rejectsShortInput(raw: String) {
        #expect(SearchQueryRequestDomainModel(raw) == nil)
    }

    @Test("Queries that only differ in casing or spacing are equal")
    func equivalentQueriesAreEqual() {
        #expect(SearchQueryRequestDomainModel("Claude Monet ") == SearchQueryRequestDomainModel("  claude   MONET"))
    }
}
