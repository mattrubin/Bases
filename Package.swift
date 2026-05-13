// SPDX-FileCopyrightText: © 2016-2026 Matt Rubin and the Bases authors
// SPDX-License-Identifier: MIT
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Bases",
    products: [
        .library(name: "Base16", targets: ["Base16"]),
        .library(name: "Base32", targets: ["Base32"]),
    ],
    targets: [
        .target(name: "Base16"),
        .target(name: "Base32"),
        .testTarget(name: "Base16Tests", dependencies: ["Base16"]),
        .testTarget(name: "Base32Tests", dependencies: ["Base32"]),
    ]
)
