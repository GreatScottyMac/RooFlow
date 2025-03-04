# Contributing to RooFlow

Thank you for considering contributing to RooFlow! This document outlines the process and guidelines for contributing to the project.

## Code of Conduct

By participating in this project, you agree to uphold our Code of Conduct:

- Be respectful and inclusive of others
- Provide constructive feedback
- Stay focused on improving the project
- Help others when possible

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with the following information:

1. A clear, descriptive title
2. Detailed steps to reproduce the issue
3. Expected behavior vs. actual behavior
4. Any relevant logs, screenshots, or other information

### Suggesting Enhancements

We welcome suggestions for enhancing RooFlow. To suggest an enhancement, please:

1. Open an issue with the prefix "Enhancement: "
2. Clearly describe your suggestion and its benefits
3. Include any implementation ideas you might have

### Pull Requests

To submit changes:

1. Fork the repository
2. Create a new branch for your changes
3. Make your changes
4. Ensure your code follows our style guidelines
5. Submit a pull request with a clear description of the changes

Pull requests should focus on a single issue or enhancement to make review easier.

## Development Setup

1. Clone the repository:
   ```
   git clone https://github.com/GreatScottyMac/RooFlow.git
   ```
2. Install the Roo Code extension in VS Code
3. Use the RooInstaller to set up your development environment

## Coding Standards

- Keep code simple and readable
- Add comments for complex logic
- Follow existing naming conventions
- Write descriptive commit messages

## File Structure Guidelines

When modifying or adding files:

- Place mode-specific rule files in the project root (e.g., `.clinerules-architect`)
- Place system prompts in the `.roo` directory
- Prefix hidden files with `.` (e.g., `.roomodes`)
- Use descriptive filenames for any new files

## Testing

Before submitting your changes, please:

1. Test all changes manually in VS Code with the Roo Code extension
2. Verify that the Memory Bank updates correctly
3. Ensure all modes function as expected

## Documentation

When adding or changing features, update the relevant documentation:

- Update the README.md for user-facing changes
- Add JSDoc comments for new code
- Update installation instructions if applicable

## License

By contributing to RooFlow, you agree that your contributions will be licensed under the project's [Apache 2.0 License](LICENSE).

## Questions?

If you have any questions about contributing, feel free to open an issue labeled "Question".

Thank you for helping improve RooFlow!
