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
        .package(url: "https://github.com/sparkle-project/Sparkle", .upToNextMajor(from: "2.10.0")),
        .package(url: "https://github.com/inseven/glitter.git", .upToNextMajor(from: "0.1.2")),
        .package(url: "https://github.com/swhitty/SwiftDraw.git", .upToNextMajor(from: "0.29.0")),
        .package(url: "https://github.com/inseven/diligence.git", from: "2.0.1"),
        .package(url: "https://github.com/inseven/interact.git", from: "3.10.5"),
    ],
    targets: [
        .target(
            name: "SymbolicCore",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "Glitter", package: "glitter"),
                .product(name: "SwiftDraw", package: "SwiftDraw"),
                .product(name: "Diligence", package: "diligence"),
                .product(name: "Interact", package: "interact"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
    ]
)
