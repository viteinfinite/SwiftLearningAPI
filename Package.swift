// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftLearningAPI",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftLearningCommon", targets: ["SwiftLearningCommon"]),
        .library(name: "SwiftLearningIndexer", targets: ["SwiftLearningIndexer"]),
        .library(name: "SwiftLearningAPI", targets: ["SwiftLearningAPI"]),
        .executable(name: "RunIndexer", targets: ["RunIndexer"]),
        .executable(name: "RunAPI", targets: ["RunAPI"]),
        .executable(name: "RunContentSourceMerger", targets: ["RunContentSourceMerger"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.10.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.0.1"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/nmdias/FeedKit.git", from: "9.1.2"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.0.0-rc.3"),
        .package(url: "https://github.com/vapor/queues.git", from: "1.0.0-rc.3"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.1.0")
    ],
    targets: [
        .target(name: "SwiftLearningCommon", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Vapor", package: "vapor"),
        ]),
        .target(name: "SwiftLearningIndexer", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "QueuesRedisDriver", package: "queues-redis-driver"),
            "SwiftLearningCommon",
            "FeedKit"
        ]),
        .target(name: "SwiftLearningAPI", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Vapor", package: "vapor"),
            "SwiftLearningCommon"
        ]),
        .target(name: "RunIndexer", dependencies: ["SwiftLearningIndexer"]),
        .target(name: "RunAPI", dependencies: ["SwiftLearningAPI"]),
        .testTarget(name: "SwiftLearningIndexerTests", dependencies: [
            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "XCTFluent", package: "fluent-kit"),
            .product(name: "XCTQueues", package: "queues"),
            "SwiftLearningIndexer"
        ]),
        .target(name: "RunContentSourceMerger", dependencies: ["Files"]),
    ]
)

