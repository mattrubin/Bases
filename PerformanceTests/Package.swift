// SPDX-FileCopyrightText: © 2026 Matt Rubin and the Bases authors
// SPDX-License-Identifier: MIT
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PerformanceTests",
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(name: "PerformanceTests", dependencies: [.product(name: "Base32", package: "Bases")])
    ]
)
