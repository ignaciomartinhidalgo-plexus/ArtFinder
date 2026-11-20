//
//  InMemoryCache.swift
//  ArtFinderKit
//

import Foundation

public actor InMemoryCache<Key: Hashable & Sendable, Value: Sendable> {

    // MARK: - Entry

    private struct Entry {
        let value: Value
        let expirationDate: Date
    }

    // MARK: - Properties

    private let timeToLive: TimeInterval
    private let now: @Sendable () -> Date
    private var entries: [Key: Entry] = [:]

    // MARK: - Initializer

    public init(timeToLive: TimeInterval, now: @escaping @Sendable () -> Date = { Date() }) {
        self.timeToLive = timeToLive
        self.now = now
    }

    // MARK: - Functions

    public func value(for key: Key) -> Value? {
        guard let entry = entries[key] else { return nil }
        guard now() < entry.expirationDate else {
            entries[key] = nil
            return nil
        }
        return entry.value
    }

    public func insert(_ value: Value, for key: Key) {
        removeExpiredEntries()
        entries[key] = Entry(value: value, expirationDate: now().addingTimeInterval(timeToLive))
    }

    public func removeAll() {
        entries.removeAll()
    }

    // MARK: - Private functions

    private func removeExpiredEntries() {
        let currentDate = now()
        entries = entries.filter {
            currentDate < $0.value.expirationDate
        }
    }
}
