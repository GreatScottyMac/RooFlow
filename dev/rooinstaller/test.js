#!/usr/bin/env node

/**
 * RooInstaller Test Script
 * 
 * This script tests the RooInstaller functionality by creating a temporary test project
 * and running the installer against it.
 * 
 * Usage:
 *   node test.js
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Colors for terminal output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// Configuration
const TEST_DIR = path.join(__dirname, 'test-project');
const INSTALLER_PATH = path.join(__dirname, 'install.sh');

// Clean up any existing test directory
if (fs.existsSync(TEST_DIR)) {
  console.log(`${colors.yellow}Cleaning up existing test directory...${colors.reset}`);
  fs.rmSync(TEST_DIR, { recursive: true, force: true });
}

// Create test directory
console.log(`${colors.blue}Creating test project directory at ${TEST_DIR}${colors.reset}`);
fs.mkdirSync(TEST_DIR);

// Run the installer on the test directory
console.log(`${colors.cyan}Running RooInstaller on test project...${colors.reset}`);
try {
  execSync(`${INSTALLER_PATH} ${TEST_DIR}`, { stdio: 'inherit' });
  console.log(`${colors.green}Installation completed successfully.${colors.reset}`);
} catch (error) {
  console.error(`${colors.red}Installation failed:${colors.reset}`, error.message);
  process.exit(1);
}

// Verify the installation
const expectedFiles = [
  '.clinerules-architect',
  '.clinerules-ask',
  '.clinerules-code',
  '.clinerules-debug',
  '.clinerules-test',
  '.roomodes',
  '.roo/system-prompt-architect',
  '.roo/system-prompt-ask',
  '.roo/system-prompt-code',
  '.roo/system-prompt-debug',
  '.roo/system-prompt-test',
  'memory-bank/activeContext.md',
  'memory-bank/decisionLog.md',
  'memory-bank/productContext.md',
  'memory-bank/progress.md',
];

console.log(`${colors.blue}Verifying installation...${colors.reset}`);
let missingFiles = [];

for (const file of expectedFiles) {
  const filePath = path.join(TEST_DIR, file);
  if (!fs.existsSync(filePath)) {
    missingFiles.push(file);
  }
}

if (missingFiles.length > 0) {
  console.error(`${colors.red}Verification failed. Missing files:${colors.reset}`);
  missingFiles.forEach(file => console.error(`  - ${file}`));
  process.exit(1);
} else {
  console.log(`${colors.green}Verification successful. All files were installed correctly!${colors.reset}`);
  console.log(`${colors.yellow}Cleaning up test directory...${colors.reset}`);
  fs.rmSync(TEST_DIR, { recursive: true, force: true });
  console.log(`${colors.green}Test completed successfully.${colors.reset}`);
}
