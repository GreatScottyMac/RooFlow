#!/usr/bin/env node

/**
 * RooInstaller - Automated tool to install RooFlow into a target project.
 * 
 * This tool solves Mac compatibility issues with .dotfiles by automatically:
 * 1. Copying all required RooFlow files to a target project
 * 2. Handling proper file naming for dotfiles (that may download as clinerules*.txt)
 * 3. Creating required directories if they don't exist
 * 
 * Usage:
 *   node rooinstaller.js <target-project-path>
 * 
 * If no target is specified, it will use the current directory.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration
const ROOFLOW_SOURCE_DIR = path.resolve(__dirname, '../../');
const FILES_TO_COPY = [
  { src: '.clinerules-architect', dest: '.clinerules-architect' },
  { src: '.clinerules-ask', dest: '.clinerules-ask' },
  { src: '.clinerules-code', dest: '.clinerules-code' },
  { src: '.clinerules-debug', dest: '.clinerules-debug' },
  { src: '.clinerules-test', dest: '.clinerules-test' },
  { src: '.roomodes', dest: '.roomodes' },
  { src: '.roo/system-prompt-architect', dest: '.roo/system-prompt-architect' },
  { src: '.roo/system-prompt-ask', dest: '.roo/system-prompt-ask' },
  { src: '.roo/system-prompt-code', dest: '.roo/system-prompt-code' },
  { src: '.roo/system-prompt-debug', dest: '.roo/system-prompt-debug' },
  { src: '.roo/system-prompt-test', dest: '.roo/system-prompt-test' }
];

// Color output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

// Parse command line arguments
const targetProjectPath = process.argv[2] || process.cwd();

console.log(`${colors.blue}RooInstaller${colors.reset} - Automated RooFlow installation tool`);
console.log(`${colors.cyan}Target project:${colors.reset} ${targetProjectPath}`);

// Ensure target directory exists
if (!fs.existsSync(targetProjectPath)) {
  console.error(`${colors.red}Error:${colors.reset} Target directory does not exist: ${targetProjectPath}`);
  process.exit(1);
}

// Create necessary directories in target project
function ensureDirectoryExists(dirPath) {
  const fullPath = path.join(targetProjectPath, dirPath);
  if (!fs.existsSync(fullPath)) {
    console.log(`${colors.yellow}Creating directory:${colors.reset} ${dirPath}`);
    fs.mkdirSync(fullPath, { recursive: true });
  }
}

ensureDirectoryExists('.roo');
ensureDirectoryExists('memory-bank');

// Initialize memory bank files if they don't exist
const memoryBankFiles = [
  'activeContext.md',
  'decisionLog.md',
  'productContext.md',
  'progress.md'
];

memoryBankFiles.forEach(file => {
  const filePath = path.join(targetProjectPath, 'memory-bank', file);
  if (!fs.existsSync(filePath)) {
    console.log(`${colors.yellow}Initializing memory bank file:${colors.reset} ${file}`);
    fs.writeFileSync(filePath, `# ${file.replace('.md', '')}\n\nInitialized by RooInstaller on ${new Date().toISOString()}\n`);
  }
});

// Copy files
console.log(`${colors.green}Copying RooFlow files...${colors.reset}`);

FILES_TO_COPY.forEach(file => {
  const sourcePath = path.join(ROOFLOW_SOURCE_DIR, file.src);
  const destPath = path.join(targetProjectPath, file.dest);
  
  // Check for alternative source names (for files that might have been downloaded with .txt extension)
  let sourcePathToUse = sourcePath;
  if (!fs.existsSync(sourcePathToUse)) {
    const alternativeSourcePath = `${sourcePath}.txt`;
    if (fs.existsSync(alternativeSourcePath)) {
      sourcePathToUse = alternativeSourcePath;
      console.log(`${colors.yellow}Using alternative source:${colors.reset} ${path.basename(alternativeSourcePath)}`);
    } else {
      console.log(`${colors.red}Warning: Source file not found:${colors.reset} ${sourcePath}`);
      return;
    }
  }
  
  // Create parent directory if it doesn't exist
  const destDir = path.dirname(destPath);
  if (!fs.existsSync(destDir)) {
    fs.mkdirSync(destDir, { recursive: true });
  }
  
  try {
    // Copy and rename file
    fs.copyFileSync(sourcePathToUse, destPath);
    console.log(`${colors.green}Copied:${colors.reset} ${file.src} → ${file.dest}`);
  } catch (error) {
    console.error(`${colors.red}Error copying file:${colors.reset} ${error.message}`);
  }
});

console.log(`\n${colors.magenta}RooFlow installation complete!${colors.reset}`);
console.log(`\nYou can now use RooFlow in your project at: ${targetProjectPath}`);
console.log(`
${colors.cyan}Usage:${colors.reset}
1. Open your project in VS Code with the Roo Code extension installed
2. Start a new Roo Code chat
3. Select the appropriate mode (Architect, Code, Test, Debug, Ask)
4. Type "hello" to begin your first session
`);
