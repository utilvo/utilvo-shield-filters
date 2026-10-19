// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "UtilvoShieldFilters",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "UtilvoShieldFilters",
            targets: ["UtilvoShieldFilters"]
        ),
    ],
    targets: [
        .target(
            name: "UtilvoShieldFilters",
            dependencies: [],
            path: "Sources/UtilvoShieldFilters"
        ),
    ]
)
