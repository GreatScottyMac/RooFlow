# RooFlow Development

## Directory Structure

```
.
├── installer/           # Main installation system
│   ├── bin/            # Executable scripts
│   │   ├── install     # Installation script
│   │   ├── uninstall   # Uninstallation script
│   │   └── update      # Update script
│   ├── src/            # Source code
│   │   ├── install.js  # Installation logic
│   │   ├── uninstall.js# Uninstallation logic
│   │   ├── update.js   # Update logic
│   │   └── utils.js    # Shared utilities
│   └── README.md       # Installer documentation
├── scripts/            # Development scripts
│   ├── setup-tests.bat # Windows test setup
│   ├── setup-tests.sh  # Unix test setup
│   └── test-platforms.js# Cross-platform test runner
└── test/               # Test infrastructure
    ├── fixtures/       # Test data
    │   ├── mock-home-dirs/    # Home directory templates
    │   ├── system-configs/    # System configurations
    │   └── vscode-settings/   # VS Code settings
    ├── install.test.js # Main test suite
    ├── mock-fs.js      # Mock file system
    └── README.md       # Test documentation
```

## Setup and Testing

### Setting Up Development Environment

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up test environment:
   ```bash
   # On Unix/Linux/macOS:
   npm run setup

   # On Windows:
   npm run setup:win
   ```

### Running Tests

1. Run all platform tests:
   ```bash
   npm run test:platforms
   ```

2. Test specific platforms:
   ```bash
   npm run test:linux    # Test Linux environment
   npm run test:macos    # Test macOS environment
   npm run test:windows  # Test Windows environment
   ```

## Test Infrastructure

The test suite uses mock-fs to simulate different operating systems and file structures:

- Cross-platform file operations
- Permission testing
- Error scenarios
- System-specific paths
- Shell detection

## Contributing

1. Run tests before submitting changes
2. Follow existing code style
3. Update documentation as needed
4. Add tests for new features