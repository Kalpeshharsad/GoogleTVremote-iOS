# GoogleTV Remote Control iOS App

Unsigned iOS remote control app for Google TV with ADB network connection. Builds without Developer account for TrollStore/jailbroken installation.

## Key Files for Unsigned Builds

- **codemagic.yaml** - Cloud build configuration for Codemagic.io
- **build-unsigned.sh** - Local build script for creating unsigned IPA
- **UNSIGNED_BUILD_GUIDE.md** - Complete guide for building and installing on TrollStore

## Project Setup Checklist

- [x] Create copilot-instructions.md file
- [x] Scaffold iOS project structure
- [x] Create Swift source files
- [x] Create ADB connection logic
- [x] Create remote control UI
- [x] Create project configuration files
- [x] Verify project compiles
- [x] Create README documentation
- [x] Create unsigned build script
- [x] Create Codemagic configuration
- [x] Create comprehensive build guide

## Project Overview

This is a Swift/SwiftUI-based iOS app that provides remote control functionality for Google TV devices via ADB (Android Debug Bridge) network connection.

## Development Guidelines

- Target iOS 14.0+
- Use SwiftUI for UI components
- Network communication via ADB protocol
- No external dependencies for core functionality
