import SwiftUI



// MARK: - General

struct GeneralTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section(Strings.Section.playback) {
                FieldRow(label: Strings.Field.autoLoopMode, help: Strings.Help.autoLoopMode) {
                    Picker("", selection: $model.settings.autoLoopMode) {
                        Text(Strings.Picker.off).tag("off")
                        Text(Strings.Picker.forward).tag("on")
                        Text(Strings.Picker.pingPong).tag("pp")
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                FieldRow(label: Strings.Field.frameBufferSize, help: Strings.Help.frameBufferSize) {
                    TextField(Strings.Placeholder.frameBufferSize, text: $model.settings.frameBufferSize)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.timeShift, help: Strings.Help.timeShift) {
                    TextField(Strings.Placeholder.timeShift, text: $model.settings.timeShift)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.wheelSensitivity, help: Strings.Help.wheelSensitivity) {
                    TextField(Strings.Placeholder.wheelSensitivity, text: $model.settings.wheelSensitivity)
                        .textFieldStyle(.roundedBorder)
                }
                Toggle(Strings.Toggle.subtractionMode, isOn: $model.settings.subtractionMode).help(Strings.Help.helpToggleSubtractionMode)
            }
            Section(Strings.Section.windowQuality) {
                Toggle(Strings.Toggle.highDPI, isOn: $model.settings.highDPI).help(Strings.Help.helpToggleHighDPI)
                Toggle(Strings.Toggle.tenBit, isOn: $model.settings.tenBitPerComponent).help(Strings.Help.helpToggleTenBit)
                Toggle(Strings.Toggle.fullscreen, isOn: $model.settings.fullscreen).help(Strings.Help.helpToggleFullscreen)
                FieldRow(label: Strings.Field.displayNumber, help: Strings.Help.displayNumber) {
                    TextField(Strings.Placeholder.displayNumber, text: $model.settings.displayNumber)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.uiScale, help: Strings.Help.uiScale) {
                    TextField(Strings.Placeholder.uiScale, text: $model.settings.uiScale)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.font, help: Strings.Help.font) {
                    Picker("", selection: $model.settings.font) {
                        Text(Strings.Picker.auto).tag("auto")
                        Text(Strings.Picker.scp).tag("scp")
                        Text(Strings.Picker.sarasa).tag("sarasa")
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                if model.settings.windowSizeMode == "fixed" {
                    VStack(alignment: .trailing) {
                        HStack {
                            Text(Strings.Field.width)
                            TextField("", text: $model.settings.windowWidth)
                                .textFieldStyle(.roundedBorder)
                                .labelsHidden()
                                .multilineTextAlignment(.trailing)
                                .frame(width: 90)
                        }
                        Spacer(minLength: 12)
                        HStack {
                            Text(Strings.Field.height)
                            TextField("", text: $model.settings.windowHeight)
                                .textFieldStyle(.roundedBorder)
                                .labelsHidden()
                                .multilineTextAlignment(.trailing)
                                .frame(width: 90)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
