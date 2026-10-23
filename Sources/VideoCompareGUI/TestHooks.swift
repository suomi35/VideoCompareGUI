import Foundation
import VideoCompareGUIKit

/// Hidden command-line hooks used for headless verification of the argument
/// builder (`--selftest`, `--print-command`). Not part of the public UI.
public enum TestHooks {

    /// Returns true if the arguments were handled (caller should exit).
    public static func handleIfNeeded() -> Bool {
        let args = CommandLine.arguments
        guard args.count > 1 else { return false }

        switch args[1] {
        case "--selftest":
            let failures = SelfTest.run()
            if failures.isEmpty {
                print("SELFTEST OK")
                exit(0)
            } else {
                for failure in failures { print("FAIL: \(failure)") }
                exit(1)
            }
        case "--print-command":
            // usage: --print-command LEFT RIGHT  (default settings)
            guard args.count >= 4 else {
                FileHandle.standardError.write("usage: --print-command LEFT RIGHT\n".data(using: .utf8)!)
                exit(2)
            }
            let built = CommandLineBuilder.buildArguments(
                settings: Settings(),
                leftFile: args[2],
                rightFile: args[3]
            )
            print(CommandQuoter.quote(built))
            exit(0)
        case "--print-command-full":
            print(CommandQuoter.quote(fullSampleArguments()))
            exit(0)
        default:
            return false
        }
    }

    /// A settings object exercising every option at once.
    static func fullSampleArguments() -> [String] {
        var s = Settings()
        s.fullscreen = true
        s.highDPI = true
        s.tenBitPerComponent = true
        s.subtractionMode = true
        s.autoLoopMode = "pp"
        s.frameBufferSize = "70"
        s.timeShift = "0.150"
        s.wheelSensitivity = "1.7"
        s.uiScale = "1.25"
        s.displayNumber = "1"
        s.font = "scp"
        s.verbose = true
        s.mode = "vstack"
        s.windowSizeMode = "fixed"
        s.windowWidth = "1280"
        s.windowHeight = "720"
        s.aspectLock = "content"
        s.aspectViewMode = "16:9"
        s.colorSpace = "bt709"
        s.colorRange = "pc:tv"
        s.colorPrimaries = "bt2020:bt709"
        s.colorTRC = "smpte2084:"
        s.toneMapMode = "on"
        s.leftPeakNits = "1000"
        s.rightPeakNits = "400"
        s.boostTone = "2:1.5"
        s.filtersBoth = "scale=1920:-2"
        s.demuxerLeft = "rawvideo"
        s.decoderRight = ":strict=-2"
        s.hwaccelBoth = "videotoolbox"
        s.libvmafOptions = "model=version=vmaf_v0.6.1"
        s.conversionSize = "1920x1440"
        s.conversionFit = "native"
        s.fastAlignment = true
        s.bilinearTexture = true
        s.noAutoFilters = true
        s.histogramWindow = true
        s.histogramOptions = "display_mode=parade"
        s.vectorscopeWindow = true
        s.waveformWindow = true
        s.scopeSizeEnabled = true
        s.scopeWidth = "800"
        s.scopeHeight = "200"
        s.scopeNotop = true
        return CommandLineBuilder.buildArguments(
            settings: s,
            leftFile: "/tmp/left file.mp4",
            rightFile: "/tmp/right.mp4"
        )
    }
}