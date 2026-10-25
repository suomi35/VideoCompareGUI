import Foundation
import SwiftUI

@available(macOS 10.15, *)
public final class Strings {
    private init() {}

    // MARK: - App strings
    public struct App {
        public static let name = "Video Compare GUI";
    }
    
    // MARK: - Section titles
    public struct Section {
        public static let aspect: LocalizedStringKey = "section.aspect"
        public static let colorimetry: LocalizedStringKey = "section.colorimetry"
        public static let layout: LocalizedStringKey = "section.layout"
        public static let output: LocalizedStringKey = "section.output"
        public static let playback: LocalizedStringKey = "section.playback"
        public static let scaling: LocalizedStringKey = "section.scaling"
        public static let scopeWindows: LocalizedStringKey = "section.scopeWindows"
        public static let toneMapping: LocalizedStringKey = "section.toneMapping"
        public static let vmafConversion: LocalizedStringKey = "section.vmafConversion"
        public static let windowQuality: LocalizedStringKey = "section.windowQuality"
    }

    // MARK: - About panel text
    public struct About {
        public static let buildNumber: LocalizedStringKey = "about.buildNumber"
        public static let buildVersion: LocalizedStringKey = "about.buildVersion"
        public static let creditsTetzkatLipHoka: LocalizedStringKey = "about.creditsTetzkatLipHoka"
        public static let creditsTetzkatLipHokaPrefix: LocalizedStringKey = "about.creditsTetzkatLipHokaPrefix"
        public static let creditsTetzkatLipHokaSuffix: LocalizedStringKey = "about.creditsTetzkatLipHokaSuffix"
        public static let creditsTitle: LocalizedStringKey = "about.creditsTitle"
        public static let descriptionPrefix: LocalizedStringKey = "about.descriptionPrefix"
        public static let descriptionSuffix: LocalizedStringKey = "about.descriptionSuffix"
        public static let licenseText: LocalizedStringKey = "about.licenseText"
        public static let licenseTitle: LocalizedStringKey = "about.licenseTitle"
        public static let videoCompareTool: LocalizedStringKey = "about.videoCompareTool"
    }

    // MARK: - Field labels
    public struct Field {
        public static let aspectLock: LocalizedStringKey = "field.aspectLock"
        public static let aspectSection: LocalizedStringKey = "field.aspectSection"
        public static let aspectView: LocalizedStringKey = "field.aspectView"
        public static let autoLoopMode: LocalizedStringKey = "field.autoLoopMode"
        public static let bilinearTexture: LocalizedStringKey = "field.bilinearTexture"
        public static let boostTone: LocalizedStringKey = "field.boostTone"
        public static let colorPrimaries: LocalizedStringKey = "field.colorPrimaries"
        public static let colorRange: LocalizedStringKey = "field.colorRange"
        public static let colorSpace: LocalizedStringKey = "field.colorSpace"
        public static let colorTRC: LocalizedStringKey = "field.colorTRC"
        public static let conversionFit: LocalizedStringKey = "field.conversionFit"
        public static let conversionSize: LocalizedStringKey = "field.conversionSize"
        public static let decoder: LocalizedStringKey = "field.decoder"
        public static let demuxer: LocalizedStringKey = "field.demuxer"
        public static let displayNumber: LocalizedStringKey = "field.displayNumber"
        public static let fastAlignment: LocalizedStringKey = "field.fastAlignment"
        public static let filterOptions: LocalizedStringKey = "field.filterOptions"
        public static let filters: LocalizedStringKey = "field.filters"
        public static let font: LocalizedStringKey = "field.font"
        public static let frameBufferSize: LocalizedStringKey = "field.frameBufferSize"
        public static let hardwareAcceleration: LocalizedStringKey = "field.hardwareAcceleration"
        public static let height: LocalizedStringKey = "field.height"
        public static let leftPeakNits: LocalizedStringKey = "field.leftPeakNits"
        public static let libvmafOptions: LocalizedStringKey = "field.libvmafOptions"
        public static let mode: LocalizedStringKey = "field.mode"
        public static let noAutoFilters: LocalizedStringKey = "field.noAutoFilters"
        public static let output: LocalizedStringKey = "field.output"
        public static let rightPeakNits: LocalizedStringKey = "field.rightPeakNits"
        public static let scopeColorMode: LocalizedStringKey = "field.scopeColorMode"
        public static let scopeNoTop: LocalizedStringKey = "field.scopeNoTop"
        public static let scopeSize: LocalizedStringKey = "field.scopeSize"
        public static let timeShift: LocalizedStringKey = "field.timeShift"
        public static let toneMapMode: LocalizedStringKey = "field.toneMapMode"
        public static let uiScale: LocalizedStringKey = "field.uiScale"
        public static let wheelSensitivity: LocalizedStringKey = "field.wheelSensitivity"
        public static let width: LocalizedStringKey = "field.width"
        public static let windowSize: LocalizedStringKey = "field.windowSize"
        public static let windowSizeFixed: LocalizedStringKey = "field.windowSizeFixed"
    }

    // MARK: - Help text
    public struct Help {
        public static let aspectLock: LocalizedStringKey = "help.aspectLock"
        public static let aspectView: LocalizedStringKey = "help.aspectView"
        public static let autoLoopMode: LocalizedStringKey = "help.autoLoopMode"
        public static let bilinearTexture: LocalizedStringKey = "help.bilinearTexture"
        public static let boostTone: LocalizedStringKey = "help.boostTone"
        public static let colorPrimaries: LocalizedStringKey = "help.colorPrimaries"
        public static let colorRange: LocalizedStringKey = "help.colorRange"
        public static let colorSpace: LocalizedStringKey = "help.colorSpace"
        public static let colorTRC: LocalizedStringKey = "help.colorTRC"
        public static let conversionFit: LocalizedStringKey = "help.conversionFit"
        public static let conversionSize: LocalizedStringKey = "help.conversionSize"
        public static let copyToClipboard: LocalizedStringKey = "help.copyToClipboard"
        public static let decoder: LocalizedStringKey = "help.decoder"
        public static let demuxer: LocalizedStringKey = "help.demuxer"
        public static let displayNumber: LocalizedStringKey = "help.displayNumber"
        public static let fastAlignment: LocalizedStringKey = "help.fastAlignment"
        public static let filters: LocalizedStringKey = "help.filters"
        public static let font: LocalizedStringKey = "help.font"
        public static let frameBufferSize: LocalizedStringKey = "help.frameBufferSize"
        public static let hardwareAcceleration: LocalizedStringKey = "help.hardwareAcceleration"
        public static let helpCopyOutput: LocalizedStringKey = "help.copyOutput"
        public static let helpDecoderBoth: LocalizedStringKey = "help.decoder.both"
        public static let helpDecoderLeft: LocalizedStringKey = "help.decoder.left"
        public static let helpDecoderRight: LocalizedStringKey = "help.decoder.right"
        public static let helpDemuxerBoth: LocalizedStringKey = "help.demuxer.both"
        public static let helpDemuxerLeft: LocalizedStringKey = "help.demuxer.left"
        public static let helpDemuxerRight: LocalizedStringKey = "help.demuxer.right"
        public static let helpFiltersBoth: LocalizedStringKey = "help.filters.both"
        public static let helpFiltersLeft: LocalizedStringKey = "help.filters.left"
        public static let helpFiltersRight: LocalizedStringKey = "help.filters.right"
        public static let helpHwaccelBoth: LocalizedStringKey = "help.hwaccel.both"
        public static let helpHwaccelLeft: LocalizedStringKey = "help.hwaccel.left"
        public static let helpHwaccelRight: LocalizedStringKey = "help.hwaccel.right"
        public static let helpRescan: LocalizedStringKey = "help.rescan"
        public static let helpSwapLeftRight: LocalizedStringKey = "help.swap.left.right"
        public static let helpToggleBilinearTexture: LocalizedStringKey = "help.toggle.bilinearTexture"
        public static let helpToggleFastAlignment: LocalizedStringKey = "help.toggle.fastAlignment"
        public static let helpToggleFullscreen: LocalizedStringKey = "help.toggle.fullscreen"
        public static let helpToggleHighDPI: LocalizedStringKey = "help.toggle.highDPI"
        public static let helpToggleHistogramWindow: LocalizedStringKey = "help.toggle.histogramWindow"
        public static let helpToggleNoAutoFilters: LocalizedStringKey = "help.toggle.noAutoFilters"
        public static let helpToggleScopeNoTop: LocalizedStringKey = "help.toggle.scopeNoTop"
        public static let helpToggleScopeSize: LocalizedStringKey = "help.toggle.scopeSize"
        public static let helpToggleSubtractionMode: LocalizedStringKey = "help.toggle.subtractionMode"
        public static let helpToggleTenBit: LocalizedStringKey = "help.toggle.tenBit"
        public static let helpToggleVectorscopeWindow: LocalizedStringKey = "help.toggle.vectorscopeWindow"
        public static let helpToggleWaveformWindow: LocalizedStringKey = "help.toggle.waveformWindow"
        public static let histogramOptions: LocalizedStringKey = "help.histogramOptions"
        public static let leftPeakNits: LocalizedStringKey = "help.leftPeakNits"
        public static let libvmafOptions: LocalizedStringKey = "help.libvmafOptions"
        public static let mode: LocalizedStringKey = "help.mode"
        public static let noAutoFilters: LocalizedStringKey = "help.noAutoFilters"
        public static let rightPeakNits: LocalizedStringKey = "help.rightPeakNits"
        public static let scopeColorMode: LocalizedStringKey = "help.scopeColorMode"
        public static let scopeNoTop: LocalizedStringKey = "help.scopeNoTop"
        public static let scopeSize: LocalizedStringKey = "help.scopeSize"
        public static let timeShift: LocalizedStringKey = "help.timeShift"
        public static let toneMapMode: LocalizedStringKey = "help.toneMapMode"
        public static let uiScale: LocalizedStringKey = "help.uiScale"
        public static let vectorscopeOptions: LocalizedStringKey = "help.vectorscopeOptions"
        public static let verbose: LocalizedStringKey = "help.verbose"
        public static let waveformOptions: LocalizedStringKey = "help.waveformOptions"
        public static let wheelSensitivity: LocalizedStringKey = "help.wheelSensitivity"
        public static let widthHeight: LocalizedStringKey = "help.widthHeight"
        public static let windowSizeOverride: LocalizedStringKey = "help.windowSizeOverride"
    }

    // MARK: - Picker options
    public struct Picker {
        public static let auto: LocalizedStringKey = "picker.auto"
        public static let bothSides: LocalizedStringKey = "picker.bothSides"
        public static let bottomVideo: LocalizedStringKey = "picker.bottomVideo"
        public static let contentRatio: LocalizedStringKey = "picker.contentRatio"
        public static let dynamic: LocalizedStringKey = "picker.dynamic"
        public static let fixed: LocalizedStringKey = "picker.fixed"
        public static let fit: LocalizedStringKey = "picker.fit"
        public static let forward: LocalizedStringKey = "picker.forward"
        public static let fourByThree: LocalizedStringKey = "picker.fourByThree"
        public static let histogram: LocalizedStringKey = "picker.histogram"
        public static let hstack: LocalizedStringKey = "picker.hstack"
        public static let left: LocalizedStringKey = "picker.left"
        public static let leftVideo: LocalizedStringKey = "picker.leftVideo"
        public static let native: LocalizedStringKey = "picker.native"
        public static let off: LocalizedStringKey = "picker.off"
        public static let oneByOne: LocalizedStringKey = "picker.oneByOne"
        public static let on: LocalizedStringKey = "picker.on"
        public static let original: LocalizedStringKey = "picker.original"
        public static let pingPong: LocalizedStringKey = "picker.pingPong"
        public static let relative: LocalizedStringKey = "picker.relative"
        public static let right: LocalizedStringKey = "picker.right"
        public static let rightVideo: LocalizedStringKey = "picker.rightVideo"
        public static let sarasa: LocalizedStringKey = "picker.sarasa"
        public static let scp: LocalizedStringKey = "picker.scp"
        public static let sixteenByNine: LocalizedStringKey = "picker.sixteenByNine"
        public static let split: LocalizedStringKey = "picker.split"
        public static let stretch: LocalizedStringKey = "picker.stretch"
        public static let topVideo: LocalizedStringKey = "picker.topVideo"
        public static let vectorscope: LocalizedStringKey = "picker.vectorscope"
        public static let video: LocalizedStringKey = "picker.video"
        public static let vstack: LocalizedStringKey = "picker.vstack"
        public static let waveform: LocalizedStringKey = "picker.waveform"
        public static let windowRatio: LocalizedStringKey = "picker.windowRatio"
    }

    // MARK: - Placeholders
    public struct Placeholder {
        public static let boostTone: LocalizedStringKey = "placeholder.boostTone"
        public static let clickToChoose: LocalizedStringKey = "placeholder.clickToChoose"
        public static let colorPrimaries: LocalizedStringKey = "placeholder.colorPrimaries"
        public static let colorRange: LocalizedStringKey = "placeholder.colorRange"
        public static let colorSpace: LocalizedStringKey = "placeholder.colorSpace"
        public static let colorTRC: LocalizedStringKey = "placeholder.colorTRC"
        public static let conversionSize: LocalizedStringKey = "placeholder.conversionSize"
        public static let decoder: LocalizedStringKey = "placeholder.decoder"
        public static let demuxer: LocalizedStringKey = "placeholder.demuxer"
        public static let displayNumber: LocalizedStringKey = "placeholder.displayNumber"
        public static let dropVideoHere: LocalizedStringKey = "placeholder.dropVideoHere"
        public static let filters: LocalizedStringKey = "placeholder.filters"
        public static let frameBufferSize: LocalizedStringKey = "placeholder.frameBufferSize"
        public static let histogramOptions: LocalizedStringKey = "placeholder.histogramOptions"
        public static let hwaccel: LocalizedStringKey = "placeholder.hwaccel"
        public static let libvmaf: LocalizedStringKey = "placeholder.libvmaf"
        public static let peakNits: LocalizedStringKey = "placeholder.peakNits"
        public static let scopeColorMode: LocalizedStringKey = "placeholder.scopeColorMode"
        public static let selectVideos: LocalizedStringKey = "placeholder.selectVideos"
        public static let timeShift: LocalizedStringKey = "placeholder.timeShift"
        public static let uiScale: LocalizedStringKey = "placeholder.uiScale"
        public static let vectorscopeOptions: LocalizedStringKey = "placeholder.vectorscopeOptions"
        public static let waveformOptions: LocalizedStringKey = "placeholder.waveformOptions"
        public static let wheelSensitivity: LocalizedStringKey = "placeholder.wheelSensitivity"
        public static let windowHeight: LocalizedStringKey = "placeholder.windowHeight"
        public static let windowWidth: LocalizedStringKey = "placeholder.windowWidth"
    }

    // MARK: - Toggle labels
    public struct Toggle {
        public static let bilinearTexture: LocalizedStringKey = "toggle.bilinearTexture"
        public static let differentPerSide: LocalizedStringKey = "toggle.differentPerSide"
        public static let fastAlignment: LocalizedStringKey = "toggle.fastAlignment"
        public static let fullscreen: LocalizedStringKey = "toggle.fullscreen"
        public static let highDPI: LocalizedStringKey = "toggle.highDPI"
        public static let histogramWindow: LocalizedStringKey = "toggle.histogramWindow"
        public static let noAutoFilters: LocalizedStringKey = "toggle.noAutoFilters"
        public static let scopeNoTop: LocalizedStringKey = "toggle.scopeNoTop"
        public static let subtractionMode: LocalizedStringKey = "toggle.subtractionMode"
        public static let tenBit: LocalizedStringKey = "toggle.tenBit"
        public static let vectorscopeWindow: LocalizedStringKey = "toggle.vectorscopeWindow"
        public static let verbose: LocalizedStringKey = "toggle.verbose"
        public static let waveformWindow: LocalizedStringKey = "toggle.waveformWindow"
    }

    // MARK: - Buttons / menu items
    public struct Button {
        public static let about: LocalizedStringKey = "menu.about"
        public static let chooseLeft: LocalizedStringKey = "menu.choose.left"
        public static let chooseRight: LocalizedStringKey = "menu.choose.right"
        public static let clear: LocalizedStringKey = "menu.clear"
        public static let clearFiles: LocalizedStringKey = "button.clearFiles"
        public static let clearRecents: LocalizedStringKey = "button.clearRecents"
        public static let copyOutput: LocalizedStringKey = "button.copyOutput"
        public static let launch: LocalizedStringKey = "menu.launch"
        public static let launchButton: LocalizedStringKey = "button.launch"
        public static let launchComparison: LocalizedStringKey = "button.launchComparison"
        public static let ok: LocalizedStringKey = "button.ok"
        public static let rescan: LocalizedStringKey = "button.rescan"
        public static let stop: LocalizedStringKey = "button.stop"
        public static let swap: LocalizedStringKey = "menu.swap"
        public static let swapSides: LocalizedStringKey = "button.swapSides"
    }

    // MARK: - Labels
    public struct Label {
        public static let commandPreview: LocalizedStringKey = "label.commandPreview"
        public static let recents: LocalizedStringKey = "label.recents"
    }

    // MARK: - Tips
    public struct Tip {
        public static let dragVideos: LocalizedStringKey = "tip.dragVideos"
    }

    // MARK: - Tab items
    public struct Tab {
        public static let colorTone: LocalizedStringKey = "tab.colorTone"
        public static let display: LocalizedStringKey = "tab.display"
        public static let filters: LocalizedStringKey = "tab.filters"
        public static let general: LocalizedStringKey = "tab.general"
        public static let scopes: LocalizedStringKey = "tab.scopes"
    }

    // MARK: - Descriptive text
    public struct Text {
        public static let colorValues: LocalizedStringKey = "text.colorValues"
        public static let demuxer: LocalizedStringKey = "text.demuxer"
        public static let filters: LocalizedStringKey = "text.filters"
        public static let scopes: LocalizedStringKey = "text.scopes"
    }

    // MARK: - Alerts
    public struct Alert {
        public static let clickRescan: LocalizedStringKey = "alert.videoCompareNotFound.clickRescan"
        public static let exitCodeMessageNoOutput: LocalizedStringKey = "alert.exitCode.message.noOutput"
        public static let exitCodeTitle: LocalizedStringKey = "alert.exitCode.title"
        public static let fileNotFoundMessage: LocalizedStringKey = "alert.fileNotFound.message"
        public static let fileNotFoundTitle: LocalizedStringKey = "alert.fileNotFound.title"
        public static let launchFailedTitle: LocalizedStringKey = "alert.launchFailed.title"
        public static let sameFileMessage: LocalizedStringKey = "alert.sameFile.message"
        public static let sameFileTitle: LocalizedStringKey = "alert.sameFile.title"
        public static let selectTwoVideosMessage: LocalizedStringKey = "alert.selectTwoVideos.message"
        public static let selectTwoVideosTitle: LocalizedStringKey = "alert.selectTwoVideos.title"
        public static let textCopiedToClipboard: LocalizedStringKey = "alert.videoCompareNotFound.textCopiedToClipboard"
        public static let videoCompareNotFoundMessageInstallHomebrew: LocalizedStringKey = "alert.videoCompareNotFound.messageInstallHomebrew"
        public static let videoCompareNotFoundMessageInstall: LocalizedStringKey = "alert.videoCompareNotFound.messageInstall"
        public static let videoCompareNotFoundTitle: LocalizedStringKey = "alert.videoCompareNotFound.title"
    }
    
    // MARK: - Panel items
    public struct Panel {
        public static let chooseLeftVideo: LocalizedStringKey = "panel.chooseLeftVideo"
        public static let chooseRightVideo: LocalizedStringKey = "panel.chooseRightVideo"
    }
}
