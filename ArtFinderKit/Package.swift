// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArtFinderKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ArtFinderDomain", targets: ["ArtFinderDomain"]),
        .library(name: "ArtFinderData", targets: ["ArtFinderData"]),
        .library(name: "ArtFinderPresentation", targets: ["ArtFinderPresentation"]),
    ],
    targets: [
        .target(name: "ArtFinderDomain"),
        .target(name: "ArtFinderData", dependencies: ["ArtFinderDomain"]),
        .target(name: "ArtFinderPresentation", dependencies: ["ArtFinderDomain"]),
        .testTarget(name: "ArtFinderDomainTests", dependencies: ["ArtFinderDomain"]),
        .testTarget(name: "ArtFinderDataTests", dependencies: ["ArtFinderData", "ArtFinderDomain"]),
        .testTarget(name: "ArtFinderPresentationTests", dependencies: ["ArtFinderPresentation", "ArtFinderDomain"]),
    ],
    swiftLanguageModes: [.v6]
)
