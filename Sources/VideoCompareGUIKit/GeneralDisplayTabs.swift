import SwiftUI



// MARK: - General

struct GeneralTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section(Strings.Section.playback) {
                FieldRow(label: Strings.Field.autoLoopMode, help: Strings.Help.autoLoopMode) {
                    Picker("", selection: $model.settings.autoLoopMode) {
                        Text("Off").tag("off")
                        Text("Forward").tag("on")
                        Text("Ping-pong").tag("pp")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
                FieldRow(label: Strings.Field.frameBufferSize, help: Strings.Help.frameBufferSize) {
                    TextField("default: 50", text: $model.settings.frameBufferSize)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.timeShift, help: Strings.Help.timeShift) {
                    TextField("e.g. 0.150, x1.04+0.1", text: $model.settings.timeShift)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.wheelSensitivity, help: Strings.Help.wheelSensitivity) {
                    TextField("default: 1", text: $model.settings.wheelSensitivity)
                        .textFieldStyle(.roundedBorder)
                }
                Toggle(Strings.Toggle.subtractionMode, isOn: $model.settings.subtractionMode).help(Strings.Help.helpToggleSubtractionMode)
            }
            Section(Strings.Section.windowQuality) {
                Toggle(Strings.Toggle.highDPI, isOn: $model.settings.highDPI).help(Strings.Help.helpToggleHighDPI)
                Toggle(Strings.Toggle.tenBit, isOn: $model.settings.tenBitPerComponent).help(Strings.Help.helpToggleTenBit)
                Toggle(Strings.Toggle.fullscreen, isOn: $model.settings.fullscreen).help(Strings.Help.helpToggleFullscreen)
                FieldRow(label: Strings.Field.displayNumber, help: Strings.Help.displayNumber) {
                    TextField("default: 0", text: $model.settings.displayNumber)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.uiScale, help: Strings.Help.uiScale) {
                    TextField("default: 1.0", text: $model.settings.uiScale)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.font, help: Strings.Help.font) {
                    Picker("", selection: $model.settings.font) {
                        Text(Strings.Picker.auto).tag("auto")
                        Text(Strings.Picker.scp).tag("scp")
                        Text(Strings.Picker.sarasa).tag("sarasa")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
            }
            Section(Strings.Field.output) {
                Toggle(Strings.Toggle.verbose, isOn: $model.settings.verbose).help(Strings.Help.verbose)
            }
        }
    }
}

// MARK: - Display

struct DisplayTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section(Strings.Section.layout) {
                FieldRow(label: Strings.Field.mode, help: Strings.Help.mode) {
                    Picker("", selection: $model.settings.mode) {
                        Text(Strings.Picker.split).tag("split")
                        Text(Strings.Picker.vstack).tag("vstack")
                        Text(Strings.Picker.hstack).tag("hstack")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
            }
            Section(Strings.Field.windowSizeFixed) {
                FieldRow(label: Strings.Field.windowSize, help: Strings.Help.windowSizeOverride) {
                    Picker("", selection: $model.settings.windowSizeMode) {
                        Text(Strings.Picker.video).tag("video")
                        Text(Strings.Picker.fixed).tag("fixed")
                        Text(Strings.Picker.fit).tag("fit")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
                if model.settings.windowSizeMode == "fixed" {
                    FieldRow(label: Strings.Field.widthHeight, help: Strings.Help.widthHeight) {
                        Text(Strings.Help.widthHeight)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        TextField("1280", text: $model.settings.windowWidth)
                            .frame(width: 90)
                            .textFieldStyle(.roundedBorder)
                        Text("×")
                            .foregroundStyle(.secondary)
                        TextField("720", text: $model.settings.windowHeight)
                            .frame(width: 90)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            Section(Strings.Field.aspectSection) {
                FieldRow(label: Strings.Field.aspectLock, help: Strings.Help.aspectLock) {
                    Picker("", selection: $model.settings.aspectLock) {
                        Text(Strings.Picker.off).tag("off")
                        Text(Strings.Picker.windowRatio).tag("window")
                        Text(Strings.Picker.contentRatio).tag("content")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
                FieldRow(label: Strings.Field.aspectView, help: Strings.Help.aspectView) {
                    Picker("", selection: $model.settings.aspectViewMode) {
                        Text(Strings.Picker.stretch).tag("stretch")
                        Text(Strings.Picker.original).tag("original")
                        Text(Strings.Picker.dynamic).tag("dynamic")
                        Text(Strings.Picker.sixteenByNine).tag("16:9")
                        Text(Strings.Picker.fourByThree).tag("4:3")
                        Text(Strings.Picker.oneByOne).tag("1:1")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
            }
        }
    }
}

@MainActor
struct GeneralTabView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralTabView()
            .environmentObject(AppModel())
            .frame(width: 600, height: 600)
            .formStyle(.grouped)
    }
}

@MainActor
struct DisplayTabView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayTabView()
            .environmentObject(AppModel())
            .frame(width: 600, height: 600)
            .formStyle(.grouped)
    }
}