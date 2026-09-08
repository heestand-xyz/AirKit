// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AirKit",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "AirKit",
            targets: ["AirKit"]),
    ],
    targets: [
        .target(
            name: "AirKit",
            dependencies: []),
    ]
)
