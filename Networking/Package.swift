// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    dependencies: [
            .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [.product(name: "Core", package: "Core")]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking", .product(name: "Core", package: "Core")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
