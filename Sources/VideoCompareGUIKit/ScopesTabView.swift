import SwiftUI

// MARK: - Scopes

struct ScopesTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section {
                Text(Strings.Text.scopes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section(Strings.Picker.histogram) {
                Toggle(Strings.Toggle.histogramWindow, isOn: $model.settings.histogramWindow).help(Strings.Help.helpToggleHistogramWindow)
                if model.settings.histogramWindow {
                    FieldRow(label: Strings.Field.filterOptions, help: Strings.Help.histogramOptions) {
                        TextField("e.g. display_mode=parade:level_height=256", text: $model.settings.histogramOptions)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            Section(Strings.Picker.vectorscope) {
                Toggle(Strings.Toggle.vectorscopeWindow, isOn: $model.settings.vectorscopeWindow).help(Strings.Help.helpToggleVectorscopeWindow)
                if model.settings.vectorscopeWindow {
                    FieldRow(label: Strings.Field.filterOptions, help: Strings.Help.vectorscopeOptions) {
                        TextField("e.g. mode=color4:graticule=green", text: $model.settings.vectorscopeOptions)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            Section(Strings.Picker.waveform) {
                Toggle(Strings.Toggle.waveformWindow, isOn: $model.settings.waveformWindow).help(Strings.Help.helpToggleWaveformWindow)
                if model.settings.waveformWindow {
                    FieldRow(label: Strings.Field.filterOptions, help: Strings.Help.waveformOptions) {
                        TextField("e.g. graticule=orange:display=stack", text: $model.settings.waveformOptions)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            Section(Strings.Section.scopeWindows) {
                Toggle(Strings.Field.scopeSize, isOn: $model.settings.scopeSizeEnabled).help(Strings.Help.helpToggleScopeSize)
                    .toggleStyle(.checkbox)
                if model.settings.scopeSizeEnabled {
                    FieldRow(label: Strings.Field.widthHeightScope, help: Strings.Help.scopeSize) {
                        TextField("1024", text: $model.settings.scopeWidth)
                            .frame(width: 90)
                            .textFieldStyle(.roundedBorder)
                        Text("×")
                            .foregroundStyle(.secondary)
                        TextField("256", text: $model.settings.scopeHeight)
                            .frame(width: 90)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                FieldRow(label: Strings.Field.scopeColorMode, help: Strings.Help.scopeColorMode) {
                    TextField("e.g. rgb,luma", text: $model.settings.scopeColorMode)
                        .textFieldStyle(.roundedBorder)
                }
                Toggle(Strings.Toggle.scopeNotop, isOn: $model.settings.scopeNotop).help(Strings.Help.helpToggleScopeNotop)
                    .toggleStyle(.checkbox)
            }
        }
    }
}

@MainActor
struct ScopesTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScopesTabView()
            .environmentObject(AppModel())
            .frame(width: 700, height: 600)
            .formStyle(.grouped)
    }
}