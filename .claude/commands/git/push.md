---
allowed-tools: [Bash, Task]
description: "Push changes and automatically create PR with comprehensive description"
---

# /git:push - Push with PR Creation

## Purpose
Push commits to remote and automatically create a Pull Request with intelligent description.

## Usage
```bash
/git:push                    # Push and create PR
/git:push --draft            # Create draft PR
/git:push --no-pr            # Push only (emergency use)
```

## Options

### --draft
Create PR as draft for work in progress

### --no-pr
Skip PR creation (use only when absolutely necessary)

### --base BRANCH
Specify base branch for PR (default: main)

## Workflow

### 1. Pre-push Validation
```yaml
checks:
  - Verify remote repository exists
  - Check for uncommitted changes
  - Ensure branch is up-to-date with remote
  - Validate branch isn't main/master
  - Check for conflicts with base branch
```

### 2. Push Changes
- Push current branch to remote
- Set upstream if needed
- Handle any push errors

### 3. PR Description Generation
```yaml
agent: pr-description-generator
task: Generate comprehensive PR description using MCP Zen
model: gemini-2.5-pro (via MCP Zen)
input:
  - All commits in branch
  - Changed files analysis
  - Diff statistics
  - Base and feature branch names
output:
  - PR title
  - Summary section
  - Changes section
  - Testing section
  - Breaking changes (if any)
  - Related issues links
```

### 4. PR Creation
```yaml
tool: gh pr create
includes:
  - Title from commit analysis
  - Comprehensive description
  - Appropriate labels
  - Request reviewers (if configured)
  - Link to related issues
```

### 5. Post-creation
- Display PR URL
- Open in browser (optional)
- Show next steps

## Examples

### Standard flow
```bash
/git:push
# Automatically:
# 1. Pushes to remote
# 2. Calls pr-description-generator agent
# 3. Agent uses MCP Zen with Gemini Pro for analysis
# 4. Creates PR with comprehensive description
# 5. Opens PR in browser
```

### Example PR Description Generated
```markdown
## Summary
Added comprehensive Organization Management module following DDD principles
with full CRUD operations and multi-tenancy support.

## Changes
- Added Organization entity with ULID identification
- Implemented repository pattern with Drizzle ORM
- Created use cases for all CRUD operations
- Added REST API endpoints with validation
- Implemented soft delete functionality

## Testing
- ✅ Unit tests added (100% coverage)
- ✅ Integration tests for all endpoints
- ✅ E2E tests for critical flows
- ✅ Performance benchmarks passed

## Related Issues
Closes #123
Relates to #456
```

### Draft PR
```bash
/git:push --draft
# Creates draft PR for work in progress
```

### Emergency push only
```bash
/git:push --no-pr
# Only pushes without PR (use sparingly)
```

## Integration
- **git-analyst**: Analyzes individual commits
- **pr-description-generator**: Creates comprehensive PR descriptions via MCP Zen
- **Gemini Pro**: Accessed through MCP Zen for rich descriptions
- **gh CLI**: Creates and manages PRs
- **Configuration**: Uses `.claude/config/git.json`

## Notes
- Always creates PR by default to maintain quality
- Uses Gemini Pro for rich PR descriptions
- Automatically links related issues
- Prevents direct pushes to main branch