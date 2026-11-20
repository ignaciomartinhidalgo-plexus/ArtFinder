//
//  ArtworkRowUIModelTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderPresentation

@Suite("ArtworkRowUIModel")
struct ArtworkRowUIModelTests {

    @Test("Maps the artwork into what the row shows")
    func mapsArtwork() {
        let sut = ArtworkRowUIModel(domainModel: .create(id: 7))

        #expect(sut.id == 7)
        #expect(sut.title == "Water Lilies")
        #expect(sut.date == "1906")
        #expect(sut.thumbnailURL == ArtworkImageDomainModel.create()?.thumbnailURL)
    }

    @Test("The artist name is the first line of the API's artist text")
    func artistName() {
        #expect(ArtworkRowUIModel(domainModel: .create()).artistName == "Claude Monet")
        #expect(ArtworkRowUIModel(domainModel: .create(artist: nil)).artistName == nil)
    }

    @Test("The VoiceOver label joins title, artist and date")
    func accessibilityLabel() {
        #expect(ArtworkRowUIModel(domainModel: .create()).accessibilityLabel == "Water Lilies, Claude Monet, 1906")
        #expect(ArtworkRowUIModel(domainModel: .create(artist: nil, date: nil)).accessibilityLabel == "Water Lilies")
    }
}
