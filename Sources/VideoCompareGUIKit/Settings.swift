import Foundation

/// All launch options exposed by the GUI. Each non-empty/active value maps to
/// one or more video-compare command-line arguments (see CommandLineBuilder).
public struct Settings: Codable, Equatable {
    public init() {}
    // MARK: General
    public var fullscreen = false            // -u
    public var highDPI = false               // -d
    public var tenBitPerComponent = false    // -b
    public var subtractionMode = false       // -S
    public var autoLoopMode = "off"          // -a  off | on | pp
    public var frameBufferSize = ""          // -f
    public var timeShift = ""                // -t
    public var wheelSensitivity = ""         // -s
    public var uiScale = ""                  // -U
    public var displayNumber = ""            // -n
    public var font = "auto"                 // -g  auto | scp | sarasa | path
    public var verbose = false               // -v

    // MARK: Display
    public var mode = "split"                // -m  split | vstack | hstack
    public var windowSizeMode = "video"      // video | fixed (-w) | fit (-W)
    public var windowWidth = ""              // -w
    public var windowHeight = ""             // -w
    public var aspectLock = "off"            // -k  off | window | content
    public var aspectViewMode = "stretch"    // -x  stretch | original | dynamic | 16:9 | 4:3 | 1:1

    // MARK: Color & Tone
    public var colorSpace = ""               // -C
    public var colorRange = ""               // -A
    public var colorPrimaries = ""           // -P
    public var colorTRC = ""                 // -N
    public var toneMapMode = "auto"          // -T  auto | off | on | rel
    public var leftPeakNits = ""             // -L
    public var rightPeakNits = ""            // -R
    public var boostTone = ""                // -B

    // MARK: Filters & Decoders
    public var filtersBoth = ""              // -i
    public var filtersLeft = ""              // -l
    public var filtersRight = ""             // -r
    public var demuxerBoth = ""              // --demuxer
    public var demuxerLeft = ""              // --left-demuxer
    public var demuxerRight = ""             // --right-demuxer
    public var decoderBoth = ""              // --decoder
    public var decoderLeft = ""              // --left-decoder
    public var decoderRight = ""             // --right-decoder
    public var hwaccelBoth = ""              // --hwaccel
    public var hwaccelLeft = ""              // --left-hwaccel
    public var hwaccelRight = ""             // --right-hwaccel
    public var libvmafOptions = ""           // --libvmaf-options
    public var conversionSize = ""           // --conversion-size
    public var conversionFit = "stretch"     // --conversion-fit  stretch | native
    public var fastAlignment = false         // -F
    public var bilinearTexture = false       // -I
    public var noAutoFilters = false         // --no-auto-filters

    // MARK: Scopes
    public var histogramWindow = false       // --histogram-window
    public var histogramOptions = ""         // --histogram-options
    public var vectorscopeWindow = false     // --vectorscope-window
    public var vectorscopeOptions = ""       // --vectorscope-options
    public var waveformWindow = false        // --waveform-window
    public var waveformOptions = ""          // --waveform-options
    public var scopeSizeEnabled = false      // --scope-size WxH
    public var scopeWidth = "1024"
    public var scopeHeight = "256"
    public var scopeNoTop = false            // --scope-notop
    public var scopeColorMode = ""           // --scope-color-mode
}

public struct RecentPair: Codable, Equatable, Identifiable {
    public let id: UUID
    public let left: String
    public let right: String

    public init(left: String, right: String) {
        self.id = UUID()
        self.left = left
        self.right = right
    }
}
