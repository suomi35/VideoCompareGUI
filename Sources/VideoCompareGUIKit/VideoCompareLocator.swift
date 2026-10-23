import Foundation

/// Locates the video-compare executable installed via Homebrew (or elsewhere)
/// and queries its version.
enum VideoCompareLocator {

    static let wellKnownPaths = [
        "/opt/homebrew/bin/video-compare",   // Homebrew on Apple Silicon
        "/usr/local/bin/video-compare",      // Homebrew on Intel
        "/opt/local/bin/video-compare",      // MacPorts
    ]

    /// Returns the video-compare executable URL, or nil if not found.
    static func locate() -> URL? {
        let fm = FileManager.default
        for path in wellKnownPaths where fm.isExecutableFile(atPath: path) {
            return URL(fileURLWithPath: path)
        }
        // Fall back to a PATH scan (covers custom Homebrew prefixes, etc.)
        if let path = ProcessInfo.processInfo.environment["PATH"] {
            for dir in path.split(separator: ":") {
                let candidate = "\(dir)/video-compare"
                if fm.isExecutableFile(atPath: candidate) {
                    return URL(fileURLWithPath: candidate)
                }
            }
        }
        return nil
    }

    /// Runs `video-compare --version` and returns the trimmed output, or nil.
    static func version(of executable: URL) -> String? {
        let process = Process()
        process.executableURL = executable
        process.arguments = ["--version"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        do {
            try process.run()
        } catch {
            return nil
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else { return nil }
        return String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
