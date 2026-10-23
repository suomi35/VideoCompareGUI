import Foundation

/// Translates GUI settings into a video-compare argument vector.
public enum CommandLineBuilder {

    /// Builds the full argument list: options followed by the two input files.
    public static func buildArguments(settings: Settings, leftFile: String, rightFile: String) -> [String] {
        var args: [String] = []
        let s = settings

        // MARK: General
        if s.fullscreen { args += ["-u"] }
        if s.highDPI { args += ["-d"] }
        if s.tenBitPerComponent { args += ["-b"] }
        if s.subtractionMode { args += ["-S"] }
        if s.autoLoopMode != "off" { args += ["-a", s.autoLoopMode] }
        addIfNonEmpty(&args, "-f", s.frameBufferSize)
        addIfNonEmpty(&args, "-t", s.timeShift)
        addIfNonEmpty(&args, "-s", s.wheelSensitivity)
        addIfNonEmpty(&args, "-U", s.uiScale)
        addIfNonEmpty(&args, "-n", s.displayNumber)
        if s.font != "auto" { args += ["-g", s.font] }
        if s.verbose { args += ["-v"] }

        // MARK: Display
        if s.mode != "split" { args += ["-m", s.mode] }
        switch s.windowSizeMode {
        case "fixed":
            let w = s.windowWidth.trimmed
            let h = s.windowHeight.trimmed
            if !w.isEmpty || !h.isEmpty {
                args += ["-w", "\(w)x\(h)"]
            }
        case "fit":
            args += ["-W"]
        default:
            break
        }
        if s.aspectLock != "off" { args += ["-k", s.aspectLock] }
        if s.aspectViewMode != "stretch" { args += ["-x", s.aspectViewMode] }

        // MARK: Color & Tone
        addIfNonEmpty(&args, "-C", s.colorSpace)
        addIfNonEmpty(&args, "-A", s.colorRange)
        addIfNonEmpty(&args, "-P", s.colorPrimaries)
        addIfNonEmpty(&args, "-N", s.colorTRC)
        if s.toneMapMode != "auto" { args += ["-T", s.toneMapMode] }
        addIfNonEmpty(&args, "-L", s.leftPeakNits)
        addIfNonEmpty(&args, "-R", s.rightPeakNits)
        addIfNonEmpty(&args, "-B", s.boostTone)

        // MARK: Filters & Decoders ("both" wins over per-side, like VideoCompareGUI)
        addIfNonEmpty(&args, "-i", s.filtersBoth)
        if s.filtersBoth.trimmed.isEmpty {
            addIfNonEmpty(&args, "-l", s.filtersLeft)
            addIfNonEmpty(&args, "-r", s.filtersRight)
        }
        addIfNonEmpty(&args, "--demuxer", s.demuxerBoth)
        if s.demuxerBoth.trimmed.isEmpty {
            addIfNonEmpty(&args, "--left-demuxer", s.demuxerLeft)
            addIfNonEmpty(&args, "--right-demuxer", s.demuxerRight)
        }
        addIfNonEmpty(&args, "--decoder", s.decoderBoth)
        if s.decoderBoth.trimmed.isEmpty {
            addIfNonEmpty(&args, "--left-decoder", s.decoderLeft)
            addIfNonEmpty(&args, "--right-decoder", s.decoderRight)
        }
        addIfNonEmpty(&args, "--hwaccel", s.hwaccelBoth)
        if s.hwaccelBoth.trimmed.isEmpty {
            addIfNonEmpty(&args, "--left-hwaccel", s.hwaccelLeft)
            addIfNonEmpty(&args, "--right-hwaccel", s.hwaccelRight)
        }
        addIfNonEmpty(&args, "--libvmaf-options", s.libvmafOptions)
        addIfNonEmpty(&args, "--conversion-size", s.conversionSize)
        if s.conversionFit != "stretch" { args += ["--conversion-fit", s.conversionFit] }
        if s.fastAlignment { args += ["-F"] }
        if s.bilinearTexture { args += ["-I"] }
        if s.noAutoFilters { args += ["--no-auto-filters"] }

        // MARK: Scopes
        if s.histogramWindow { args += ["--histogram-window"] }
        addIfNonEmpty(&args, "--histogram-options", s.histogramOptions)
        if s.vectorscopeWindow { args += ["--vectorscope-window"] }
        addIfNonEmpty(&args, "--vectorscope-options", s.vectorscopeOptions)
        if s.waveformWindow { args += ["--waveform-window"] }
        addIfNonEmpty(&args, "--waveform-options", s.waveformOptions)
        if s.scopeSizeEnabled {
            let w = s.scopeWidth.trimmed.isEmpty ? "1024" : s.scopeWidth.trimmed
            let h = s.scopeHeight.trimmed.isEmpty ? "256" : s.scopeHeight.trimmed
            args += ["--scope-size", "\(w)x\(h)"]
        }
        if s.scopeNotop { args += ["--scope-notop"] }
        addIfNonEmpty(&args, "--scope-color-mode", s.scopeColorMode)

        // MARK: Input files
        args += [leftFile, rightFile]
        return args
    }

    private static func addIfNonEmpty(_ args: inout [String], _ flag: String, _ value: String) {
        let v = value.trimmed
        if !v.isEmpty {
            args += [flag, v]
        }
    }
}

/// Shell-style rendering of an argument vector, for display in the preview only.
public enum CommandQuoter {
    public static func quote(_ arguments: [String]) -> String {
        arguments.map { arg in
            if arg.isEmpty { return "''" }
            if arg.range(of: "^[A-Za-z0-9._/:+=,@%-]+$", options: .regularExpression) != nil {
                return arg
            }
            return "'" + arg.replacingOccurrences(of: "'", with: "'\\''") + "'"
        }.joined(separator: " ")
    }
}