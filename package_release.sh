#!/bin/bash
set -e

# ==============================================================================
# Awake! v1.0.0 Release Packaging Script
# Generates:
#   1. Awake-v1.0.0.dmg (Custom background, icon layout, /Applications symlink)
#   2. Awake-v1.0.0.zip (Optimized for GitHub Releases)
# Copies DMG to Desktop and outputs checksums.
# ==============================================================================

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

VERSION="1.0.0"
APP_NAME="Awake!"
APP_BUNDLE="$DIR/Awake!.app"
RELEASE_DIR="$DIR/build/releases"
DESKTOP_DIR="$HOME/Desktop"

echo "=========================================================="
echo " Packaging $APP_NAME v$VERSION for Release"
echo "=========================================================="

# 1. Build release app bundle
echo "==> [1/5] Building $APP_NAME Release bundle..."
"$DIR/build.sh"

# 2. Prepare Release Directory
echo "==> [2/5] Preparing output directory..."
mkdir -p "$RELEASE_DIR"

# 3. Ensure DMG background exists
echo "==> [3/5] Checking DMG background artwork..."
if [ ! -f "$DIR/Resources/dmg_background.png" ]; then
    echo "    Generating Retina DMG background..."
    swift "$DIR/Resources/make_dmg_bg.swift" "$DIR/Resources/dmg_background.png"
fi

# 4. Create DMG
DMG_OUT="$RELEASE_DIR/Awake-v$VERSION.dmg"
echo "==> [4/5] Creating disk image (DMG)..."

STAGING_DIR="$(mktemp -d /tmp/awake_pkg_staging.XXXXXX)"
cp -R "$APP_BUNDLE" "$STAGING_DIR/"

if command -v create-dmg >/dev/null 2>&1; then
    echo "    Using create-dmg with custom Finder layout..."
    create-dmg \
      --volname "Awake! v$VERSION" \
      --volicon "$DIR/Resources/AppIcon.icns" \
      --background "$DIR/Resources/dmg_background.png" \
      --window-pos 200 120 \
      --window-size 660 400 \
      --icon-size 128 \
      --text-size 13 \
      --icon "Awake!.app" 180 190 \
      --hide-extension "Awake!.app" \
      --app-drop-link 480 190 \
      --overwrite \
      "$DMG_OUT" \
      "$STAGING_DIR"
else
    echo "    create-dmg not found, creating clean DMG using hdiutil..."
    ln -s /Applications "$STAGING_DIR/Applications"
    rm -f "$DMG_OUT"
    hdiutil create -volname "Awake! v$VERSION" -srcfolder "$STAGING_DIR" -ov -format UDZO "$DMG_OUT"
fi

rm -rf "$STAGING_DIR"

# 5. Create ZIP for GitHub Releases
ZIP_OUT="$RELEASE_DIR/Awake-v$VERSION.zip"
echo "==> [5/5] Creating GitHub Release ZIP..."
rm -f "$ZIP_OUT"
ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ZIP_OUT"

# 6. Copy DMG to Desktop
echo "==> Copying DMG to Desktop ($DESKTOP_DIR)..."
cp -f "$DMG_OUT" "$DESKTOP_DIR/Awake-v$VERSION.dmg"

# 7. Checksums
echo "==> Generating SHA-256 checksums..."
cd "$RELEASE_DIR"
shasum -a 256 "Awake-v$VERSION.dmg" "Awake-v$VERSION.zip" > checksums.txt
cat checksums.txt

echo ""
echo "=========================================================="
echo " 🎉 Release packaging complete!"
echo " DMG:     $DMG_OUT"
echo " Desktop: $DESKTOP_DIR/Awake-v$VERSION.dmg"
echo " ZIP:     $ZIP_OUT"
echo "=========================================================="
