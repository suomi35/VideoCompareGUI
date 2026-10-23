import SwiftUI

/// Modal "About" panel opened from the app menu.
public struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private let appName: String
    private let version: String
    private let build: String

    public init() {
        let info = Bundle.main.infoDictionary ?? [:]
        self.appName = info["CFBundleName"] as? String ?? "Video Compare"
        self.version = info["CFBundleShortVersionString"] as? String ?? "1.0.0"
        self.build = info["CFBundleVersion"] as? String ?? "1"
    }

    public var body: some View {
        VStack(spacing: 16) {
            // App icon, falling back to a placeholder if the bundle icon
            // isn't loaded yet.
            Group {
                if let icon = NSApp.applicationIconImage {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "videocamera.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.secondary)
                }
            }

            Text(appName)
                .font(.title2.weight(.semibold))
            Text("Version \(version) (build \(build))")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            Text("""
            A native macOS GUI for the Video-Compare Tool.

            Compares two video files side-by-side (or stacked) using
            pixop/video-compare.
            """)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text("License")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text("GPLv2 — same terms as pixop/video-compare")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()
                    .frame(maxWidth: .infinity)

                Text("Credits")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text("GUI modeled after TetzkatLipHoka/VideoCompareGUI (Windows).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Button("OK") { dismiss() }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(width: 460, height: 380)
    }
}

@MainActor
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
