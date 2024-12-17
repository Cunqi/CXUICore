// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CXUICore",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CXUICore",
            targets: ["CXUICore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Cunqi/CXFoundation.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CXUICore",
            dependencies: [
                .product(name: "CXFoundation", package: "CXFoundation"),
            ]
        ),
        .testTarget(
            name: "CXUICoreTests",
            dependencies: ["CXUICore"]
        ),
    ]
)
