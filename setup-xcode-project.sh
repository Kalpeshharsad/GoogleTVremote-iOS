#!/bin/bash
# Script to create an Xcode project structure for unsigned builds
# This helps set up the project without using Xcode GUI

set -e

echo "=== Setting up Xcode Project Structure ==="
echo ""

PROJECT_NAME="GoogleTVRemote"
PROJECT_DIR="."

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
  echo "Error: Package.swift not found. Run this script from the project root directory."
  exit 1
fi

echo "Step 1: Creating Xcode project layout..."

# Create standard directories if they don't exist
mkdir -p "${PROJECT_NAME}/Supporting Files"

# Create Xcode project bundle structure
XCODEPROJ="${PROJECT_NAME}.xcodeproj"
if [ ! -d "$XCODEPROJ" ]; then
  mkdir -p "$XCODEPROJ"
  echo "✓ Created $XCODEPROJ"
else
  echo "✓ $XCODEPROJ already exists"
fi

# Create project.pbxproj structure (basic)
if [ ! -f "$XCODEPROJ/project.pbxproj" ]; then
  cat > "$XCODEPROJ/project.pbxproj" << 'EOF'
// !$*UTF8*$!
{
  archiveVersion = 1;
  classes = {
  };
  objectVersion = 56;
  objects = {
    /* Build configuration */
    DA1 /* Release */ = {
      isa = XCBuildConfiguration;
      buildSettings = {
        ALWAYS_SEARCH_USER_PATHS = NO;
        CLANG_ANALYZER_NONNULL = YES;
        CLANG_CXX_LANGUAGE_DIALECT = "c++17";
        CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
        CODE_SIGN_IDENTITY = "";
        CODE_SIGNING_REQUIRED = NO;
        CODE_SIGN_ENTITLEMENTS = "";
        PROVISIONING_PROFILE_SPECIFIER = "";
        CODE_SIGN_STYLE = Automatic;
        DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
        ENABLE_NS_ASSERTIONS = NO;
        GCC_NO_COMMON_BLOCKS = YES;
        GCC_OPTIMIZATION_LEVEL = 3;
        GCC_PREPROCESSOR_DEFINITIONS = "$(inherited)";
        GCC_WARN_ABOUT_RETURN_TYPE = YES;
        GCC_WARN_SHADOW = YES;
        GCC_WARN_UNDECLARED_SELECTOR = YES;
        GCC_WARN_UNINITIALIZED_AUTOS = YES;
        GCC_WARN_UNUSED_VARIABLE = YES;
        IPHONEOS_DEPLOYMENT_TARGET = 14.0;
        MTL_ENABLE_DEBUG_INFO = NO;
        MTL_FAST_MATH = YES;
        OTHER_CFLAGS = ( "-Wall", "-Wextra" );
        PRODUCT_BUNDLE_IDENTIFIER = "com.unsigned.googletv-remote";
        PRODUCT_NAME = "$(TARGET_NAME)";
        STRIP_INSTALLED_PRODUCT = NO;
        SWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";
        TARGETED_DEVICE_FAMILY = "1,2";
      };
      name = Release;
    };
    DA2 /* Debug */ = {
      isa = XCBuildConfiguration;
      buildSettings = {
        ALWAYS_SEARCH_USER_PATHS = NO;
        CLANG_ANALYZER_NONNULL = YES;
        CLANG_CXX_LANGUAGE_DIALECT = "c++17";
        CODE_SIGN_IDENTITY = "";
        CODE_SIGNING_REQUIRED = NO;
        CODE_SIGN_ENTITLEMENTS = "";
        CODE_SIGN_STYLE = Automatic;
        COPY_PHASE_STRIP = NO;
        DEBUG_INFORMATION_FORMAT = dwarf;
        ENABLE_STRICT_OBJC_MSGSEND = YES;
        ENABLE_TESTABILITY = YES;
        GCC_DYNAMIC_NO_PIC = NO;
        GCC_NO_COMMON_BLOCKS = YES;
        GCC_OPTIMIZATION_LEVEL = 0;
        GCC_PREPROCESSOR_DEFINITIONS = "$(inherited) DEBUG=1";
        GCC_SYMBOLS_PRIVATE_EXTERN = NO;
        GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
        GCC_WARN_ABOUT_RETURN_TYPE = YES;
        GCC_WARN_INCOMPLETE_PROTOCOL = YES;
        GCC_WARN_SHADOW = YES;
        GCC_WARN_UNDECLARED_SELECTOR = YES;
        GCC_WARN_UNINITIALIZED_AUTOS = YES;
        GCC_WARN_UNUSED_VARIABLE = YES;
        IPHONEOS_DEPLOYMENT_TARGET = 14.0;
        MTL_ENABLE_DEBUG_INFO = YES;
        MTL_FAST_MATH = YES;
        ONLY_ACTIVE_ARCH = YES;
        OTHER_CFLAGS = ( "-Wall", "-Wextra" );
        PRODUCT_BUNDLE_IDENTIFIER = "com.unsigned.googletv-remote";
        PRODUCT_NAME = "$(TARGET_NAME)";
        PROVISIONING_PROFILE_SPECIFIER = "";
        SDKROOT = iphoneos;
        SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
        SWIFT_OPTIMIZATION_LEVEL = "-Onone";
        TARGETED_DEVICE_FAMILY = "1,2";
      };
      name = Debug;
    };
  };
  rootObject = DA0;
}
EOF
  echo "✓ Created basic project configuration"
else
  echo "ℹ project.pbxproj already exists"
fi

echo ""
echo "Step 2: Creating workspace files..."

# Create xcworkspace structure
XCWORKSPACE="${PROJECT_NAME}.xcworkspace"
if [ ! -d "$XCWORKSPACE" ]; then
  mkdir -p "$XCWORKSPACE/xcshareddata"
  
  cat > "$XCWORKSPACE/contents.xcworkspacedata" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Workspace version = "1.0">
   <FileRef location = "group:${PROJECT_NAME}.xcodeproj">
   </FileRef>
</Workspace>
EOF
  echo "✓ Created $XCWORKSPACE"
else
  echo "ℹ $XCWORKSPACE already exists"
fi

echo ""
echo "Step 3: Creating launch screen storyboard..."

STORYBOARDS_DIR="${PROJECT_NAME}/LaunchScreen.storyboardc"
mkdir -p "$STORYBOARDS_DIR"

echo "✓ Storyboards directory prepared"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Manual Steps in Xcode:"
echo "1. Open $XCWORKSPACE in Xcode"
echo "2. Add GoogleTVRemote folder to Build Sources"
echo "3. Set Team to 'None' in Build Settings"
echo "4. Ensure Code Signing settings are set to:"
echo "   - Code Sign Identity: (empty)"
echo "   - Code Signing Required: NO"
echo "   - Provisioning Profile: (empty)"
echo ""
echo "To build unsigned IPA:"
echo "  chmod +x build-unsigned.sh"
echo "  ./build-unsigned.sh"
echo ""
