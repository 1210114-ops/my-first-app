#!/bin/bash

# AI Terminal Pro - Build and Package Script
# This script builds the iOS app and packages it as .ipa

set -e

PROJECT_NAME="AITerminalPro"
BUILD_DIR="./build"
PAYLOAD_DIR="./Payload"
IPA_NAME="AI-Terminal-Pro-Release.ipa"

echo "================================"
echo "AI Terminal Pro Build Script"
echo "================================"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR" "$PAYLOAD_DIR" "$IPA_NAME"

# Create Xcode project from Package.swift
echo "📦 Creating Xcode project..."
xcode-select --install 2>/dev/null || true

# Build for iPhone OS
echo "🔨 Building for iPhone OS (Release)..."
xcodebuild -scheme "$PROJECT_NAME" \
           -sdk iphoneos \
           -configuration Release \
           -derivedDataPath "$BUILD_DIR" \
           -jobs $(sysctl -n hw.ncpu) \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO \
           2>&1 | tail -20

# Check if build succeeded
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create IPA structure
echo "📦 Creating IPA structure..."
mkdir -p "$PAYLOAD_DIR"

# Find the built .app bundle
APP_PATH=$(find "$BUILD_DIR" -name "*.app" -type d | grep -i release | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Could not find .app bundle!"
    exit 1
fi

echo "Found app: $APP_PATH"
cp -R "$APP_PATH" "$PAYLOAD_DIR/"

# Create IPA (which is essentially a ZIP file)
echo "📦 Creating IPA file..."
cd "$PAYLOAD_DIR"
zip -r -q "../$IPA_NAME" .
cd ..

# Cleanup
rm -rf "$PAYLOAD_DIR"

echo ""
echo "================================"
echo "✅ Build Complete!"
echo "================================"
echo "IPA File: $IPA_NAME"
echo "File Size: $(ls -lh "$IPA_NAME" | awk '{print $5}')"
echo ""
echo "📱 To sideload to iPhone:"
echo "  1. Connect iPhone via USB"
echo "  2. Open Xcode > Window > Devices and Simulators"
echo "  3. Drag $IPA_NAME onto your device"
echo ""
echo "Or use Finder/iTunes on macOS:"
echo "  1. Connect iPhone"
echo "  2. Drag $IPA_NAME into the Apps section"
echo ""
