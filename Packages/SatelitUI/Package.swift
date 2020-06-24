// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SatelitUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SatelitUI",
            targets: ["SatelitUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SatelitUI",
            dependencies: []
        ),
    ]
)
