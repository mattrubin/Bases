// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Bases",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .watchOS(.v4),
    ],
    products: [
        .library(name: "Base16", targets: ["Base16"]),
        .library(name: "Base32", targets: ["Base32"]),
        .executable(name: "PerformanceTests", targets: ["PerformanceTests"]),
    ],
    targets: [
        .target(name: "Base16"),
        .target(name: "Base32"),
        .testTarget(name: "Base16Tests", dependencies: ["Base16"]),
        .testTarget(name: "Base32Tests", dependencies: ["Base32"]),
        .executableTarget(name: "PerformanceTests", dependencies: ["Base32"]),
    ],
)
