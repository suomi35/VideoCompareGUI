import AppKit
import Foundation

struct LaunchResult {
    let exitCode: Int32
    let output: String
}

/// Spawns the video-compare child process, captures its combined output and
/// notifies on the main actor when it terminates.
@MainActor
final class Launcher {
    private(set) var isRunning = false
    private var process: Process?
    private var outputPipe: Pipe?
    nonisolated(unsafe) private var outputData = Data()

    /// Launches video-compare detached; returns false if a run is already active
    /// or the process could not be started (the error message is returned via
    /// `onFailure`).
    func launch(
        executable: URL,
        arguments: [String],
        onTermination: @escaping (LaunchResult) -> Void,
        onFailure: @escaping (String) -> Void
    ) -> Bool {
        guard !isRunning else { return false }

        let process = Process()
        process.executableURL = executable
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        // Detach from our run loop so a chatty or long-lived child cannot block.
        process.standardInput = FileHandle.nullDevice

        outputData = Data()
        outputPipe = pipe

        // Drain the pipe on a background thread to avoid pipe-buffer deadlocks.
        let handle = pipe.fileHandleForReading
        DispatchQueue.global(qos: .utility).async { [weak self] in
            while true {
                let chunk = handle.availableData
                if chunk.isEmpty { break }
                DispatchQueue.main.async {
                    self?.outputData.append(chunk)
                }
            }
        }

        process.terminationHandler = { [weak self] proc in
            let captured = self?.outputData ?? Data()
            let result = LaunchResult(
                exitCode: proc.terminationStatus,
                output: String(data: captured, encoding: .utf8) ?? ""
            )
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.process = nil
                self?.outputPipe = nil
                onTermination(result)
            }
        }

        do {
            try process.run()
        } catch {
            onFailure("Could not start \(executable.path):\n\(error.localizedDescription)")
            return false
        }

        self.process = process
        isRunning = true
        return true
    }

    /// Sends SIGTERM to the running video-compare process, if any.
    func stop() {
        guard let process, process.isRunning else { return }
        process.terminate()
    }
}