---
allowed-tools: [Bash, Task]
description: "Create and manage feature branches with conventional naming"
---

# /git:branch - Branch Management

## Purpose
Create feature branches with conventional naming and proper tracking.

## Usage
```bash
/git:branch feature-name     # Create feature/feature-name
/git:branch fix bug-name     # Create fix/bug-name  
/git:branch                  # List branches with status
```

## Branch Types
- **feature/**: New features
- **fix/**: Bug fixes
- **refactor/**: Code refactoring
- **docs/**: Documentation updates
- **test/**: Test additions/changes
- **chore/**: Maintenance tasks

## Workflow

### 1. Branch Creation
```yaml
steps:
  - Ensure clean working directory
  - Pull latest from main
  - Create branch with type prefix
  - Set upstream tracking
  - Switch to new branch
```

### 2. Naming Convention
```yaml
format: type/kebab-case-description
examples:
  - feature/user-authentication
  - fix/login-validation-error
  - refactor/organization-repository
  - docs/api-documentation
```

### 3. Validation
- Check if branch already exists
- Validate naming convention
- Ensure not on protected branch
- Verify clean working state

## Examples

### Create feature branch
```bash
/git:branch user-auth
# Creates: feature/user-auth
# Switches to new branch
```

### Create fix branch
```bash
/git:branch fix token-expiration
# Creates: fix/token-expiration
```

### List branches
```bash
/git:branch
# Shows all branches with current highlighted
```

## Integration
- Automatically pulls latest main before branching
- Sets upstream for easy pushing
- Integrates with /git:push for PR creation
- Follows team naming conventions

## Notes
- Always branches from main unless specified
- Automatically adds type prefix if omitted (defaults to feature/)
- Kebab-case conversion for consistency
- Prevents branching with uncommitted changes