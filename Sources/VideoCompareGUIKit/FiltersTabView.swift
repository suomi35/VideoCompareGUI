import SwiftUI

// MARK: - Filters & Decoders

struct FiltersTabView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section {
                Text(Strings.Text.filters)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            SideTripleField(
                title: Strings.Field.filters,
                placeholder: Strings.Placeholder.filters,
                helpBoth: Strings.Help.helpFiltersBoth,
                helpLeft: Strings.Help.helpFiltersLeft,
                helpRight: Strings.Help.helpFiltersRight,
                both: $model.settings.filtersBoth,
                left: $model.settings.filtersLeft,
                right: $model.settings.filtersRight
            )
            SideTripleField(
                title: Strings.Field.demuxer,
                placeholder: Strings.Placeholder.demuxer,
                helpBoth: Strings.Help.helpDemuxerBoth,
                helpLeft: Strings.Help.helpDemuxerLeft,
                helpRight: Strings.Help.helpDemuxerRight,
                both: $model.settings.demuxerBoth,
                left: $model.settings.demuxerLeft,
                right: $model.settings.demuxerRight
            )
            SideTripleField(
                title: Strings.Field.decoder,
                placeholder: Strings.Placeholder.decoder,
                helpBoth: Strings.Help.helpDecoderBoth,
                helpLeft: Strings.Help.helpDecoderLeft,
                helpRight: Strings.Help.helpDecoderRight,
                both: $model.settings.decoderBoth,
                left: $model.settings.decoderLeft,
                right: $model.settings.decoderRight
            )
            SideTripleField(
                title: Strings.Field.hardwareAcceleration,
                placeholder: Strings.Placeholder.hwaccel,
                helpBoth: Strings.Help.helpHwaccelBoth,
                helpLeft: Strings.Help.helpHwaccelLeft,
                helpRight: Strings.Help.helpHwaccelRight,
                both: $model.settings.hwaccelBoth,
                left: $model.settings.hwaccelLeft,
                right: $model.settings.hwaccelRight
            )
            Section(Strings.Section.vmafConversion) {
                FieldRow(label: Strings.Field.libvmafOptions, help: Strings.Help.libvmafOptions) {
                    TextField(Strings.Placeholder.libvmaf, text: $model.settings.libvmafOptions)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.conversionSize, help: Strings.Help.conversionSize) {
                    TextField(Strings.Placeholder.conversionSize, text: $model.settings.conversionSize)
                        .textFieldStyle(.roundedBorder)
                }
                FieldRow(label: Strings.Field.conversionFit, help: Strings.Help.conversionFit) {
                    Picker("", selection: $model.settings.conversionFit) {
                        Text(Strings.Picker.stretch).tag("stretch")
                        Text(Strings.Picker.native).tag("native")
                    }
                    .labelsHidden()
                    .frame(width: 180)
                }
            }
            Section(Strings.Section.scaling) {
                Toggle(Strings.Toggle.fastAlignment, isOn: $model.settings.fastAlignment).help(Strings.Help.helpToggleFastAlignment)
                Toggle(Strings.Toggle.bilinearTexture, isOn: $model.settings.bilinearTexture).help(Strings.Help.helpToggleBilinearTexture)
                Toggle(Strings.Toggle.noAutoFilters, isOn: $model.settings.noAutoFilters).help(Strings.Help.helpToggleNoAutoFilters)
            }
        }
    }
}

@MainActor
struct FiltersTabView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersTabView()
            .environmentObject(AppModel())
            .frame(width: 700, height: 600)
            .formStyle(.grouped)
    }
}