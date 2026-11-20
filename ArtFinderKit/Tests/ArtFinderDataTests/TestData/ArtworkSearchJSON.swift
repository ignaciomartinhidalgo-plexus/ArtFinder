//
//  ArtworkSearchJSON.swift
//  ArtFinderKit
//

import Foundation

enum ArtworkSearchJSON {

    static let twoArtworks = Data("""
    {
      "preference": null,
      "pagination": { "total": 2, "limit": 20, "offset": 0, "total_pages": 1, "current_page": 1 },
      "data": [
        {
          "_score": 120.5,
          "id": 16568,
          "title": "Water Lilies",
          "artist_display": "Claude Monet\\nFrench, 1840-1926",
          "date_display": "1906",
          "medium_display": "Oil on canvas",
          "dimensions": "89.9 × 94.1 cm (35 3/8 × 37 1/16 in.)",
          "place_of_origin": "France",
          "credit_line": "Mr. and Mrs. Martin A. Ryerson Collection",
          "image_id": "3c27b499-af56-f0d5-93b5-a7f2f1ad5813",
          "thumbnail": {
            "lqip": "data:image/gif;base64,R0lGODlhAQABAAAAACw=",
            "width": 3000,
            "height": 2000,
            "alt_text": "Painting of a pond seen up close spotted with thickly painted pink and white water lilies."
          }
        },
        {
          "_score": 98.1,
          "id": 1,
          "title": "",
          "artist_display": null,
          "date_display": null,
          "medium_display": null,
          "dimensions": null,
          "place_of_origin": null,
          "credit_line": null,
          "image_id": null,
          "thumbnail": null
        }
      ],
      "info": { "license_text": "CC0", "version": "1.13" },
      "config": { "iiif_url": "https://www.artic.edu/iiif/2", "website_url": "http://www.artic.edu" }
    }
    """.utf8)

    static let empty = Data("""
    { "data": [], "config": { "iiif_url": "https://www.artic.edu/iiif/2" } }
    """.utf8)

    static let invalid = Data("<html><body>Service temporarily unavailable</body></html>".utf8)

    static let wrongType = Data(#"{ "data": { "id": 1 } }"#.utf8)

    static let withMissingID = Data("""
    {
      "data": [ { "id": 1, "title": "Kept" }, { "title": "No id" } ],
      "config": { "iiif_url": "https://www.artic.edu/iiif/2" }
    }
    """.utf8)

    static let withoutConfig = Data(#"{ "data": [ { "id": 7, "title": "Untitled", "image_id": "abc" } ] }"#.utf8)
}
