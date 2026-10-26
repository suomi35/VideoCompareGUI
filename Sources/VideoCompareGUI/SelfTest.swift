import Foundation

public enum SelfTest {
    public static func run() -> [String] {
        var failures: [String] = []

        func check(_ name: String, _ condition: Bool) {
            if !condition { failures.append(name) }
        }

        func args(_ settings: Settings, left: String = "l.mp4", right: String = "r.mp4") -> [String] {
            CommandLineBuilder.buildArguments(settings: settings, leftFile: left, rightFile: right)
        }

        func containsPair(_ a: [String], _ flag: String, _ value: String) -> Bool {
            zip(a, a.dropFirst()).contains { $0 == flag && $1 == value }
        }

        // 1. Defaults produce just the two files, nothing else.
        check("defaults: only files", args(Settings()) == ["l.mp4", "r.mp4"])

        // 2. Simple boolean flags.
        do {
            var s = Settings()
            s.highDPI = true
            s.tenBitPerComponent = true
            s.fullscreen = true
            s.subtractionMode = true
            let a = args(s)
            for flag in ["-d", "-b", "-u", "-S"] {
                check("bool flag \(flag)", a.contains(flag))
            }
        }

        // 3. Fixed window size.
        do {
            var s = Settings()
            s.windowSizeMode = "fixed"
            s.windowWidth = "1280"
            s.windowHeight = "720"
            check("window size", containsPair(args(s), "-w", "1280x720"))
        }

        // 4. Fit display.
        do {
            var s = Settings()
            s.windowSizeMode = "fit"
            check("fit display", args(s).contains("-W"))
        }

        // 5. "Both" filters win; per-side omitted.
        do {
            var s = Settings()
            s.filtersBoth = "scale=1:1"
            s.filtersLeft = "crop=1:1"
            let a = args(s)
            check("filters both present", containsPair(a, "-i", "scale=1:1"))
            check("filters left omitted", !a.contains("-l"))
        }

        // 6. Per-side filters when no "both".
        do {
            var s = Settings()
            s.filtersLeft = "yadif"
            check("per-side filter", containsPair(args(s), "-l", "yadif"))
        }

        // 7. Non-default mode and auto-loop.
        do {
            var s = Settings()
            s.mode = "vstack"
            s.autoLoopMode = "pp"
            let a = args(s)
            check("mode", containsPair(a, "-m", "vstack"))
            check("auto-loop", containsPair(a, "-a", "pp"))
        }

        // 8. Tone-map off is emitted; auto (default) is not.
        do {
            var s = Settings()
            s.toneMapMode = "off"
            check("tonemap off", containsPair(args(s), "-T", "off"))
        }
        check("tonemap default omitted", !args(Settings()).contains("-T"))

        // 9. Scope size defaults when field empty.
        do {
            var s = Settings()
            s.scopeSizeEnabled = true
            s.scopeWidth = ""
            s.scopeHeight = ""
            check("scope size default", containsPair(args(s), "--scope-size", "1024x256"))
        }

        // 10. Whitespace-only fields are omitted.
        do {
            var s = Settings()
            s.timeShift = "   "
            check("whitespace omitted", !args(s).contains("-t"))
        }

        // 11. Files with spaces are passed as single argv entries.
        check(
            "space file preserved",
            args(Settings(), left: "/tmp/left file.mp4", right: "/tmp/r.mp4").contains("/tmp/left file.mp4")
        )

        // 12. Quoter wraps args with spaces.
        check("quoter", CommandQuoter.quote(["a b", "plain"]) == "'a b' plain")

        // 13. hwaccel both wins, per-side fallback.
        do {
            var s = Settings()
            s.hwaccelBoth = "videotoolbox"
            s.hwaccelLeft = "cuda"
            let a = args(s)
            check("hwaccel both", containsPair(a, "--hwaccel", "videotoolbox"))
            check("hwaccel left omitted", !a.contains("--left-hwaccel"))
        }

        // 14. Scopes toggles.
        do {
            var s = Settings()
            s.histogramWindow = true
            s.vectorscopeWindow = true
            s.waveformWindow = true
            s.scopeNoTop = true
            let a = args(s)
            for flag in ["--histogram-window", "--vectorscope-window", "--waveform-window", "--scope-notop"] {
                check("scope flag \(flag)", a.contains(flag))
            }
        }

        // 15. Aspect view mode.
        do {
            var s = Settings()
            s.aspectViewMode = "4:3"
            s.aspectLock = "window"
            let a = args(s)
            check("aspect view", containsPair(a, "-x", "4:3"))
            check("aspect lock", containsPair(a, "-k", "window"))
        }

        return failures
    }
}
