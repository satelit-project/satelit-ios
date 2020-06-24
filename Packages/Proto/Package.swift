// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Proto",
    products: [
        .library(
            name: "Proto",
            targets: ["Proto"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.12")
    ],
    targets: [
        .target(
            name: "Proto",
            dependencies: [.product(name: "GRPC", package: "grpc-swift")]),
        .testTarget(
            name: "ProtoTests",
            dependencies: ["Proto"]),
    ]
)
