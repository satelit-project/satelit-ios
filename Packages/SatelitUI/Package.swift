// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SatelitUI",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SatelitUI",
            targets: ["SatelitUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(name: "SatelitUI"),
    ]
)
