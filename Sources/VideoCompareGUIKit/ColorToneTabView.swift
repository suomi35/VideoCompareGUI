import SwiftUI

// MARK: - Color & Tone

struct ColorToneTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section {
                Text(Strings.Text.colorValues)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section(Strings.Section.colorimetry) {
                FieldRow(label: Strings.Field.colorSpace, help: Strings.Help.colorSpace) {
                    TextField("e.g. bt709, bt2020nc:", text: $model.settings.colorSpace)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.colorRange, help: Strings.Help.colorRange) {
                    TextField("e.g. tv, pc:tv", text: $model.settings.colorRange)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.colorPrimaries, help: Strings.Help.colorPrimaries) {
                    TextField("e.g. bt709, bt2020:bt709", text: $model.settings.colorPrimaries)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.colorTRC, help: Strings.Help.colorTRC) {
                    TextField("e.g. bt709, smpte2084:", text: $model.settings.colorTRC)
                        .textFieldStyle(.roundedBorder)
                }
            }
            Section(Strings.Section.toneMapping) {
                FieldRow(label: Strings.Field.toneMapMode, help: Strings.Help.toneMapMode) {
                    Picker("", selection: $model.settings.toneMapMode) {
                        Text(Strings.Picker.auto).tag("auto")
                        Text(Strings.Picker.off).tag("off")
                        Text(Strings.Picker.on).tag("on")
                        Text(Strings.Picker.relative).tag("rel")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
                FieldRow(label: Strings.Field.leftPeakNits, help: Strings.Help.leftPeakNits) {
                    TextField("e.g. 1000", text: $model.settings.leftPeakNits)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.rightPeakNits, help: Strings.Help.rightPeakNits) {
                    TextField("e.g. 1000", text: $model.settings.rightPeakNits)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.boostTone, help: Strings.Help.boostTone) {
                    TextField("e.g. 0.6, 2:1.5", text: $model.settings.boostTone)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

@MainActor
struct ColorToneTabView_Previews: PreviewProvider {
    static var previews: some View {
        ColorToneTabView()
            .environmentObject(AppModel())
            .frame(width: 600, height: 600)
            .formStyle(.grouped)
    }
}

/// A "both sides" text field plus optional per-side overrides; mirrors the
/// --filter / --decoder / --demuxer / --hwaccel argument family.
struct SideTripleField: View {
    let title: LocalizedStringKey
    let placeholder: String
    let helpBoth: LocalizedStringKey
    let helpLeft: LocalizedStringKey
    let helpRight: LocalizedStringKey
    @Binding var both: String
    @Binding var left: String
    @Binding var right: String

    @State private var usePerSide = false

    var body: some View {
        Section(title) {
            if usePerSide {
                FieldRow(label: Strings.Picker.left, help: helpLeft) {
                    TextField(placeholder, text: $left)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Picker.right, help: helpRight) {
                    TextField(placeholder, text: $right)
                        .textFieldStyle(.roundedBorder)
                }
            } else {
                FieldRow(label: Strings.Picker.bothSides, help: helpBoth) {
                    TextField(placeholder, text: $both)
                        .textFieldStyle(.roundedBorder)
                }
            }
            Toggle(Strings.Toggle.differentPerSide, isOn: $usePerSide)
                .toggleStyle(.checkbox)
                .onChange(of: usePerSide) { perSide in
                    if perSide && both.trimmed.isEmpty == false {
                        left = both
                        right = both
                    } else if !perSide && (left.trimmed.isEmpty == false || right.trimmed.isEmpty == false) {
                        both = left.trimmed.isEmpty ? right : left
                        left = ""
                        right = ""
                    }
                }
        }
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}