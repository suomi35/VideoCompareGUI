// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VideoCompareGUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        // Thin executable host: @main entry point, app delegate, and headless
        // test hooks. All UI and application core logic lives in the library.
        .executableTarget(
            name: "VideoCompareGUI",
            dependencies: [
                "VideoCompareGUIKit"
            ],
            path: "Sources/VideoCompareGUI",
            resources: [.process("../../Resources/Assets.xcassets")],
            swiftSettings: [.unsafeFlags(["-Xcc", "-DENABLE_DEBUG_DYLIB=Yes"])]
        ),
        // Library holding all SwiftUI views plus the application core they
        // drive (AppModel, Settings, Launcher, CommandLineBuilder, SelfTest…).
        // Library targets get ENABLE_DEBUG_DYLIB in Debug, so Xcode Previews
        // work without touching build settings.
        .target(
            name: "VideoCompareGUIKit",
            path: "Sources/VideoCompareGUIKit",
            resources: [.process("Resources")],
            swiftSettings: [.unsafeFlags(["-Xcc", "-DENABLE_DEBUG_DYLIB=Yes"])]
        ),
        // Headless test runner that exercises SelfTest without launching the GUI.
        .executableTarget(
            name: "VideoCompareGUIKitTestRunner",
            dependencies: [
                "VideoCompareGUIKit"
            ],
            path: "Sources/VideoCompareGUIKitTestRunner"
        )
    ]
)
