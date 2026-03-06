# Unsigned Build Guide for TrollStore

This guide explains how to set up and build the Google TV Remote app as an unsigned IPA for installation on your jailbroken iPhone using TrollStore.

## Prerequisites

- macOS with Xcode 13.0+ installed
- Swift 5.5+
- Command line tools: `xcode-select --install`
- Jailbroken iPhone with TrollStore installed
- USB connection to your iPhone

## Building Locally

### Step 1: Create Xcode Project

Since this project is Swift-based, you need to create an Xcode project first:

1. **Option A: Using Xcode (Recommended)**
   ```bash
   # Open Xcode
   open -a Xcode
   
   # File > New > Project
   # Choose "App"
   # Product Name: GoogleTVRemote
   # Team: None (Important!)
   # Organization Identifier: com.unsigned.googletv
   # Language: Swift
   # Interface: SwiftUI
   ```

2. **Option B: Command Line**
   ```bash
   # Create the Xcode project structure
   cd /path/to/RemoteControlApp-iOS
   xcode-select --install
   ```

### Step 2: Add Source Files

Copy the existing source files into the Xcode project:

```bash
# The project structure should look like:
GoogleTVRemote/
├── GoogleTVRemoteApp.swift
├── ContentView.swift
├── Models/
│   └── ADBConnection.swift
├── ViewModels/
│   └── RemoteViewModel.swift
├── Views/
│   ├── ConnectionView.swift
│   └── RemoteControlView.swift
├── Network/
│   └── ADBClient.swift
├── Assets/
└── Info.plist
```

### Step 3: Configure Project for Unsigned Build

In Xcode:

1. **Select Project** → **GoogleTVRemote** (top level)
2. **Target** → **GoogleTVRemote**
3. **Build Settings** and search for:
   - **Code Sign Identity**: Leave empty (or set to `-`)
   - **Code Signing Required**: Set to `NO`
   - **Code Signing Style**: Leave as default
   - **Development Team**: Leave empty (no team)
   - **Provisioning Profile**: Leave empty

### Step 4: Build Using Script

Run the build script to create an unsigned IPA:

```bash
chmod +x build-unsigned.sh
./build-unsigned.sh
```

The unsigned IPA will be created at: `build/output/GoogleTVRemote-unsigned.ipa`

## Building with Codemagic.io

### Setup Instructions

1. **Push to GitHub**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/RemoteControlApp-iOS.git
   git push -u origin main
   ```

2. **Create Codemagic Account**
   - Visit [codemagic.io](https://codemagic.io)
   - Sign up and connect your GitHub account

3. **Add Your Repository**
   - Click "Apps" → "New App"
   - Select your GitHub repository
   - Choose "GoogleTVRemote.xcworkspace" (or .xcodeproj)

4. **Build Configuration**
   - Codemagic will auto-detect builds from `codemagic.yaml`
   - Select the `ios-unsigned-build` workflow
   - Click "Start New Build"

5. **Download Artifacts**
   - Wait for build to complete
   - Download the unsigned IPA from artifacts section

## Installing on TrollStore

### Method 1: TrollStore on iPhone

1. **Install TrollStore** (if not already installed)
   - Your iPhone must be jailbroken with a jailbreak supporting TrollStore
   - Download TrollStore from: https://github.com/MsRCAtQmqr/TrollStore
   - Follow installation instructions

2. **Transfer IPA**
   - Connect iPhone via USB to Mac
   - Airdrop or email the IPA to yourself
   - Or use: `scp build/output/GoogleTVRemote-unsigned.ipa user@device:/tmp/`

3. **Install via TrollStore**
   - Open TrollStore app on iPhone
   - Tap "+" icon to install app
   - Browse to the unsigned IPA file
   - Tap "Install"
   - Confirm installation

### Method 2: Using iOS App Installer (Terminal Method)

```bash
# Mount the DeveloperDiskImage if needed
# Then use libimobiledevice:

# Install via device directly
ideviceinstaller -i build/output/GoogleTVRemote-unsigned.ipa
```

### Method 3: Using AltStore (Alternative)

If your device supports AltStore:

1. Install AltStore on iPhone
2. Open AltStore → "My Apps"
3. Tap "+" to add app
4. Select the unsigned IPA
5. Grant permissions when prompted

## Using the App

Once installed on your iPhone:

1. **Grant Network Permissions**
   - Settings → Google TV Remote → Local Network: Allow

2. **Connect to Google TV**
   - Enable ADB debugging on your TV
   - Get TV IP address from Developer Options
   - Add device in app with IP and name
   - Tap to connect

3. **Control Your TV**
   - Use the remote interface to control your Google TV
   - All buttons are fully functional

## Troubleshooting

### Build Fails with Code Signing Error

**Solution**: Ensure build settings have:
- `CODE_SIGN_IDENTITY=` (empty)
- `CODE_SIGNING_REQUIRED=NO`
- `PROVISIONING_PROFILE_SPECIFIER=` (empty)

### "Cannot Verify Developer" Error

This should not appear with unsigned/TrollStore installation since TrollStore handles app verification.

### IPA Installation Fails on iPhone

- Verify the IPA is actually unsigned: `unzip -l GoogleTVRemote-unsigned.ipa | grep -i "CodeResources"`
- If `CodeResources` is present, the app may be signed
- Rebuild using the script with proper settings

### App Crashes on Launch

1. Check system requirements (iOS 14.0+)
2. Verify all permissions granted
3. Check Xcode console for error logs
4. Try reinstalling via TrollStore

### Network Connection Issues

- Ensure iPhone and Google TV are on same network
- Verify ADB port 5555 is open on TV
- Check TV developer options are enabled
- Try connecting to TV manually first

## Build Cache and Optimization

To speed up subsequent builds:

```bash
# Use cached derivedData
./build-unsigned.sh

# Or manually clean if needed
rm -rf build/DerivedData
```

## Security Notes

⚠️ **Important Security Considerations**:

- This app communicates over **unencrypted ADB protocol**
- Only use on **trusted networks** (your home WiFi)
- The unsigned version has **no app sandboxing restrictions**
- Network communication is not encrypted
- For production use, implement TLS/SSL encryption

## Advanced: Custom Build Parameters

To customize the build, edit `codemagic.yaml`:

```yaml
# Modify these Environment Variables:
environment:
  ios: latest              # Xcode version
  xcode: latest           # Can be specific version like "14.0"
  cocoapods: default      # CocoaPods version

# Modify these Build Flags:
xcodebuild \
  -configuration Release  # Change to Debug for development
  -arch arm64            # Or add arm64e for A12+ devices
```

## Additional Resources

- [TrollStore GitHub](https://github.com/MsRCAtQmqr/TrollStore)
- [Codemagic Documentation](https://docs.codemagic.io/)
- [Apple Xcode Build Guide](https://developer.apple.com/documentation/xcode)
- [ADB Protocol Reference](https://android.googlesource.com/platform/packages/modules/adb/+/master/docs/user_documentation.md)

## Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review Codemagic build logs
3. Check Xcode console output
4. Verify all build settings are correct
5. Try building locally first before using Codemagic
