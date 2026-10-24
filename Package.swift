// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Awake",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Awake", targets: ["Awake"])
    ],
    targets: [
        .executableTarget(
            name: "Awake",
            path: "Sources/Awake"
        )
    ]
)
