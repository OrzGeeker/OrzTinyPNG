// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzTinyPNG",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "tiny", targets: [
            "OrzTinyPNG"
        ]),
        .library(name: "libTinyPNG", targets: [
            "libTinyPNG"
        ])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.7"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "OrzTinyPNG",
            dependencies: [
                .product(name: "ConsoleKit", package: "console-kit"),
                .target(name: "libTinyPNG")
            ]),
        .target(name: "libTinyPNG"),
        .testTarget(
            name: "libTinyPNGTests",
            dependencies: ["libTinyPNG"])
    ]
)
