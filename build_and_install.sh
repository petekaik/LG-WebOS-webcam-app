#!/bin/bash
# LG WebOS Webcam App - Build and Install Script
# This script packages and installs the application to a WebOS device

# Set base variables
APP_DIR=$(dirname "$0")
BUILD_DIR="$APP_DIR/build"

# Read application info from appinfo.json
if [ -f "$APP_DIR/appinfo.json" ]; then
    # Extract app details using jq if available, otherwise fall back to grep
    if command -v jq &> /dev/null; then
        APP_ID=$(jq -r '.id' "$APP_DIR/appinfo.json")
        APP_VERSION=$(jq -r '.version' "$APP_DIR/appinfo.json")
        APP_NAME=$(jq -r '.title' "$APP_DIR/appinfo.json")
        APP_VENDOR=$(jq -r '.vendor' "$APP_DIR/appinfo.json")
    else
        APP_ID=$(grep -o '"id": "[^"]*"' "$APP_DIR/appinfo.json" | cut -d'"' -f4)
        APP_VERSION=$(grep -o '"version": "[^"]*"' "$APP_DIR/appinfo.json" | cut -d'"' -f4)
        APP_NAME=$(grep -o '"title": "[^"]*"' "$APP_DIR/appinfo.json" | cut -d'"' -f4)
        APP_VENDOR=$(grep -o '"vendor": "[^"]*"' "$APP_DIR/appinfo.json" | cut -d'"' -f4)
    fi
else
    echo -e "${RED}Error: appinfo.json not found!${NC}"
    exit 1
fi

# Set derived variables
PACKAGE_FILE="$APP_DIR/$APP_ID"_"$APP_VERSION"_all.ipk
BUILD_PACKAGE_FILE="$BUILD_DIR/$APP_ID"_"$APP_VERSION"_all.ipk

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

# Function to ensure build directory exists
ensure_build_dir() {
    if [ ! -d "$BUILD_DIR" ]; then
        echo -e "${YELLOW}Creating build directory: $BUILD_DIR${NC}"
        mkdir -p "$BUILD_DIR"
    fi
}

# Function to package the application
package_app() {
    echo -e "${YELLOW}Packaging application ${APP_NAME} (version $APP_VERSION) by ${APP_VENDOR}...${NC}"
    cd "$APP_DIR" || exit 1
    
    # Ensure build directory exists
    ensure_build_dir
    
    # Remove old package if it exists
    if [ -f "$PACKAGE_FILE" ]; then
        echo -e "${YELLOW}Removing existing package: $PACKAGE_FILE${NC}"
        rm "$PACKAGE_FILE"
    fi
    
    if [ -f "$BUILD_PACKAGE_FILE" ]; then
        echo -e "${YELLOW}Removing existing build package: $BUILD_PACKAGE_FILE${NC}"
        rm "$BUILD_PACKAGE_FILE"
    fi
    
    # Create the package
    ares-package .
    
    if [ $? -eq 0 ] && [ -f "$PACKAGE_FILE" ]; then
        echo -e "${GREEN}Package created successfully: ${PACKAGE_FILE}${NC}"
        
        # Move package to build directory
        echo -e "${YELLOW}Moving package to build directory...${NC}"
        mv "$PACKAGE_FILE" "$BUILD_PACKAGE_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Package moved to: ${BUILD_PACKAGE_FILE}${NC}"
            return 0
        else
            echo -e "${RED}Failed to move package to build directory${NC}"
            return 1
        fi
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
    
    if [ ! -f "$BUILD_PACKAGE_FILE" ]; then
        echo -e "${RED}Package file not found: ${BUILD_PACKAGE_FILE}${NC}"
        return 1
    fi
    
    ares-install $device_arg "$BUILD_PACKAGE_FILE"
    
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
echo -e "${BLUE}Building WebOS Webcam App '${APP_NAME}' (${APP_ID}) version ${APP_VERSION}${NC}"
echo -e "${BLUE}Vendor: ${APP_VENDOR}${NC}"

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