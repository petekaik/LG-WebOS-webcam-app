#!/bin/bash
# LG WebOS Webcam App - Build and Install Script
# This script packages and installs the application to a WebOS device

# Set variables
APP_NAME="Webcam Viewer"
APP_ID="com.morgeweb.webcamapp"
APP_DIR=$(dirname "$0")
APP_VERSION=$(grep -o '"version": "[^"]*"' "$APP_DIR/appinfo.json" | cut -d'"' -f4)
PACKAGE_FILE="$APP_DIR/$APP_ID"_"$APP_VERSION"_all.ipk

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script usage
usage() {
    echo -e "${BLUE}Usage: $0 [options]${NC}"
    echo -e "Options:"
    echo -e "  ${YELLOW}-d, --device <DEVICE_NAME>${NC}  Specify target device name (from ares-setup-device)"
    echo -e "  ${YELLOW}-p, --package-only${NC}        Only package the app, don't install"
    echo -e "  ${YELLOW}-i, --install-only${NC}        Only install the app (assumes package exists)"
    echo -e "  ${YELLOW}-r, --run${NC}                 Run the app after installation"
    echo -e "  ${YELLOW}-l, --list-devices${NC}        List available devices"
    echo -e "  ${YELLOW}-h, --help${NC}                Display this help message"
    exit 1
}

# Function to check if ares CLI tools are installed
check_ares() {
    if ! command -v ares-package &> /dev/null; then
        echo -e "${RED}Error: ares-package command not found.${NC}"
        echo -e "${YELLOW}Please ensure that the WebOS SDK is installed and in your PATH.${NC}"
        exit 1
    fi
}

# Function to list available devices
list_devices() {
    echo -e "${BLUE}Available devices:${NC}"
    ares-setup-device -l
    exit 0
}

# Function to package the application
package_app() {
    echo -e "${YELLOW}Packaging application (version $APP_VERSION)...${NC}"
    cd "$APP_DIR" || exit 1
    
    # Remove old package if it exists
    if [ -f "$PACKAGE_FILE" ]; then
        echo -e "${YELLOW}Removing existing package: $PACKAGE_FILE${NC}"
        rm "$PACKAGE_FILE"
    fi
    
    # Create the package
    ares-package .
    
    if [ $? -eq 0 ] && [ -f "$PACKAGE_FILE" ]; then
        echo -e "${GREEN}Package created successfully: ${PACKAGE_FILE}${NC}"
        return 0
    else
        echo -e "${RED}Failed to create package${NC}"
        return 1
    fi
}

# Function to install the application on device
install_app() {
    local device="$1"
    local device_arg=""
    
    if [ -n "$device" ]; then
        device_arg="-d $device"
    fi
    
    echo -e "${YELLOW}Installing application version $APP_VERSION to device${NC} ${BLUE}$device${NC}..."
    
    if [ ! -f "$PACKAGE_FILE" ]; then
        echo -e "${RED}Package file not found: ${PACKAGE_FILE}${NC}"
        return 1
    fi
    
    ares-install $device_arg "$PACKAGE_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Application installed successfully${NC}"
        return 0
    else
        echo -e "${RED}Failed to install application${NC}"
        return 1
    fi
}

# Function to launch the application on device
launch_app() {
    local device="$1"
    local device_arg=""
    
    if [ -n "$device" ]; then
        device_arg="-d $device"
    fi
    
    echo -e "${YELLOW}Launching application on device${NC} ${BLUE}$device${NC}..."
    ares-launch $device_arg "$APP_ID"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Application launched successfully${NC}"
        return 0
    else
        echo -e "${RED}Failed to launch application${NC}"
        return 1
    fi
}

# Parse command line arguments
DEVICE=""
PACKAGE_ONLY=0
INSTALL_ONLY=0
RUN_APP=0

# If no arguments provided, show summary of what will happen
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}No arguments provided. Will package and install to default device.${NC}"
    echo -e "${YELLOW}Use -h or --help for more options.${NC}"
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -p|--package-only)
            PACKAGE_ONLY=1
            shift
            ;;
        -i|--install-only)
            INSTALL_ONLY=1
            shift
            ;;
        -r|--run)
            RUN_APP=1
            shift
            ;;
        -l|--list-devices)
            list_devices
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Check for ares CLI tools
check_ares

# Display current version info
echo -e "${BLUE}Building WebOS Webcam App version ${APP_VERSION}${NC}"

# Main execution flow
if [ $INSTALL_ONLY -eq 0 ]; then
    package_app
    if [ $? -ne 0 ] && [ $PACKAGE_ONLY -eq 0 ]; then
        exit 1
    fi
fi

if [ $PACKAGE_ONLY -eq 0 ]; then
    install_app "$DEVICE"
    if [ $? -eq 0 ] && [ $RUN_APP -eq 1 ]; then
        launch_app "$DEVICE"
    fi
fi

echo -e "${GREEN}Build and install process completed!${NC}"
exit 0