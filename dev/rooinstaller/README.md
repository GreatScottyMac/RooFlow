# RooInstaller

An automated tool for installing RooFlow into your projects.

## Overview

RooInstaller solves the common issues with RooFlow installation, especially on macOS systems where files starting with `.` can be problematic. It automatically:

1. Copies all required RooFlow files to your target project
2. Handles proper file naming for dotfiles (converting from `clinerules*.txt` to `.clinerules*` if needed)
3. Creates required directories (`memory-bank`, `.roo`) if they don't exist
4. Initializes basic memory bank files

## Installation

### Basic Installation

1. Make the installation scripts executable:
   ```bash
   chmod +x install.sh
   chmod +x rooinstaller.js
   ```

### Global Installation (Optional)

You can install RooInstaller as a global command, making it available from anywhere in your system:

1. Make the global installation script executable:
   ```bash
   chmod +x global-install.sh
   ```

2. Run the global installer:
   ```bash
   ./global-install.sh
   ```

This will install the `rooinstall` command globally. The installer will try to install in `/usr/local/bin` first, and if that's not accessible, it will fall back to `~/bin` (creating it if needed).

## Usage

### Method 1: Using the global command (if globally installed)

To install RooFlow in your current directory:
```bash
rooinstall
```

To install RooFlow in a specific project directory:
```bash
rooinstall /path/to/your/project
```

### Method 2: Using the bash script directly

To install RooFlow in your current directory:
```bash
./install.sh
```

To install RooFlow in a specific project directory:
```bash
./install.sh /path/to/your/project
```

### Method 3: Using Node.js directly

```bash
node rooinstaller.js [target-project-path]
```

If no target path is specified, it will use the current directory.

## What it Does

1. Creates the `.roo` directory in your project if it doesn't exist
2. Creates the `memory-bank` directory if it doesn't exist
3. Initializes basic memory bank files if they don't exist
4. Copies all RooFlow configuration files to their proper locations
5. Handles file renaming for dotfiles if they were downloaded with `.txt` extensions

## Files Installed

- `.clinerules-architect`
- `.clinerules-ask`
- `.clinerules-code`
- `.clinerules-debug`
- `.clinerules-test`
- `.roomodes`
- `.roo/system-prompt-architect`
- `.roo/system-prompt-ask`
- `.roo/system-prompt-code`
- `.roo/system-prompt-debug`
- `.roo/system-prompt-test`

## Memory Bank Files Initialized

- `activeContext.md`
- `decisionLog.md`
- `productContext.md`
- `progress.md`

## Benefits

- **Time-saving**: Eliminates manual file copying and directory creation
- **Error-proof**: Ensures all files are correctly named and placed
- **Mac-friendly**: Solves the common issue with dotfiles on macOS
- **Project-ready**: Your project is immediately ready to use with RooFlow after installation

## Requirements

- Node.js

## License

This tool is distributed under the same license as RooFlow (Apache 2.0).
