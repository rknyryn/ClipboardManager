# Clipboard Manager

A modern, efficient clipboard manager for macOS built with SwiftUI. This application helps you manage your clipboard history with a clean and user-friendly interface.

## Features

- 📋 Real-time clipboard monitoring
- 🔍 Search through clipboard history
- ⭐️ Favorite important items
- 🗑️ Delete unwanted entries
- 👆 Quick copy with single click
- 🔄 Automatic history management
- 🖥️ Menu bar integration
- 🎨 Modern SwiftUI interface

## System Requirements

- macOS 15.4 or later
- Swift 5.0+
- Xcode 16.3+

## Installation

1. Clone the repository
2. Open `clipboard_app.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

## Architecture

The application follows the MVVM (Model-View-ViewModel) architecture pattern:

### Models
- `ClipboardItem`: Represents a clipboard entry with properties for content, favorites, and timestamps

### Views
- `MainView`: The primary interface showing the clipboard history and search
- `ClipboardRowView`: Individual row component for clipboard items

### ViewModels
- `ClipboardViewModel`: Manages clipboard monitoring, data filtering, and clipboard operations

## Features in Detail

### Clipboard Monitoring
- Continuously monitors system clipboard for changes
- Updates in real-time (1-second interval)
- Prevents duplicate entries

### Search Functionality
- Real-time search through clipboard history
- Case-insensitive search
- Instant filtering as you type

### Item Management
- Favorite important items for quick access
- Delete unwanted entries
- One-click copy back to clipboard
- Items sorted by favorites and timestamp

### User Interface
- Clean, minimal design
- Menu bar integration for easy access
- Hover effects for better interaction
- Visual feedback on actions

## Privacy & Security

The application runs in a sandboxed environment and requires the following entitlements:
- App Sandbox
- Read-only access to user-selected files

## Development

The project is built using:
- SwiftUI for the user interface
- Combine framework for reactive programming
- AppKit integration for clipboard operations

## License

This project is proprietary software. All rights reserved.

## Author

Created by [Kaan Yarayan](https://github.com/rknyryn) (2025)
