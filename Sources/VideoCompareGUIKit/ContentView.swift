import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// AppKit-level initial-focus interceptor: attaches during view-hierarchy
/// construction (before the window orders key), parks first responder on
/// itself — a focusable view that renders nothing — so AppKit's autofocus
/// never reaches the first TextField. Yields on any user click/Tab.
/// Observes a notification exactly once, then removes itself. A reference
/// type so the closure captures it immutably (avoids the Swift 6
/// "mutated after capture by sendable closure" warning on one-shot tokens).
/// The closure captures `self` strongly, which keeps the observer alive
/// until the first notification; removal then releases it. Only ever
/// created on the main thread with a `.main` queue, hence @unchecked Sendable.
private final class OneShotObserver: @unchecked Sendable {
    private var token: NSObjectProtocol?

    func observe(
        name: NSNotification.Name,
        object: AnyObject?,
        on queue: OperationQueue?,
        _ handler: @escaping (Notification) -> Void
    ) {
        token = NotificationCenter.default.addObserver(
            forName: name,
            object: object,
            queue: queue
        ) { note in
            self.cancel()
            handler(note)
        }
    }

    func cancel() {
        if let token { NotificationCenter.default.removeObserver(token) }
        token = nil
    }
}

private final class SilentFocusAnchor: NSView {
    /// One-shot for the whole app run: park focus at launch, then immediately
    /// hand it to the window itself (an invisible responder). Keeping the
    /// anchor out of the responder chain for user interactions is what stops
    /// the double focus-ring flash on first click.
    private static var parked = false

    override var acceptsFirstResponder: Bool { true }
    override var focusRingMaskBounds: NSRect { .zero }
    override func drawFocusRingMask() {}

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard !Self.parked, let window else { return }
        Self.parked = true
        window.initialFirstResponder = self
        if window.firstResponder !== self, window.firstResponder != nil {
            window.makeFirstResponder(self)
        }
        // Once the window has become key (AppKit applied initialFirstResponder),
        // park on the window itself: no view-level resign/become handshake on
        // subsequent clicks, no visible focus ring.
        let observer = OneShotObserver()
        observer.observe(name: NSWindow.didBecomeKeyNotification, object: window, on: .main) { note in
            if let win = note.object as? NSWindow {
                win.makeFirstResponder(win)
            }
        }
    }
}

private struct InitialFocusAnchor: NSViewRepresentable {
    func makeNSView(context: Context) -> SilentFocusAnchor { SilentFocusAnchor() }
    func updateNSView(_ nsView: SilentFocusAnchor, context: Context) {}
}

public struct ContentView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showCopiedToast = false

    public init() {}

    /// Live command preview — always computed from current state so it can
    /// never go stale (covers Recents, swap, clear, drops, settings edits).
    private var commandText: String { model.previewCommand() }

    public var body: some View {
        VStack(spacing: 0) {
            // AppKit-level anchor: parks first responder before window orders key.
            InitialFocusAnchor()
                .frame(width: 0, height: 0)
            header
            Divider()
            HStack(alignment: .center, spacing: 12) {
                FileWellView(side: .left)
                Button {
                    model.swapSides()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                }
                .help(Strings.Help.helpSwapLeftRight)
                .disabled(model.leftFile == nil && model.rightFile == nil)
                FileWellView(side: .right)
            }
            .padding(12)
            Divider()
            optionsTabs
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Divider()
            footer
        }
        .sheet(isPresented: $model.showHomebrewSheet) {
            VStack(spacing: 16) {
                Text(Strings.Alert.videoCompareNotFoundTitle)
                    .font(.headline)
                    .foregroundColor(.red)
                Text(Strings.Alert.videoCompareNotFoundMessageInstall)
                HStack {
                    Text(Strings.Alert.videoCompareNotFoundMessageInstallHomebrew)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    Button {
                        NSPasteboard.general.clearContents()
                        // The install command should not be localized
                        NSPasteboard.general.setString("brew install video-compare", forType: .string)
                        showCopiedToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopiedToast = false
                        }
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.borderless)
                    .help(Strings.Help.copyToClipboard)
                }
                if showCopiedToast {
                    Text(Strings.Alert.textCopiedToClipboard)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                Text(Strings.Alert.clickRescan)
                Button(Strings.Button.ok) {
                    model.showHomebrewSheet = false
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(24)
            .frame(minWidth: 320)
        }
        .alert(item: Binding(
            get: { model.alert },
            set: { model.alert = $0 }
        )) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text(Strings.Button.ok))
            )
        }

    }

    // MARK: Header (executable status)

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: model.isExecutableMissing ? "xmark.octagon.fill" : "checkmark.circle.fill")
                .foregroundStyle(model.isExecutableMissing ? .red : .green)
            Text(model.executablePathLabel)
                .font(.callout)
                .lineLimit(1)
                .truncationMode(.middle)
                .help(model.executablePathLabel)
            Spacer()
            Button {
                model.refreshExecutable()
            } label: {
                Label(Strings.Button.rescan, systemImage: "arrow.clockwise")
            }
            .help(Strings.Help.helpRescan)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: Options tabs

    private var optionsTabs: some View {
        TabView {
            GeneralTabView().tabItem { Label(Strings.Tab.general, systemImage: "slider.horizontal.3") }
            DisplayTabView().tabItem { Label(Strings.Tab.display, systemImage: "macbook") }
            ColorToneTabView().tabItem { Label(Strings.Tab.colorTone, systemImage: "paintpalette") }
            FiltersTabView().tabItem { Label(Strings.Tab.filters, systemImage: "line.3.horizontal.decrease.circle") }
            ScopesTabView().tabItem { Label(Strings.Tab.scopes, systemImage: "waveform") }
        }
        .formStyle(.grouped)
        .padding(.top, 4)
    }

    // MARK: Footer (command preview + launch)

    private var footer: some View {
        VStack(spacing: 8) {
            HStack {
                Text(Strings.Label.commandPreview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if !model.lastRunOutput.isEmpty {
                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(model.lastRunOutput, forType: .string)
                    } label: {
                        Label(Strings.Button.copyOutput, systemImage: "doc.on.doc")
                    }
                    .font(.caption)
                    .help(Strings.Help.helpCopyOutput)
                }
            }
            ScrollView(.horizontal) {
                Text(commandText.isEmpty ? String(localized: "placeholder.selectVideos") : commandText)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(commandText.isEmpty ? .secondary : .primary)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 20)
            HStack {
                if model.recentPairs.isEmpty {
                    Text(Strings.Tip.dragVideos)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Menu {
                        ForEach(model.recentPairs) { pair in
                            Button("\(URL(fileURLWithPath: pair.left).lastPathComponent) ↔ \(URL(fileURLWithPath: pair.right).lastPathComponent)") {
                                model.applyRecent(pair)
                            }
                        }
                        Divider()
                        Button(Strings.Button.clearRecents, role: .destructive) {
                            model.recentPairs = []
                        }
                    } label: {
                        Label(Strings.Label.recents, systemImage: "clock")
                    }
                    .padding(.leading, 8)
                }
                Spacer()
                if model.isLaunching {
                    Button {
                        model.stop()
                    } label: {
                        Label(Strings.Button.stop, systemImage: "stop.circle")
                    }
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                }
                Button {
                    model.launch()
                } label: {
                    Label(Strings.Button.launchButton, systemImage: "play.fill")
                        .frame(minWidth: 90)
                }
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(!model.canLaunch)
                .buttonStyle(.borderedProminent)
                .padding(.trailing, 8)
            }
        }
        .padding(12)
    }
}

@MainActor
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
            .frame(width: 950, height: 750)
    }
}
