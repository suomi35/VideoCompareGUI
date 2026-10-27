#!/bin/bash
# Builds VideoCompare.app from the Swift package and ad-hoc signs it.
# Usage: ./make_app.sh [--install]
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Building release binary (universal)..."
if [ ! -f .build/release/VideoCompareGUI ]; then
    swift build -c release --arch arm64 --arch x86_64 -Xlinker -macos_version_min -Xlinker 13.0.0
else
    echo "    Binary already present at .build/release/VideoCompareGUI (pre-built by CI matrix), skipping build."
fi

APP="build/Video Compare GUI.app"
echo "==> Assembling ${APP}..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/VideoCompareGUI "$APP/Contents/MacOS/VideoCompareGUI"
chmod +x "$APP/Contents/MacOS/VideoCompareGUI"

# Ensure universal binary (Apple Silicon + Intel). If SwiftPM did not emit a
# multi-arch binary, add the missing Intel slice with lipo.
ARCHS=$(lipo -archs "$APP/Contents/MacOS/VideoCompareGUI" 2>/dev/null || true)
if [[ ! "$ARCHS" =~ x86_64 ]]; then
    echo "==> Adding Intel slice via lipo..."
    swift build -c release --arch x86_64 --build-path .build/x86_64
    lipo -create -output "$APP/Contents/MacOS/VideoCompareGUI" \
        "$APP/Contents/MacOS/VideoCompareGUI" \
        .build/x86_64/release/VideoCompareGUI
fi
cp Resources/Info.plist "$APP/Contents/Info.plist"

echo "==> Copying localized resources (.lproj) into app bundle..."
# Copy .lproj directories from the source tree so Bundle.main finds them at runtime.
# (SwiftPM compiles them into a module bundle during `swift build`, but CI only
# downloads the binary artifact, so we copy from source to be safe.)
for lproj in Sources/VideoCompareGUI/Resources/*.lproj; do
    if [ -d "$lproj" ]; then
        cp -R "$lproj" "$APP/Contents/Resources/"
        echo "    Bundled $(basename "$lproj")"
    fi
done

echo "==> Building AppIcon.icns from AppIcon.appiconset..."
TMPBASE=$(mktemp -d)
TMPIconset="$TMPBASE/AppIcon.iconset"
mkdir -p "$TMPIconset"
SRC="Resources/Assets.xcassets/AppIcon.appiconset"
# iconutil requires icon_<size>x<size>[@2x].png naming (16,32,128,256,512)
cp "$SRC/icon_16x16.png"      "$TMPIconset/icon_16x16.png"
cp "$SRC/icon_16x16@2x.png"   "$TMPIconset/icon_16x16@2x.png"
cp "$SRC/icon_32x32.png"      "$TMPIconset/icon_32x32.png"
cp "$SRC/icon_32x32@2x.png"   "$TMPIconset/icon_32x32@2x.png"
cp "$SRC/icon_128x128.png"    "$TMPIconset/icon_128x128.png"
cp "$SRC/icon_128x128@2x.png" "$TMPIconset/icon_128x128@2x.png"
cp "$SRC/icon_256x256.png"    "$TMPIconset/icon_256x256.png"
cp "$SRC/icon_256x256@2x.png" "$TMPIconset/icon_256x256@2x.png"
cp "$SRC/icon_512x512.png"    "$TMPIconset/icon_512x512.png"
cp "$SRC/icon_512x512@2x.png" "$TMPIconset/icon_512x512@2x.png"
if iconutil -c icns "$TMPIconset" -o "$APP/Contents/Resources/AppIcon.icns"; then
    echo "==> Bundled AppIcon.icns"
    /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile AppIcon" "$APP/Contents/Info.plist" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "$APP/Contents/Info.plist"
else
    echo "==> WARNING: iconutil failed - app will have no icon"
fi
rm -rf "$TMPBASE"

printf 'APPL????' > "$APP/Contents/PkgInfo"

# Inject version into Info.plist (CI sets VERSION/BUILD env vars)
if [ -n "${VERSION:-}" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$APP/Contents/Info.plist" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $VERSION" "$APP/Contents/Info.plist"
fi
if [ -n "${BUILD:-}" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD" "$APP/Contents/Info.plist" 2>/dev/null \
      || /usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $BUILD" "$APP/Contents/Info.plist"
fi

echo "==> Ad-hoc signing..."
codesign --force --sign - "$APP"

if [[ "${1:-}" == "--install" ]]; then
    echo "==> Installing to /Applications..."
    rm -rf "/Applications/Video Compare GUI.app"
    cp -R "$APP" "/Applications/Video Compare GUI.app"
    echo "Installed. Launch with: open '/Applications/Video Compare GUI.app'"
else
    echo "==> Done: $APP"
    echo "    Install with: ./make_app.sh --install"
    echo "    Or run in place: open '$APP'"
fi

# Optional: create a DMG if CREATE_DMG=1
case "${CREATE_DMG:-}" in
  1|true|yes)
    DMG="build/Video-Compare-GUI.dmg"
    STAGE=$(mktemp -d)
    cp -R "$APP" "$STAGE/"
    ln -s /Applications "$STAGE/Applications"
    mkdir -p build
    rm -f "$DMG"
    hdiutil create -volname "Video Compare GUI" -srcfolder "$STAGE" -ov -format UDZO "$DMG"
    rm -rf "$STAGE"
    echo "==> Created $DMG"
    ;;
esac
