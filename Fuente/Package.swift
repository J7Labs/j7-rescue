// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "J7Rescue",
    platforms: [.macOS("26.0")],
    targets: [
        .executableTarget(
            name: "J7Rescue",
            path: "Sources/J7Rescue",
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)
