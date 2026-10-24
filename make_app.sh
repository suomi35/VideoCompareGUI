#!/bin/bash
# Builds VideoCompare.app from the Swift package and ad-hoc signs it.
# Usage: ./make_app.sh [--install]
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Building release binary..."
swift build -c release

APP="build/Video Compare GUI.app"
echo "==> Assembling ${APP}..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/VideoCompareGUI "$APP/Contents/MacOS/VideoCompareGUI"
cp Resources/Info.plist "$APP/Contents/Info.plist"

echo "==> Copying localized resources (.lproj) into app bundle..."
# SwiftPM compiles .lproj directories into the module resource bundle.
# Copy them into the app's Contents/Resources so Bundle.main finds them at runtime.
RESOURCE_BUNDLE=".build/release/VideoCompareGUI_VideoCompareGUIKit.bundle"
if [ -d "$RESOURCE_BUNDLE" ]; then
    for lproj in "$RESOURCE_BUNDLE"/*.lproj; do
        if [ -d "$lproj" ]; then
            cp -R "$lproj" "$APP/Contents/Resources/"
            echo "    Bundled $(basename "$lproj")"
        fi
    done
else
    echo "    WARNING: resource bundle not found at $RESOURCE_BUNDLE - app will have no localized strings"
fi

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
    /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile AppIcon" "$APP/Contents/Info.plist" \
      || /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "$APP/Contents/Info.plist"
else
    echo "==> WARNING: iconutil failed - app will have no icon"
fi
rm -rf "$TMPBASE"

printf 'APPL????' > "$APP/Contents/PkgInfo"

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
