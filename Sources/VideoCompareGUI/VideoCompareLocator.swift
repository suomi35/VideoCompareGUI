import Foundation

/// Locates the video-compare executable installed via Homebrew (or elsewhere)
/// and queries its version.
enum VideoCompareLocator {

    static let wellKnownPaths = [
        "/opt/homebrew/bin/video-compare",   // Homebrew on Apple Silicon
        "/usr/local/bin/video-compare",      // Homebrew on Intel
        "/opt/local/bin/video-compare",      // MacPorts
    ]

    /// Pure, testable path resolution: given a list of candidate paths and an
    /// optional PATH environment string, returns the first existing executable.
    static func locate(candidates: [String], pathEnv: String?, fileExists: (String) -> Bool) -> URL? {
        for path in candidates where fileExists(path) {
            return URL(fileURLWithPath: path)
        }
        if let path = pathEnv {
            for dir in path.split(separator: ":") {
                let candidate = "\(dir)/video-compare"
                if fileExists(candidate) {
                    return URL(fileURLWithPath: candidate)
                }
            }
        }
        return nil
    }

    /// Returns the video-compare executable URL, or nil if not found.
    static func locate() -> URL? {
        let fm = FileManager.default
        return locate(candidates: wellKnownPaths, pathEnv: ProcessInfo.processInfo.environment["PATH"]) { fm.isExecutableFile(atPath: $0) }
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
