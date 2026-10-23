import AppKit
import Foundation
import SwiftUI

struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

/// Central observable state: settings, selected files, executable discovery,
/// persistence and process lifecycle.
@MainActor
public final class AppModel: ObservableObject {

    public static let maxRecents = 12

    @Published public var settings: Settings {
        didSet { saveSettings() }
    }
    @Published public var leftFile: String? {
        didSet { savePaths() }
    }
    @Published public var rightFile: String? {
        didSet { savePaths() }
    }
    @Published public var recentPairs: [RecentPair] {
        didSet { saveRecents() }
    }

    @Published private(set) var executableURL: URL?
    @Published private(set) var executableVersion: String?
    @Published var isLaunching = false
    @Published var lastCommandPreview: String = ""
    @Published var lastRunOutput: String = ""
    @Published var alert: AlertMessage?

    private let launcher = Launcher()
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        settings = Self.loadSettings(from: defaults)
        leftFile = defaults.string(forKey: "leftFile")
        rightFile = defaults.string(forKey: "rightFile")
        recentPairs = Self.loadRecents(from: defaults)
        refreshExecutable()
    }

    // MARK: Executable discovery

    var executablePathLabel: String {
        guard let executableURL else {
            return String(localized: "alert.videoCompareNotFound.message")
        }
        let version = executableVersion.map { " · \($0)" } ?? ""
        return "\(executableURL.path)\(version)"
    }

    var isExecutableMissing: Bool { executableURL == nil }

    func refreshExecutable() {
        executableURL = VideoCompareLocator.locate()
        if let url = executableURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let version = VideoCompareLocator.version(of: url)
                DispatchQueue.main.async {
                    self?.executableVersion = version
                }
            }
        } else {
            executableVersion = nil
        }
    }

    // MARK: Files

    public var canLaunch: Bool {
        executableURL != nil
            && !isLaunching
            && leftFile != nil
            && rightFile != nil
            && leftFile != rightFile
    }

    public func pickFile(for side: Side) {
        let panel = NSOpenPanel()
        panel.title = side == .left ? "Choose Left Video" : "Choose Right Video"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        if panel.runModal() == .OK, let url = panel.url {
            setFile(url.path, for: side)
        }
    }

    public func setFile(_ path: String, for side: Side) {
        switch side {
        case .left: leftFile = path
        case .right: rightFile = path
        }
    }

    /// Assigns dropped/opened files: first goes left, second right.
    public func assignDroppedFiles(_ paths: [String]) {
        guard !paths.isEmpty else { return }
        setFile(paths[0], for: .left)
        if paths.count > 1 {
            setFile(paths[1], for: .right)
        }
    }

    public func swapSides() {
        swap(&leftFile, &rightFile)
    }

    public func clearFiles() {
        leftFile = nil
        rightFile = nil
    }

    public func applyRecent(_ pair: RecentPair) {
        leftFile = pair.left
        rightFile = pair.right
    }

    func removeRecent(_ pair: RecentPair) {
        recentPairs.removeAll { $0.id == pair.id }
    }

    private func addRecent(left: String, right: String) {
        let pair = RecentPair(left: left, right: right)
        recentPairs.removeAll { $0.left == left && $0.right == right }
        recentPairs.insert(pair, at: 0)
        if recentPairs.count > Self.maxRecents {
            recentPairs.removeLast(recentPairs.count - Self.maxRecents)
        }
    }

    // MARK: Launching

    func previewCommand() -> String {
        guard let left = leftFile, let right = rightFile else { return "" }
        let args = CommandLineBuilder.buildArguments(settings: settings, leftFile: left, rightFile: right)
        let exe = executableURL?.path ?? "video-compare"
        return CommandQuoter.quote([exe] + args)
    }

    public func launch() {
        guard let executable = executableURL else {
            alert = AlertMessage(
                title: String(localized: "alert.videoCompareNotFound.title"),
                message: String(localized: "alert.videoCompareNotFound.message")
            )
            return
        }
        guard let left = leftFile, let right = rightFile else {
            alert = AlertMessage(
            title: String(localized: "alert.selectTwoVideos.title"),
            message: String(localized: "alert.selectTwoVideos.message")
        )
            return
        }
        guard left != right else {
            alert = AlertMessage(
            title: String(localized: "alert.sameFile.title"),
            message: String(localized: "alert.sameFile.message")
        )
            return
        }
        guard FileManager.default.fileExists(atPath: left), FileManager.default.fileExists(atPath: right) else {
            alert = AlertMessage(
            title: String(localized: "alert.fileNotFound.title"),
            message: String(localized: "alert.fileNotFound.message")
        )
            return
        }

        let args = CommandLineBuilder.buildArguments(settings: settings, leftFile: left, rightFile: right)
        lastCommandPreview = CommandQuoter.quote([executable.path] + args)

        let launched = launcher.launch(
            executable: executable,
            arguments: args,
            onTermination: { [weak self] result in
                guard let self else { return }
                self.isLaunching = false
                if !result.output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.lastRunOutput = result.output
                }
                if result.exitCode != 0 {
                    self.alert = AlertMessage(
                        title: "\(String(localized: "alert.exitCode.title")) \(result.exitCode)",
                        message: result.output.isEmpty ? String(localized: "alert.exitCode.message.noOutput") : result.output
                    )
                }
            },
            onFailure: { [weak self] message in
                self?.alert = AlertMessage(
                    title: String(localized: "alert.launchFailed.title"),
                    message: message
                )
            }
        )
        if launched {
            isLaunching = true
            addRecent(left: left, right: right)
        }
    }

    func stop() {
        launcher.stop()
    }

    // MARK: Persistence

    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: "settings")
        }
    }

    private func savePaths() {
        defaults.set(leftFile, forKey: "leftFile")
        defaults.set(rightFile, forKey: "rightFile")
    }

    private func saveRecents() {
        if let data = try? JSONEncoder().encode(recentPairs) {
            defaults.set(data, forKey: "recentPairs")
        }
    }

    private static func loadSettings(from defaults: UserDefaults) -> Settings {
        guard let data = defaults.data(forKey: "settings"),
              let settings = try? JSONDecoder().decode(Settings.self, from: data)
        else {
            return Settings()
        }
        return settings
    }

    private static func loadRecents(from defaults: UserDefaults) -> [RecentPair] {
        guard let data = defaults.data(forKey: "recentPairs"),
              let recents = try? JSONDecoder().decode([RecentPair].self, from: data)
        else {
            return []
        }
        return recents
    }

    public enum Side {
        case left, right
    }
}