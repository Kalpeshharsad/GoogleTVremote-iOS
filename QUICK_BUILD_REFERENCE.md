# Quick Reference: Building Unsigned iOS Apps

## For Local builds (macOS with Xcode)

```bash
# 1. Make build script executable
chmod +x build-unsigned.sh

# 2. Run build
./build-unsigned.sh

# 3. Find your IPA
open build/output/
```

**Output**: `build/output/GoogleTVRemote-unsigned.ipa`

---

## For Cloud builds (Codemagic.io, no developer account needed)

```bash
# 1. Create GitHub repository
git remote add origin https://github.com/YOUR_USERNAME/RemoteControlApp-iOS.git
git push -u origin main

# 2. Sign up at codemagic.io
# 3. Connect GitHub repository
# 4. Select ios-unsigned-build workflow
# 5. Download IPA from artifacts
```

---

## Installing on TrollStore

### Via Direct Installation
1. Connect iPhone via USB
2. Open TrollStore app
3. Tap "+" → Select IPA file
4. Confirm installation

### Via Airdrop/File Transfer
```bash
# Transfer to your device
airdrop build/output/GoogleTVRemote-unsigned.ipa

# Or via scp (if SSH enabled)
scp build/output/GoogleTVRemote-unsigned.ipa user@device:/tmp/
```

---

## Build Settings for Unsigned Apps

These must be set in Xcode for unsigned builds:

| Setting | Value |
|---------|-------|
| Code Sign Identity | Leave empty (`-`) |
| Code Signing Required | `NO` |
| Code Signing Style | Automatic |
| Development Team | Leave empty (None) |
| Provisioning Profile | Leave empty |
| Code Signing Entitlements | Leave empty |

---

## Troubleshooting Unsigned Builds

### Build command reference

#### Custom build (without script):
```bash
xcodebuild \
  -workspace GoogleTVRemote.xcworkspace \
  -scheme GoogleTVRemote \
  -configuration Release \
  -arch arm64 \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_ENTITLEMENTS="" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  DEVELOPMENT_TEAM="" \
  -derivedDataPath build/DerivedData
```

#### Check if IPA is actually unsigned:
```bash
# Should output nothing or Code Resources with no signature
unzip -l build/output/GoogleTVRemote-unsigned.ipa | grep -i signature
```

#### Verify app executable:
```bash
unzip -q build/output/GoogleTVRemote-unsigned.ipa
file Payload/GoogleTVRemote.app/GoogleTVRemote
# Should output: Mach-O 64-bit executable arm64
```

---

## Project Files

| File | Purpose |
|------|---------|
| `codemagic.yaml` | Cloud build configuration for Codemagic.io |
| `build-unsigned.sh` | Local build script |
| `setup-xcode-project.sh` | Xcode project setup helper |
| `UNSIGNED_BUILD_GUIDE.md` | Detailed build and installation guide |
| `README.md` | Project overview and features |

---

## Useful Commands

```bash
# Clean build artifacts
rm -rf build/

# Clean Xcode cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Check Xcode version
xcodebuild -version

# List available SDKs
xcodebuild -showsdks

# Get iPhone device identifiers
xcrun xctrace list devices

# Install via AltStore CLI
AltServer --ip <device-ip> build/output/GoogleTVRemote-unsigned.ipa
```

---

## Next Steps After Building

1. ✅ Build unsigned IPA
2. ✅ Transfer to iPhone (TrollStore, Airdrop, etc.)
3. ✅ Install via TrollStore
4. ✅ Grant permissions (Local Network access)
5. ✅ Add Google TV device connection
6. ✅ Start remote control

---

## Important Notes

⚠️ **Security**:
- Unsigned apps work only on jailbroken devices with TrollStore
- ADB communication is unencrypted - use only on trusted networks
- No sandboxing restrictions on unsigned apps

✅ **No Developer Account Needed**:
- Build locally with Xcode (free tier)
- Build in cloud with Codemagic.io (free builds available)
- No Apple Developer account required

📱 **Device Requirements**:
- Jailbroken iPhone with TrollStore
- iOS 14.0 or later
- Local network access to Google TV
