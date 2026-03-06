# Google TV Remote Control iOS App

An unsigned iOS remote control application for Google TV devices using ADB (Android Debug Bridge) network connection over TCP/IP.

## Features

- **ADB over Network** - Connect to Google TV devices via TCP/IP without USB cables
- **Full Remote Control** - Control all major remote functions:
  - Navigation (Up, Down, Left, Right, Enter)
  - Power control
  - Volume and mute
  - Channel up/down
  - Media playback (Play/Pause, Next, Previous)
  - Home, Back, and Menu buttons
- **Saved Connections** - Store multiple device connections for quick access
- **Clean SwiftUI Interface** - Modern iOS design with intuitive controls
- **iOS 14.0+** - Works on all modern iOS devices

## Project Structure

```
GoogleTVRemote/
├── GoogleTVRemoteApp.swift       # Main app entry point
├── ContentView.swift              # Root view with connection/remote logic
├── Models/
│   └── ADBConnection.swift        # Data models for device connection and remote keys
├── ViewModels/
│   └── RemoteViewModel.swift      # State management and control logic
├── Views/
│   ├── ConnectionView.swift       # Device connection UI
│   └── RemoteControlView.swift    # Remote control interface
├── Network/
│   └── ADBClient.swift            # ADB protocol implementation
├── Assets/                        # App assets (empty, ready for icons/images)
└── Info.plist                     # iOS app configuration
```

## Prerequisites

### Device Setup (Google TV / Android TV)

1. Enable ADB (Android Debug Bridge):
   - Go to **Settings** → **About**
   - Tap "Build Number" 7-10 times to enable Developer Mode
   - Go to **Settings** → **Developer Options**
   - Enable **ADB debugging**

2. Enable TCP/IP Debugging (instead of USB):
   - In Developer Options, enable **Network debugging** or **ADB over Network**
   - Note the device's IP address (displayed in Developer Options)
   - Default ADB port is `5555`

### Development Environment

- Xcode 13.0 or later
- iOS 14.0+ deployment target
- macOS 11.0 or later
- Swift 5.5+

## Building and Running

### Using Xcode

1. Open the project in Xcode:
   ```bash
   open GoogleTVRemote.xcodeproj
   ```

2. Select your target device or simulator

3. Build and run:
   - Press `Cmd + R` or click the Run button
   - Select your iOS device from the destination menu

### Using SwiftUI Preview

For UI development, you can use SwiftUI previews:
1. Open any View file (e.g., `RemoteControlView.swift`)
2. Click the "Preview" button in Xcode
3. Test the UI layout and interactions

## Using the App

### Adding a Device Connection

1. Launch the app
2. Tap the **"+" button** in the top-right corner
3. Enter the device name and IP address
4. Tap **"Save Connection"**

### Connecting to a Device

1. Select a saved device from the list
2. The app will establish an ADB connection
3. Once connected, the remote control interface will appear

### Using the Remote Control

The remote provides access to:

- **Navigation Pad** - Move up/down/left/right and select
- **Power Button** - Turn device on/off
- **Volume Controls** - Adjust volume and mute
- **Channel Controls** - Switch channels
- **Media Controls** - Play/pause, next, previous
- **Action Buttons** - Home, back, and menu

## ADB Protocol Implementation

The app implements the ADB protocol for TCP/IP communication:

- **Message Format**: `<4-byte hex size><UTF-8 encoded command>`
- **Supported Commands**:
  - `shell:<command>` - Execute shell commands
  - `input keyevent <keycode>` - Send key events
  - `input text '<text>'` - Enter text

### Common Android Key Codes

- `3` - Home
- `4` - Back
- `19-22` - Navigation (Up, Down, Left, Right)
- `23` - Enter/OK
- `26` - Power
- `24-25` - Volume Up/Down
- `82` - Menu
- `164` - Mute

## Architecture

### ADBClient
Handles low-level ADB protocol communication:
- TCP socket management
- Message serialization and deserialization
- Command execution and error handling
- Connection state tracking

### RemoteViewModel
Manages application state and business logic:
- Device connection management
- Saved connections persistence (UserDefaults)
- Remote control command dispatching
- Error handling and status updates

### SwiftUI Views
- **ContentView** - Routing between connection and remote views
- **ConnectionView** - Device discovery and management
- **RemoteControlView** - Full remote control interface

## Network Communication

The app uses standard iOS networking:
- `Stream` API for TCP socket communication
- Non-blocking I/O for responsive UI
- Automatic stream scheduling on run loop

## Error Handling

The app provides user-friendly error messages for:
- Connection failures
- Network timeouts
- Protocol errors
- Invalid device addresses

## Security Considerations

⚠️ **Important**: 
- This is an **unsigned app** for development purposes
- ADB communication over network is unencrypted
- Only use on trusted networks
- Device and app are in developer mode

For production use, consider:
- Implementing SSL/TLS encryption
- Adding device authentication
- Code signing for app distribution

## Troubleshooting

### Connection Fails
- Verify the IP address is correct
- Ensure the device is on the same network
- Check that ADB debugging is enabled on the device
- Verify the device isn't blocking port 5555

### Commands Not Working
- Confirm the device accepts shell commands
- Check device is awake and responsive
- Try sending a simple command like "input keyevent 3" (Home)

### App Crashes
- Check Xcode console for error messages
- Verify all Swift syntax is correct
- Ensure iOS 14.0+ is installed on test device

## Configuration

Edit `build.config.swift` to customize:
- Bundle identifier
- Minimum iOS version
- ADB port number
- Connection timeout values

## Future Enhancements

- [ ] Voice input support
- [ ] Custom button mapping
- [ ] Device pairing with security codes
- [ ] App launcher integration
- [ ] Movie/playback progress tracking
- [ ] Settings UI customization
- [ ] Multi-device simultaneous control
- [ ] Gesture support (swipe controls)

## License

This project is provided as-is for development and educational purposes.

## Contributing

To contribute improvements:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with your enhancements

## Support

For issues or questions:
1. Check the Troubleshooting section
2. Verify ADB is properly configured on your device
3. Review Xcode console output for error details
4. Check network connectivity and firewall settings

---

**Note**: This app requires a Google TV or Android TV device with:
- Android 5.0 or later
- ADB enabled in Developer Options
- Network access on the same WiFi/network
