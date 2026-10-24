// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ClamAwake",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "ClamAwake", targets: ["ClamAwake"])
    ],
    targets: [
        .executableTarget(
            name: "ClamAwake",
            path: "Sources/ClamAwake"
        )
    ]
)
