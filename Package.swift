// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileCache",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FileCache",
            targets: ["FileCache"]),
    ],
    targets: [
        .target(
            name: "FileCache"),
        .testTarget(
            name: "FileCacheTests",
            dependencies: ["FileCache"]),
    ]
)
