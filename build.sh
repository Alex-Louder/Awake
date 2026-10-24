#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

echo "==> Compilando ClamAwake (Release)..."
swift build -c release

APP_DIR="$DIR/ClamAwake.app"
echo "==> Empaquetando ClamAwake.app..."
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$DIR/.build/release/ClamAwake" "$APP_DIR/Contents/MacOS/ClamAwake"

cat << 'EOF' > "$APP_DIR/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ClamAwake</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.playlouder.ClamAwake</string>
    <key>CFBundleName</key>
    <string>ClamAwake</string>
    <key>CFBundleDisplayName</key>
    <string>ClamAwake</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
EOF

if [ -f "/tmp/AppIcon.iconset/icon_512x512@2x.png" ]; then
    iconutil -c icns /tmp/AppIcon.iconset -o "$APP_DIR/Contents/Resources/AppIcon.icns"
fi

echo "==> Firmando aplicación localmente..."
codesign --force --deep -s - "$APP_DIR"

echo "==> ClamAwake.app compilada y lista en: $APP_DIR"
