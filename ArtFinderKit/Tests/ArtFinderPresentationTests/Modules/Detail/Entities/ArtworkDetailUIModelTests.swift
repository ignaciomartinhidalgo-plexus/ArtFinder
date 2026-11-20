//
//  ArtworkDetailUIModelTests.swift
//  ArtFinderKit
//

import Foundation
import Testing
import ArtFinderDomain
@testable import ArtFinderPresentation

@Suite("ArtworkDetailUIModel")
struct ArtworkDetailUIModelTests {

    @Test("Shows the title")
    func title() {
        let sut = ArtworkDetailUIModel(domainModel: .create(title: "Water Lilies"))

        #expect(sut.title == "Water Lilies")
    }

    @Test("Shows Untitled when the title is blank", arguments: ["", "   "])
    func untitled(rawTitle: String) {
        let sut = ArtworkDetailUIModel(domainModel: .create(title: rawTitle))

        #expect(sut.title == "artwork_untitled".localized)
    }

    @Test("Lists every field with a value, in display order")
    func allFields() {
        let sut = ArtworkDetailUIModel(domainModel: .create())

        #expect(sut.fields.map(\.title) == [
            "detail_field_artist".localized,
            "detail_field_date".localized,
            "detail_field_medium".localized,
            "detail_field_dimensions".localized,
            "detail_field_place_of_origin".localized,
            "detail_field_credit_line".localized
        ])
        #expect(sut.fields.first?.value == "Claude Monet\nFrench, 1840-1926")
    }

    @Test("Skips missing or blank fields")
    func skipsEmptyFields() {
        let sut = ArtworkDetailUIModel(domainModel: .create(date: nil, medium: "  ", dimensions: nil, creditLine: nil))

        #expect(sut.fields.map(\.title) == ["detail_field_artist".localized, "detail_field_place_of_origin".localized])
    }

    @Test("Uses the full size image and its aspect ratio")
    func image() throws {
        let image = try #require(ArtworkDetailUIModel(domainModel: .create(image: .create(aspectRatio: 1.5))).image)

        #expect(image.url == ArtworkImageDomainModel.create()?.fullSizeURL)
        #expect(image.aspectRatio == 1.5)
    }

    @Test("Has no image when the artwork doesn't")
    func noImage() {
        #expect(ArtworkDetailUIModel(domainModel: .create(image: nil)).image == nil)
    }

    @Test("Uses the museum's alt text as the image's accessibility label")
    func imageAccessibilityLabelFromAltText() {
        let sut = ArtworkDetailUIModel(domainModel: .create(image: .create(altText: "A pond with water lilies.")))

        #expect(sut.image?.accessibilityLabel == "A pond with water lilies.")
    }

    @Test("Falls back to a generic label when the image has no alt text", arguments: [nil, "  "] as [String?])
    func imageAccessibilityLabelFallback(altText: String?) {
        let sut = ArtworkDetailUIModel(domainModel: .create(image: .create(altText: altText)))

        #expect(sut.image?.accessibilityLabel == "detail_image_fallback_label".localized(with: "Water Lilies"))
    }
}
