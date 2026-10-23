import SwiftUI
import UniformTypeIdentifiers

/// A drop target / picker well for one of the two input videos.
struct FileWellView: View {
    @EnvironmentObject private var model: AppModel
    let side: AppModel.Side

    private var path: String? {
        switch side {
        case .left: return model.leftFile
        case .right: return model.rightFile
        }
    }

    private var title: LocalizedStringKey {
        if model.settings.mode == "vstack" {
            return side == .left ? Strings.Picker.topVideo : Strings.Picker.bottomVideo
        }
        return side == .left ? Strings.Picker.leftVideo : Strings.Picker.rightVideo
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                if path != nil {
                    Button {
                        switch side {
                        case .left: model.leftFile = nil
                        case .right: model.rightFile = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Clear")
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: path == nil ? [6] : [])
                    )
                    .foregroundStyle(path == nil ? Color.secondary.opacity(0.6) : Color.accentColor.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(path == nil ? Color.clear : Color.accentColor.opacity(0.06))
                    )
                if let path {
                    VStack(spacing: 4) {
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text(URL(fileURLWithPath: path).lastPathComponent)
                            .font(.callout.weight(.medium))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Text(URL(fileURLWithPath: path).deletingLastPathComponent().path)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.head)
                    }
                    .padding(8)
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text(Strings.Placeholder.dropVideoHere)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 100)
            .contentShape(Rectangle())
            .onTapGesture {
                model.pickFile(for: side)
            }
            .dropDestination(for: URL.self) { urls, _ in
                guard let url = urls.first(where: \.isFileURL) else { return false }
                model.setFile(url.path, for: side)
                return true
            }
            .help(Strings.Placeholder.clickToChoose)
        }
    }
}

@MainActor
struct FileWellViewEmptyPreview: PreviewProvider {
    static var previews: some View {
        FileWellView(side: .left)
            .environmentObject(AppModel())
            .frame(width: 340, height: 140)
    }
}

@MainActor
struct FileWellViewLoadedPreview: PreviewProvider {
    static var previews: some View {
        let model = AppModel()
        model.leftFile = "/Users/me/Movies/Source clip 1.mp4"
        return FileWellView(side: .left)
            .environmentObject(model)
            .frame(width: 340, height: 140)
    }
}

/// Small form row with a fixed-width leading label and an end-aligned control
/// area, for use inside grouped Form sections. Every row uses the same 180 pt
/// label column so labels and controls line up across all tabs.
struct FieldRow<Content: View>: View {
    let label: LocalizedStringKey
    let help: LocalizedStringKey
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .frame(width: 180, alignment: .leading)
                .lineLimit(1)
                .help(help)
            Spacer(minLength: 12)
            content
        }
    }
}
