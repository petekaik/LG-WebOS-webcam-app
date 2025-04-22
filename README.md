# LG-WebOS-webcam-app

## Overview
This application is designed for LG WebOS to display webcam video feeds. It is optimized for LG OLED65C8 TVs and aims to minimize code complexity while avoiding the use of Node.js due to GenAI challenges with complex development setups. The app is built as a lightweight, single-page application using HTML, CSS, and JavaScript.

Technical specifications are in this file and list of features and user stories are stored in [documentation/requirements-specification.md](documentation/requirements-specification.md) document.

## Documentation
The following documentation files are available:
- [Requirements Specification](documentation/requirements-specification.md) - Detailed requirements and user stories
- [Development Log](documentation/development-log.md) - Chronological development history and decisions
- [Defect Log](documentation/defect-log.md) - Tracking of bugs, issues, and enhancements

## Technical Specification

### Target Platform
- **Device**: LG OLED65C8 TV
- **Operating System**: LG WebOS
- **WebOS Version**: Compatible with WebOS 4.0 and above (current version 4.4.3.-20)

### Development Approach
- **Framework**: None (pure HTML, CSS, and JavaScript) for the app, use latest spesifications compatible with target environment. Node.js and other build automation tools may be used in development environment.
- **Minimization of Complexity**: Keep it simple, stupid (KISS)
- **Single-Page Application**: All functionality is contained within a single `index.html` file. No dependencies to external reources such ass javascript or css files. Script and styling files may be packaged with the app so that the app can run without connection to internet.
- **Automation**: Use development agents and scritps to automate as much as possible from development, packaging and deployment of the app.

### Features
- **Webcam Feed Display**: Displays video feeds from configured webcams.
- **Grid View**: Shows multiple video feeds in a grid layout.
- **Full-Screen View**: Allows users to view a selected video feed in full-screen mode.
- **Navigation**: Supports 5-way navigation for remote controls.
- **Clock Integration**: Displays the current time using the WebOS `clock/getTime` API.
- **Error Logging**: Logs errors and messages in a dedicated log box.

### Key Technologies
- **HTML5**: For structuring the application.
- **CSS3**: For styling and responsive design.
- **JavaScript**: For application logic and WebOS API integration.
- **WebOS APIs**: Utilizes WebOS-specific APIs such as `luna://com.palm.systemservice` for clock functionality.

### File Structure
- `index.html`: Contains the entire application logic, styles, and structure.
- `webOSTVjs-1.2.10/`: Includes WebOS JavaScript libraries for API integration.
- `icon.png` and `largeIcon.png`: Icons for the application (largeIcon is for navigation menu and icon is for notifications).
- `appinfo.json`: Metadata for the WebOS application.
- `build_and_install.sh`: Script for building and installing the app.

### Design Principles
- **Simplicity**: Focus on a minimalistic design to ensure compatibility and ease of maintenance.
- **Performance**: Optimized for smooth performance on LG OLED65C8 TVs.
- **Compatibility**: Ensures compatibility with WebOS 4.0 and above.

### Future Development
- Focusing finalizing the basic functionality for now.

## Installation
1. Copy the project files to your development environment.
2. Use the `build_and_install.sh` script to package and install the app on your LG WebOS TV.
3. Launch the app from the TV's application menu.

## License
- This project is licensed under the Unlicense
- WebOS components/libraries are licensed under the Apache License 2.0.
