// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SymbolicCore",
    products: [
        .library(
            name: "SymbolicCore",
            targets: ["SymbolicCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/inseven/glitter.git", .upToNextMajor(from: "0.1.1"))
    ],
    targets: [
        .target(
            name: "SymbolicCore",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "Glitter", package: "glitter"),
            ]
        ),

    ]
)
