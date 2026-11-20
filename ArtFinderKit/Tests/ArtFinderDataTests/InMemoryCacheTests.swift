//
//  InMemoryCacheTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
@testable import ArtFinderData

@Suite("InMemoryCache")
struct InMemoryCacheTests {

    // MARK: - Properties

    private let clock = MutableClock()
    private let timeToLive: TimeInterval = 300

    // MARK: - Tests

    @Test("Returns nil for a key that was never stored")
    func missingKey() async {
        let sut = makeSUT()

        #expect(await sut.value(for: "monet") == nil)
    }

    @Test("Returns the stored value while it's within its time to live")
    func validEntry() async {
        let sut = makeSUT()
        await sut.insert(1, for: "monet")

        clock.advance(by: timeToLive - 1)

        #expect(await sut.value(for: "monet") == 1)
    }

    @Test("Returns nil once the time to live has elapsed")
    func expiredEntry() async {
        let sut = makeSUT()
        await sut.insert(1, for: "monet")

        clock.advance(by: timeToLive)

        #expect(await sut.value(for: "monet") == nil)
    }

    @Test("Inserting again replaces the value and restarts its time to live")
    func overwriteRestartsTimeToLive() async {
        let sut = makeSUT()
        await sut.insert(1, for: "monet")
        clock.advance(by: timeToLive - 10)

        await sut.insert(2, for: "monet")
        clock.advance(by: timeToLive - 10)

        #expect(await sut.value(for: "monet") == 2)
    }

    @Test("Entries are independent per key")
    func independentKeys() async {
        let sut = makeSUT()
        await sut.insert(1, for: "monet")
        clock.advance(by: timeToLive - 10)
        await sut.insert(2, for: "van gogh")

        clock.advance(by: 10)

        #expect(await sut.value(for: "monet") == nil)
        #expect(await sut.value(for: "van gogh") == 2)
    }

    @Test("removeAll empties the cache")
    func removeAll() async {
        let sut = makeSUT()
        await sut.insert(1, for: "monet")

        await sut.removeAll()

        #expect(await sut.value(for: "monet") == nil)
    }

    // MARK: - Helpers

    private func makeSUT() -> InMemoryCache<String, Int> {
        .init(timeToLive: timeToLive, now: { [clock] in
            clock.now
        })
    }
}
