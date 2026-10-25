import SwiftUI

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
struct DisplayTabView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayTabView()
            .environmentObject(AppModel())
            .frame(width: 600, height: 600)
            .formStyle(.grouped)
    }
}