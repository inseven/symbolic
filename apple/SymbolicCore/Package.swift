// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SymbolicCore",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "SymbolicCore",
            targets: ["SymbolicCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", .upToNextMajor(from: "2.7.1")),
        .package(url: "https://github.com/inseven/glitter.git", .upToNextMajor(from: "0.1.2")),
        .package(url: "https://github.com/swhitty/SwiftDraw.git", .upToNextMajor(from: "0.9.6")),
    ],
    targets: [
        .target(
            name: "SymbolicCore",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "Glitter", package: "glitter"),
                .product(name: "SwiftDraw", package: "SwiftDraw"),
            ],
            resources: [
                .copy("Resources/material-icons"),
                .copy("Resources/sf-symbols"),
                .copy("Resources/Template.symbolic"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
    ]
)
