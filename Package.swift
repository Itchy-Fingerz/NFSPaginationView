// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PaginationView",
    platforms: [
        .iOS(.v14),  // Ensure it targets iOS only
    ],
    products: [
        .library(
            name: "PaginationView",
            targets: ["PaginationView"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PaginationView",
            dependencies: [],
            path: "Sources/PaginationView"
        ),
    ]
)
