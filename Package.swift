// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftLearningAPI",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "SwiftLearningAPI", targets: ["SwiftLearningAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-rc.3.1"),
        .package(url: "https://github.com/nmdias/FeedKit.git", from: "9.1.2"),
    ],
    targets: [
        .target(name: "SwiftLearningAPI", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Vapor", package: "vapor"),
        ]),
        .target(name: "Run", dependencies: ["SwiftLearningAPI"]),
        .testTarget(name: "SwiftLearningAPITests", dependencies: ["SwiftLearningAPI"]),
    ]
)

