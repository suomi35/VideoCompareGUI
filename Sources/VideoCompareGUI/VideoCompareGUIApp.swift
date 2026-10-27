import AppKit
import SwiftUI

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public weak var model: AppModel?

    public func applicationWillFinishLaunching(_ notification: Notification) {
        // macOS 26 (Tahoe) extends Security Code AutoFill to all apps via
        // NSAutoFillHeuristicController, which injects an invisible child
        // window over text fields. That window steals key status, making the
        // focused field's ring blink twice. Disabling the controller here —
        // the same opt-out Chrome, Electron and Ghostty ship — fixes it
        // without swizzling. The documented Info.plist key
        // NSAutoFillRequiresTextContentTypeForOneTimeCodeOnMac is also set
        // (see Resources/Info.plist) for the one-time-code half of the
        // feature.
        UserDefaults.standard.set(false, forKey: "NSAutoFillHeuristicControllerEnabled")
    }

    /// Handles files dropped onto the app icon in the Dock or Finder.
    public func application(_ application: NSApplication, open urls: [URL]) {
        let paths = urls.filter(\.isFileURL).map(\.path)
        guard !paths.isEmpty else { return }
        Task { @MainActor in
            model?.assignDroppedFiles(paths)
        }
    }
}

/// Invisible view that hands the model to the AppDelegate once the model exists.
public struct AppLinker: View {
    let model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        Color.clear
            .onAppear {
                if let delegate = NSApplication.shared.delegate as? AppDelegate {
                    delegate.model = model
                }
            }
    }
}