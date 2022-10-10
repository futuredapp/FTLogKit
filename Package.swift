// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "FTLogKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
//        .watchOS(.v6),
//        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "FTLogKit",
            targets: ["FTLogKit"]),
    ],
    targets: [
        .target(
            name: "FTLogKit",
            dependencies: []),
        .testTarget(
            name: "FTLogKitTests",
            dependencies: ["FTLogKit"]),
    ]
)
