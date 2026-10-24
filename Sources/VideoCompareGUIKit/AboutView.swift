import SwiftUI

/// Modal "About" panel opened from the app menu.
public struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private let appName: String
    private let version: String
    private let build: String

    public init() {
        let info = Bundle.main.infoDictionary ?? [:]
        self.appName = info["CFBundleName"] as! String
        self.version = info["CFBundleShortVersionString"] as! String
        self.build = info["CFBundleVersion"] as! String
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

            HStack(alignment: .top, spacing: 4) {
                Text(Strings.About.descriptionPrefix)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Link(Strings.About.videoCompareTool, destination: URL(string: "https://github.com/pixop/video-compare")!)
                    .font(.subheadline)
                    .underline()

                Text(Strings.About.descriptionSuffix)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)

            Spacer(minLength: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(Strings.About.licenseTitle)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(Strings.About.licenseText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()
                    .frame(maxWidth: .infinity)

                Text(Strings.About.creditsTitle)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(Strings.About.creditsText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Button(Strings.Button.ok) { dismiss() }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(width: 460, height: 400)
    }
}

@MainActor
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
