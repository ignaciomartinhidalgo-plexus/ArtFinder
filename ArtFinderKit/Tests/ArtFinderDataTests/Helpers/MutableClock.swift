//
//  MutableClock.swift
//  ArtFinderKit
//

import Foundation

final class MutableClock: @unchecked Sendable {

    // MARK: - Properties

    private let lock = NSLock()
    private var currentDate: Date

    var now: Date {
        lock.withLock {
            currentDate
        }
    }

    // MARK: - Initializer

    init(_ date: Date = Date(timeIntervalSince1970: 0)) {
        self.currentDate = date
    }

    // MARK: - Functions

    func advance(by seconds: TimeInterval) {
        lock.withLock {
            currentDate += seconds
        }
    }
}
