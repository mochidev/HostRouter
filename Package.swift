// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HostRouter",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "HostRouter",
            targets: ["HostRouter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.91.1"),
    ],
    targets: [
        .target(
            name: "HostRouter",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "HostRouterTests",
            dependencies: [
                .target(name: "HostRouter"),
                .product(name: "XCTVapor", package: "vapor"),
                // Workaround for https://github.com/apple/swift-package-manager/issues/6940
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)
