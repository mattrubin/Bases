// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Bases",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(name: "Base16", targets: ["Base16"]),
        .library(name: "Base32", targets: ["Base32"]),
    ],
    targets: [
        .target(name: "Base16"),
        .target(name: "Base32"),
        .testTarget(name: "Base16Tests", dependencies: ["Base16"]),
        .testTarget(name: "Base32Tests", dependencies: ["Base32"]),
    ],
    swiftLanguageVersions: [.v5]
)
