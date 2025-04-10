# Contributing to RooFlow

Thank you for your interest in contributing to RooFlow! We welcome contributions from everyone. This document outlines how to contribute to the project.

## Ways to Contribute

* **Bug Reports:** If you find a bug, please open an issue on the GitHub repository, providing a clear description of the problem, steps to reproduce it, and your expected vs. actual results. Include the Roo version, VS Code version, and operating system.
* **Feature Requests:** If you have an idea for a new feature, open an issue on GitHub and describe the feature, its benefits, and any potential implementation details.
* **Code Contributions:** If you want to contribute code (bug fixes, new features, improvements), please follow these steps:
  1. **Fork the Repository:** Create a fork of the RooFlow repository on GitHub.
  2.  **Create a Branch:** Create a new branch for your changes (e.g., `feature/my-new-feature` or `bugfix/issue-123`). Use descriptive branch names.
  3. **Make Changes:** Make your changes, following the coding style and conventions of the project.
  4. **Test Thoroughly:** Ensure your changes work correctly and don't introduce new issues. Test with and without an existing Memory Bank. Test the UMB command.
  5. **Commit Changes:** Commit your changes with clear and descriptive commit messages.
  6. **Push to Your Fork:** Push your branch to your forked repository.
  7. **Create a Pull Request:** Create a pull request from your branch to the `main` branch of the RooFlow repository. Clearly describe your changes and the problem they solve or the feature they add.
* **Documentation:** Improvements to the documentation (README, etc.) are also welcome. Follow the same process as for code contributions.

## Development Setup

To develop RooFlow, you'll need:

1. **VS Code:** Install Visual Studio Code.
2. **Roo Code Extension:** Install the [Roo Code](https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline) extension.

**Project Structure:**

The RooFlow development requires/consists of the following files, which you need to copy from `src` and place into the root directory:

* `.roo/`: A directory containing the system prompts.
  * `system-prompt-architect`: System prompt for Architect mode.
  * `system-prompt-code`: System prompt for Code mode.
  * `system-prompt-debug`: System prompt for Debug mode.
  * `system-prompt-ask`: System prompt for Ask mode.
  * `system-prompt-test`: System prompt for Test mode.
* `.rooignore`: So Roo doesn't ignore memory-bank/ if it's gitignored.
* `.roomodes`: Defines the custom Test mode.

**Memory Bank:**

The `memory-bank/` directory is created automatically by RooFlow. Do *not* create it manually.

**Testing:**

* **Test Thoroughly:** Before submitting any changes, test them thoroughly in various scenarios.
* **Memory Bank Presence/Absence:** Test with and without an existing Memory Bank.
* **UMB Command:** Test the "Update Memory Bank" (UMB) command to ensure it works correctly.
* **Mode Switching:** Test switching between different modes.
* **Error Handling:** Test how RooFlow handles errors and unexpected situations.

## Coding Style

* **YAML:** The `system-prompt-[mode]` files use YAML format. Use consistent indentation (2 spaces) and follow YAML best practices.
* **Markdown:** The Memory Bank files (`.md`) use Markdown format.
* **Clarity:** Write clear, concise, and unambiguous instructions.
* **Comments**: Use comments within the YAML files to explain complex logic.

## Pull Request Guidelines

* **Descriptive Title:** Use a clear and descriptive title for your pull request.
* **Detailed Description:** Provide a detailed description of your changes, including the motivation for the changes, the approach taken, and any relevant context.
* **Link to Issue:** If your pull request addresses an existing issue, link to the issue in the description.
* **Small, Focused Changes:** Prefer smaller, focused pull requests over large, monolithic ones.
* **Tests:** Include tests for any new functionality or bug fixes.

## Code of Conduct

Please be respectful and constructive in all interactions.

By contributing to RooFlow, you agree to abide by the terms of the [Apache 2.0 License](LICENSE).
