// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AirKit",
    platforms: [
        .iOS(.v13)
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
