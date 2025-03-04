#!/bin/bash

# RooInstaller bash wrapper
# This simple script makes it easier to run the RooInstaller

# Find the script directory (even if run through symlink)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}RooInstaller${NC} - Bash launcher"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required but not installed."
    exit 1
fi

# Get target directory (use current directory if not specified)
TARGET_DIR="${1:-$(pwd)}"

# Make the JavaScript executable
chmod +x "$SCRIPT_DIR/rooinstaller.js"

# Run the installer
echo -e "${CYAN}Launching RooInstaller for target:${NC} $TARGET_DIR"
node "$SCRIPT_DIR/rooinstaller.js" "$TARGET_DIR"
