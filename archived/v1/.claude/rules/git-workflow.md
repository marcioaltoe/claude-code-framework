# Git Workflow & Standards

## Commit Message Standards

### Conventional Commits Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Commit Types

| Type         | Description                     | Example                                           |
| ------------ | ------------------------------- | ------------------------------------------------- |
| **feat**     | New feature                     | `feat(auth): add JWT refresh token support`       |
| **fix**      | Bug fix                         | `fix(pipeline): resolve memory leak in streaming` |
| **docs**     | Documentation changes           | `docs(api): update OpenAPI specification`         |
| **style**    | Code style changes (formatting) | `style(domain): format entities with Biome`       |
| **refactor** | Code refactoring                | `refactor(etl): simplify transformation logic`    |
| **perf**     | Performance improvements        | `perf(query): optimize database indexing`         |
| **test**     | Test changes                    | `test(organization): add edge case tests`         |
| **build**    | Build system changes            | `build(docker): optimize image layers`            |
| **ci**       | CI/CD changes                   | `ci(github): add security scanning workflow`      |
| **chore**    | Maintenance tasks               | `chore(deps): update Bun to 1.0.15`               |
| **revert**   | Revert previous commit          | `revert: feat(auth): add JWT refresh token`       |

### Scope Guidelines

Scopes should match the domain/module affected:

- **auth**: Authentication/authorization
- **api**: API endpoints
- **domain**: Domain entities/logic
- **infra**: Infrastructure layer
- **pipeline**: ETL pipeline
- **db**: Database/migrations
- **deps**: Dependencies
- **config**: Configuration
- **test**: Testing infrastructure

### Subject Rules

- Use imperative mood ("add" not "adds" or "added")
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters
- Clear and concise

### Examples

```bash
# ✅ GOOD
feat(auth): add refresh token rotation
fix(pipeline): handle null values in transformation
docs(readme): update installation instructions
refactor(domain): extract validation logic to value objects
test(integration): add multi-tenant scenarios
chore(deps): upgrade drizzle-orm to 0.44.4

# ❌ BAD
Added refresh tokens  # Wrong tense, no type/scope
Fix bug  # Too vague, no scope
feat(auth): Added support for refresh tokens.  # Capitalized, period, wrong tense
update code  # No type/scope, too vague
```

## Branch Naming Convention

### Format

```
<type>/<ticket-number>-<short-description>
```

### Branch Types

- **feat/** - New features
- **fix/** - Bug fixes
- **hotfix/** - Urgent production fixes
- **refactor/** - Code refactoring
- **docs/** - Documentation updates
- **test/** - Test additions/updates
- **chore/** - Maintenance tasks

### Examples

```bash
feat/VUL-123-add-oauth-support
fix/VUL-456-pipeline-memory-leak
hotfix/VUL-789-critical-auth-bypass
refactor/VUL-321-cleanup-domain-services
docs/VUL-654-api-documentation
```

## Development Workflow

### 1. Start New Feature

```bash
# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feat/VUL-123-pipeline-retry-logic

# Or for bugs
git checkout -b fix/VUL-456-connection-timeout
```

### 2. Development Process

```bash
# Start with TDD
bun run test:watch

# Make changes following Clean Architecture

# Run quality checks
bun run lint
bun run format
bun run type-check

# Run all tests
bun run test

# Check test coverage
bun run test:coverage
```

### 3. Commit Changes

```bash
# Stage specific files (avoid git add .)
git add src/domain/entities/pipeline.ts
git add src/domain/entities/pipeline.test.ts

# Commit with conventional message
git commit -m "feat(pipeline): add automatic retry logic with exponential backoff

- Implement retry mechanism for failed pipeline executions
- Add exponential backoff strategy
- Configure max retry attempts via environment variable
- Add unit tests for retry logic

Closes #VUL-123"
```

### 4. Keep Branch Updated

```bash
# Regularly sync with main
git fetch origin
git rebase origin/main

# Resolve conflicts if any
git status
# Fix conflicts in files
git add <resolved-files>
git rebase --continue
```

### 5. Push Changes

```bash
# First push
git push -u origin feat/VUL-123-pipeline-retry-logic

# Subsequent pushes
git push

# After rebase (force push carefully)
git push --force-with-lease
```

## Pull Request Standards

### PR Title Format

Same as commit message format:

```
<type>(<scope>): <subject>
```

### PR Template

```markdown
## Description

Brief description of what this PR does.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as
      expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Related Issues

Closes #VUL-123

## Changes Made

- List of specific changes
- Implementation details
- Architecture decisions

## Testing

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] E2E tests pass (if applicable)
- [ ] Test coverage ≥ 80%
- [ ] Manual testing completed

## Checklist

- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No console.log statements
- [ ] No hardcoded values
- [ ] Security implications considered
- [ ] Performance impact evaluated
- [ ] Database migrations tested
- [ ] Breaking changes documented

## Screenshots (if applicable)

Add screenshots for UI changes

## Performance Impact

Describe any performance implications

## Security Considerations

List any security implications

## Deployment Notes

Special instructions for deployment (if any)
```

### PR Review Guidelines

#### Author Responsibilities

1. **Self-review** before requesting review
2. **Test thoroughly** - all tests must pass
3. **Update documentation** if needed
4. **Respond to feedback** promptly
5. **Keep PR focused** - one concern per PR
6. **Keep PR small** - max 400 lines changed

#### Reviewer Responsibilities

1. **Review promptly** - within 24 hours
2. **Be constructive** - suggest improvements
3. **Check for**:
   - Code quality and standards
   - Test coverage
   - Security implications
   - Performance impact
   - Documentation updates
   - Breaking changes

### PR Size Guidelines

- **Small**: < 100 lines (quick review)
- **Medium**: 100-400 lines (standard)
- **Large**: > 400 lines (consider splitting)

## Git Hooks (Husky)

### Pre-commit Hook

```bash
#!/bin/sh
# .husky/pre-commit

# Format code
bun run format

# Lint code
bun run lint

# Type check
bun run type-check

# Run tests
bun run test:run
```

### Commit Message Hook

```bash
#!/bin/sh
# .husky/commit-msg

# Validate commit message format
npx commitlint --edit $1
```

### Pre-push Hook

```bash
#!/bin/sh
# .husky/pre-push

# Run full test suite
bun run test

# Check coverage
bun run test:coverage

# Build project
bun run build
```

## Merge Strategies

### Feature Branches

```bash
# Squash and merge for clean history
git checkout main
git merge --squash feat/VUL-123-feature
git commit -m "feat(domain): add new feature (#123)"
```

### Hotfixes

```bash
# Regular merge to preserve history
git checkout main
git merge hotfix/VUL-789-critical-fix
```

## Release Workflow

### Semantic Versioning

```
MAJOR.MINOR.PATCH
```

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

### Release Commit Format

```bash
chore(release): v1.2.3

### Features
- feat(auth): add OAuth support
- feat(pipeline): add retry mechanism

### Bug Fixes
- fix(api): handle null responses
- fix(db): connection pool timeout

### Breaking Changes
- auth: JWT format changed

### Dependencies
- chore(deps): update drizzle-orm to 0.44.4
```

## Rollback Procedures

### Revert Commit

```bash
# Revert specific commit
git revert <commit-hash>
git push

# Revert merge commit
git revert -m 1 <merge-commit-hash>
```

### Reset Branch

```bash
# Local reset (DANGEROUS)
git reset --hard <commit-hash>

# Force push (VERY DANGEROUS - team coordination required)
git push --force-with-lease
```

## Common Scenarios

### Amend Last Commit

```bash
# Fix last commit message
git commit --amend -m "feat(auth): correct commit message"

# Add forgotten files to last commit
git add forgotten-file.ts
git commit --amend --no-edit
```

### Cherry Pick

```bash
# Apply specific commit to current branch
git cherry-pick <commit-hash>
```

### Interactive Rebase

```bash
# Clean up last 3 commits
git rebase -i HEAD~3

# Mark commits to squash/fixup/reword
# Save and follow prompts
```

### Stash Changes

```bash
# Save current changes
git stash save "WIP: feature implementation"

# List stashes
git stash list

# Apply latest stash
git stash pop

# Apply specific stash
git stash apply stash@{2}
```

## Protected Branches

### Main Branch Rules

- **No direct pushes** - PR required
- **Required reviews** - Minimum 1 approval
- **Status checks** - All CI/CD must pass
- **Up-to-date** - Must be current with main
- **Conversation resolution** - All comments resolved

### Development Branch Rules

- **Regular integration** - Merge to main weekly
- **Feature freeze** - Before releases
- **Testing environment** - Automated deployment

## Git Aliases (Optional)

```bash
# Add to ~/.gitconfig
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --graph --oneline --all
    amend = commit --amend --no-edit
    undo = reset --soft HEAD~1
    cleanup = !git branch --merged | grep -v '\\*\\|main\\|develop' | xargs -n 1 git branch -d
```

## DO NOT

- ❌ Commit directly to main
- ❌ Force push to shared branches
- ❌ Commit sensitive data (keys, passwords)
- ❌ Use generic commit messages
- ❌ Mix feature and refactoring in same commit
- ❌ Leave commented code
- ❌ Commit console.log statements
- ❌ Ignore failing tests
- ❌ Skip code review
- ❌ Merge without CI passing

## ALWAYS

- ✅ Write descriptive commit messages
- ✅ Keep commits atomic and focused
- ✅ Test before committing
- ✅ Review your own code first
- ✅ Update documentation
- ✅ Follow conventional commits
- ✅ Keep PRs small and focused
- ✅ Respond to review feedback
- ✅ Squash commits when merging
- ✅ Tag releases properly
