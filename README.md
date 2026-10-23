# Video-Compare GUI (macOS)

A native macOS GUI for pixop's [Video-Compare Tool](https://github.com/pixop/video-compare) written in Swift/SwiftUI 

## Screenshots

<img alt="Main window" src="img/videocomparegui-macos1.webp" />

## Requirements

- macOS 13 (Ventura) or later
- [video-compare](https://formulae.brew.sh/formula/video-compare): `brew install video-compare`

## Build & Run

```sh
git clone YOUR_REPOSITORY_URL.git VideoCompareGUI
cd VideoCompareGUI
./make_app.sh                     # builds "build/Video Compare.app"
open "build/Video Compare.app"    # or: ./make_app.sh --install  → /Applications
```

Built with Swift Package Manager — only the Xcode Command Line Tools are required, not the full Xcode IDE.

## Features

- **Input wells** — click to choose, or drop video files onto the wells or the
  Dock icon; swap button and recent pairs included
- **Option tabs** covering every `video-compare` flag: General, Display,
  Color & Tone, Filters & Decoders, Scopes
- **Live command preview** — the exact command line is shown as you edit
- **Output capture** — errors and `stderr` from the last run surface in the app
- **Auto-discovery** — finds the `video-compare` binary (Homebrew, MacPorts, or
  `PATH`) and shows its version
- **Persistence** — options, last files and recents survive restarts
- **Localization** — all user-facing strings are externalized via `Localizable.strings`
  (English included); additional languages can be added by creating a new
  `.lproj` directory under `Sources/VideoCompareGUIKit/Resources/`

Shortcuts: `⇧⌘1` / `⇧⌘2` choose videos · `⇧⌘X` swap · `⇧⌘K` clear · `⌘↩` launch

## Development

```sh
swift build                                                  # debug build
./.build/debug/VideoCompareGUI --selftest                    # headless checks
./.build/debug/VideoCompareGUI --print-command-full          # sample full command
```

All views, models, and application core live in a single executable target
`VideoCompareGUI`

### Localization

Strings are defined in `Sources/VideoCompareGUI/Strings.swift` (typed
accessors) and their values live in
`Sources/VideoCompareGUI/Resources/en.lproj/Localizable.strings`. To add a
new language, create a sibling `.lproj` folder (e.g. `fi.lproj`) with a
translated `Localizable.strings` file and rebuild.

## Credits

- [pixop/video-compare](https://github.com/pixop/video-compare) — the CLI comparison tool itself
- Inspiration taken from [TetzkatLipHoka/VideoCompareGUI](https://github.com/TetzkatLipHoka/VideoCompareGUI) (Windows)

## License

This GUI is provided under the same terms as video-compare (GPLv2)  
See https://github.com/pixop/video-compare for the original tool and its license.
