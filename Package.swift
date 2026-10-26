// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VideoCompareGUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "VideoCompareGUI",
            path: "Sources/VideoCompareGUI",
            resources: [.process("Resources"), .process("../../Resources/Assets.xcassets")],
            swiftSettings: [.unsafeFlags(["-Xcc", "-DENABLE_DEBUG_DYLIB=Yes"])]
        )
    ]
)
