// Build configuration for Xcode project
// This file contains build settings and project configuration

import Foundation

// Project Settings
public struct ProjectConfig {
    public static let bundleIdentifier = "com.yourcompany.googletv-remote"
    public static let minimumOSVersion = "14.0"
    public static let marketingVersion = "1.0"
    public static let buildNumber = "1"
    
    // Network
    public static let defaultADBPort = 5555
    public static let connectionTimeout = 30.0
}
