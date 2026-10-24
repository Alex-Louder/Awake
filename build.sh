#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

echo "==> Compilando Awake! (Release)..."
swift build -c release

APP_DIR="$DIR/Awake!.app"
echo "==> Empaquetando Awake!.app..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$DIR/.build/release/Awake" "$APP_DIR/Contents/MacOS/Awake"

cat << 'EOF' > "$APP_DIR/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Awake</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.playlouder.Awake</string>
    <key>CFBundleName</key>
    <string>Awake!</string>
    <key>CFBundleDisplayName</key>
    <string>Awake!</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.1.0</string>
    <key>CFBundleVersion</key>
    <string>2.1.0</string>
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

if [ -f "/tmp/AwakeAppIcon.icns" ]; then
    cp "/tmp/AwakeAppIcon.icns" "$APP_DIR/Contents/Resources/AppIcon.icns"
fi

echo "==> Firmando aplicación localmente..."
codesign --force --deep -s - "$APP_DIR"

echo "==> Awake!.app compilada y lista en: $APP_DIR"
