#!/bin/bash
# Script to build unsigned iOS app for TrollStore installation
# Usage: ./build-unsigned.sh

set -e

echo "=== Google TV Remote - Unsigned Build Script ==="
echo ""

# Configuration
BUILD_DIR="build"
DERIVED_DATA="$BUILD_DIR/DerivedData"
BUILD_PRODUCTS="$DERIVED_DATA/Build/Products/Release-iphoneos"
OUTPUT_DIR="$BUILD_DIR/output"
APP_NAME="GoogleTVRemote"
IPA_NAME="${APP_NAME}-unsigned"

# Create directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$DERIVED_DATA"

echo "Step 1: Cleaning previous builds..."
rm -rf "$DERIVED_DATA"
rm -rf Payload
echo "✓ Cleaned"
echo ""

echo "Step 2: Building for iOS (ARM64) without code signing..."
xcodebuild \
  -scheme "${APP_NAME}" \
  -destination 'generic/platform=iOS' \
  -configuration Release \
  -derivedDataPath "$DERIVED_DATA" \
  -sdk iphoneos \
  -IPHONEOS_DEPLOYMENT_TARGET 15.0 \
  -SWIFT_VERSION 5.0 \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_ENTITLEMENTS="" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  DEVELOPMENT_TEAM="" \
  -quiet

if [ $? -eq 0 ]; then
  echo "✓ Build successful"
else
  echo "✗ Build failed"
  exit 1
fi
echo ""

echo "Step 3: Creating unsigned IPA structure..."
if [ -d "$BUILD_PRODUCTS/${APP_NAME}.app" ]; then
  mkdir -p Payload
  cp -r "$BUILD_PRODUCTS/${APP_NAME}.app" Payload/
  echo "✓ Payload directory created"
else
  echo "✗ App bundle not found at $BUILD_PRODUCTS/${APP_NAME}.app"
  exit 1
fi
echo ""

echo "Step 4: Creating IPA archive..."
zip -r -q "$OUTPUT_DIR/${IPA_NAME}.ipa" Payload/
rm -rf Payload

if [ -f "$OUTPUT_DIR/${IPA_NAME}.ipa" ]; then
  IPA_SIZE=$(du -h "$OUTPUT_DIR/${IPA_NAME}.ipa" | cut -f1)
  echo "✓ IPA created successfully"
  echo "  File: $OUTPUT_DIR/${IPA_NAME}.ipa"
  echo "  Size: $IPA_SIZE"
else
  echo "✗ Failed to create IPA"
  exit 1
fi
echo ""

echo "=== Build Complete ==="
echo ""
echo "Next steps for TrollStore installation:"
echo "1. Connect your jailbroken iPhone via USB"
echo "2. Open TrollStore on your device"
echo "3. Tap 'Install' and select: $OUTPUT_DIR/${IPA_NAME}.ipa"
echo ""
echo "Or use AltStore/AnyThing to install:"
echo "   - Copy the IPA to your device"
echo "   - Open it with the installer app"
echo ""
