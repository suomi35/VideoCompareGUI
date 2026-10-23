import SwiftUI
import VideoCompareGUIKit

@main
struct VideoCompareGUIEntry: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var model = AppModel()
    @State private var showAbout = false

    init() {
        // Hidden headless test hooks (see TestHooks.swift).
        if TestHooks.handleIfNeeded() { exit(0) }
    }

    var body: some Scene {
        WindowGroup(Strings.Label.windowTitle) {
            ContentView()
                .environmentObject(model)
                .background(AppLinker(model: model))
                .frame(minWidth: 780, minHeight: 640)
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
        }
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(Strings.Button.chooseLeft) { model.pickFile(for: .left) }
                    .keyboardShortcut("1", modifiers: [.command, .shift])
                Button(Strings.Button.chooseRight) { model.pickFile(for: .right) }
                    .keyboardShortcut("2", modifiers: [.command, .shift])
                Divider()
                Button(Strings.Button.swapSides) { model.swapSides() }
                    .keyboardShortcut("x", modifiers: [.command, .shift])
                Button(Strings.Button.clearFiles) { model.clearFiles() }
                    .keyboardShortcut("k", modifiers: [.command, .shift])
            }
            CommandGroup(replacing: .appInfo) {
                Button("About \(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Video Compare")…") {
                    showAbout = true
                }
            }

            CommandGroup(after: .appInfo) {
                Divider()
                Button(Strings.Button.launchComparison) { model.launch() }
                    .keyboardShortcut(.return, modifiers: [.command])
                    .disabled(!model.canLaunch)
            }
        }
    }
}
