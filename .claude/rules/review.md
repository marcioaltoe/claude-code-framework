# Code Review Checklist

## Post-Task Verification

### Testing

- ✅ Run all tests after completing each task
- ✅ Ensure all tests pass successfully
- ✅ Check that new features have corresponding tests

### Code Coverage

- ✅ Verify code coverage meets project requirements
- ✅ Ensure new code is adequately covered
- ✅ Review coverage reports for gaps

### Code Quality

#### Formatting

- ✅ Check code formatting follows project standards
- ✅ Ensure consistent indentation and spacing
- ✅ Verify proper line breaks and organization

#### Linting

- ✅ Run linter to check for rule violations
- ✅ Fix all linting errors and warnings
- ✅ Review and address linting suggestions

## Best Practices Review

### Code Standards

- ✅ Verify adherence to established coding standards
- ✅ Check naming conventions are followed
- ✅ Ensure consistent code style throughout

## Common Issues Checklist

### Comments

- ✅ Remove unnecessary or outdated comments
- ✅ Ensure remaining comments add value
- ✅ Check for TODO/FIXME comments that need addressing

### Hardcoded Values

- ✅ Check for hardcoded values that should be configurable
- ✅ Move magic numbers to named constants
- ✅ Externalize environment-specific values

### Imports and Dependencies

- ✅ Remove unused imports
- ✅ Check for missing imports
- ✅ Verify import order and organization

### Variables and Functions

- ✅ Remove unused variables
- ✅ Check for unused functions or methods
- ✅ Ensure all declared items are utilized

## Code Optimization

### Clarity and Simplicity

- ✅ Look for opportunities to simplify complex logic
- ✅ Ensure code is self-documenting
- ✅ Refactor unclear or convoluted sections

### Performance

- ✅ Check for obvious performance issues
- ✅ Review database queries for optimization
- ✅ Identify potential bottlenecks

## Security Review

### Sensitive Data

- ✅ Ensure no secrets or credentials are hardcoded
- ✅ Check for proper data sanitization
- ✅ Verify secure handling of user input

### Dependencies

- ✅ Review new dependencies for security issues
- ✅ Check for outdated vulnerable packages
- ✅ Ensure minimal dependency footprint

## Final Checks

### Documentation

- ✅ Update documentation for new features
- ✅ Ensure README is current
- ✅ Update API documentation if applicable

### Version Control

- ✅ Review changes before committing
- ✅ Write clear, descriptive commit messages
- ✅ Ensure no debug code is included
