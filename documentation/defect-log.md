# Defect Log

This document serves as a record of all defects, issues, and enhancement requests identified during the development and testing of the LG-WebOS-webcam-app. Each entry includes a description, severity, status, and any additional notes for tracking purposes.

## Open Defects

### DEF-005: Grid View Thumbnail Loading Failure
- **Description**: Video preview thumbnails in grid view fail to load or display properly while the same streams play correctly in fullscreen mode.
- **Severity**: High
- **Status**: Open
- **Created**: 21 April 2025
- **Assigned To**: Development Team
- **Notes**: During UAT testing with two configured and enabled webcams, the grid view does not show video previews, but the fullscreen mode plays the streams correctly. This suggests an issue specific to the grid view rendering or resource allocation.
- **Steps to Reproduce**:
  1. Configure and enable two webcam feeds
  2. Launch the application
  3. Observe that grid view thumbnails don't load or display properly
  4. Select a webcam for fullscreen view and observe that it loads correctly

### DEF-006: Intermittent Video Stream Freezing
- **Description**: Video streams in the application randomly freeze or only one stream plays while others appear frozen, despite the source streams being active and accessible via other software like VLC.
- **Severity**: High
- **Status**: Open
- **Created**: 21 April 2025
- **Assigned To**: Development Team
- **Notes**: Stream playback behavior is inconsistent and unpredictable. Sometimes only one of two streams plays, and which one plays seems to vary randomly. Other times, both streams appear frozen. This occurs even when the streams are confirmed active using VLC player.
- **Steps to Reproduce**:
  1. Configure two active video streams (verified working in VLC)
  2. Open the application and observe the streams over 2-3 minutes
  3. Note that either one stream freezes while the other plays, both freeze, or they switch which one is active

### ENH-004: External JavaScript Video Playback Library Integration
- **Description**: Evaluate and integrate an external JavaScript video playback library to improve stream compatibility and reliability.
- **Severity**: Medium (Enhancement)
- **Status**: Open
- **Created**: 21 April 2025
- **Assigned To**: Technical Lead
- **Notes**: Native video stream playback capabilities in WebOS appear to be limited, causing reliability issues with HLS streams. Research and implement an alternative solution using a specialized JavaScript library (e.g., hls.js, video.js, or shaka-player) that might provide better compatibility and performance, especially for grid view thumbnails.
- **Investigation Points**:
  1. Identify JavaScript libraries compatible with WebOS browser environment
  2. Evaluate memory footprint and performance impact
  3. Test compatibility with our current stream formats
  4. Assess implementation complexity and resource requirements

## Enhancement Requests

## Resolved Defects

### DEF-001: Video Feed Sizing Issue
- **Description**: Video feeds may not properly size in the 2x2 grid on certain TV models.
- **Severity**: Medium
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 18 April 2025
- **Resolution**: Fixed by replacing CSS Grid with Flexbox layout and adding explicit sizing constraints to webcam containers. Added proper width/height calculations with gap consideration to ensure feeds display correctly in a 2x2 grid.

### DEF-002: Stream Loading Error Feedback
- **Description**: Minimal visual feedback when streams fail to load.
- **Severity**: Low
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 18 April 2025
- **Resolution**: Enhanced error handling with friendly placeholder messages that include camera icons and detailed instructions. Improved the visual styling of error states and added more descriptive log messages.

### DEF-003: Remote Control Navigation Inconsistency
- **Description**: Navigation between video feeds using arrow keys is sometimes inconsistent.
- **Severity**: Medium
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 18 April 2025
- **Resolution**: Improved focus management with clearer visual indicators. Added a subtle animation effect for focus state changes and increased z-index for focused elements to ensure proper stacking order.

### DEF-004: Splash Screen Display Issue
- **Description**: Splash screen occasionally fails to hide after app initialization.
- **Severity**: Medium
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 18 April 2025
- **Resolution**: Fixed timing issue by adding a forced hide after timeout regardless of stream loading status.

### ENH-001: Settings Configuration UI
- **Description**: Add a settings page to allow users to configure webcam feeds.
- **Severity**: Low (Enhancement)
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 21 April 2025
- **Assigned To**: Product Owner
- **Notes**: Would allow users to add, remove, or edit webcam feed URLs and names without modifying the code.
- **Resolution**: Implemented a comprehensive settings UI with the following features:
  - Add/Edit/Delete webcam feeds with custom names and URLs
  - Enable/disable individual webcam feeds
  - User-friendly form controls with proper validation
  - Persistent storage using localStorage
  - Custom confirmation dialog for delete operations

### ENH-002: Stream Reconnection Logic
- **Description**: Implement automatic reconnection attempts for failed streams.
- **Severity**: Low (Enhancement)
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 21 April 2025
- **Assigned To**: Development Team
- **Notes**: When a stream fails to load, the app should periodically attempt to reconnect rather than showing an error permanently.
- **Resolution**: Implemented auto-refresh functionality with configurable interval:
  - Added a setting in the Grid Layout options to specify refresh interval in seconds
  - Created a timer-based reconnection system that reloads all streams at the specified interval
  - Added proper error handling during reconnection attempts
  - Ensured refresh doesn't interrupt fullscreen viewing or settings interaction

### ENH-003: Additional Grid Layout Options
- **Description**: Support for different grid layouts (3x3, 4x4, etc.)
- **Severity**: Low (Enhancement)
- **Status**: Resolved
- **Created**: 18 April 2025
- **Resolved**: 21 April 2025
- **Assigned To**: Product Owner
- **Notes**: Allow users to select different grid layouts depending on the number of cameras they want to monitor.
- **Resolution**: Implemented flexible grid layout options with both automatic and custom configurations:
  - Added "Auto (Dynamic)" layout that optimizes grid based on number of enabled cameras
  - Created "Custom Grid" option where users can specify exact rows and columns (up to 6x6)
  - Applied CSS grid with dynamic template columns/rows for flexible layouts
  - Added proper persistence of grid layout settings in localStorage
  - Ensured layout changes are applied immediately without app restart

### Issue: Preview Images Not Rendering Properly
**Root Cause:** Incompatibility with Chromium 53 web engine used in webOS TV 3.x.

**Resolution:**
1. Adjusted CSS to replace unsupported `gap` property in Flexbox and Grid with margin-based spacing.
2. Updated JavaScript to replace arrow functions with traditional function expressions and used `var` instead of `const` and `let` for broader compatibility.

**Status:** Fixed.

## Instructions for Logging New Defects

When adding a new defect or enhancement, please follow this format:

```
### [DEF/ENH]-[Number]: [Brief Title]
- **Description**: [Clear description of the issue or enhancement]
- **Severity**: [Critical/High/Medium/Low/Enhancement]
- **Status**: [Open/In Progress/Resolved]
- **Created**: [Creation Date]
- **Assigned To**: [Person or Team]
- **Notes**: [Additional details, steps to reproduce, or context]
```

For resolved defects, add the following:
```
- **Resolved**: [Resolution Date]
- **Resolution**: [Description of how the issue was resolved]
```

Remember to update the status of existing defects as they progress through the development workflow.