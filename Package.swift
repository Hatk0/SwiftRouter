// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftRouter",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftRouter",
            targets: ["SwiftRouter"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftRouter",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftRouterTests",
            dependencies: ["SwiftRouter"]
        ),
    ]
)
