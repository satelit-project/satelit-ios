// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Net",
    products: [
        .library(name: "Net", targets: ["Net", "NetMocks"]),
    ],
    dependencies: [
        .package(path: "Proto"),
    ],
    targets: [
        .target(name: "Net", dependencies: ["Proto"]),
        .target(name: "NetMocks", dependencies: ["Net"]),
        .testTarget(name: "NetTests", dependencies: ["Net"]),
    ]
)
