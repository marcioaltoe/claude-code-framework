# Git Workflow

## Commit Messages

### Format: `<type>(<scope>): <subject>`

**Types**: feat, fix, docs, style, refactor, perf, test, build, ci, chore

**Examples**:
```bash
feat(auth): add refresh token support
fix(api): handle null responses
docs(readme): update installation steps
refactor(domain): extract validation logic
chore(deps): update dependencies
```

**Rules**:
- Imperative mood ("add" not "added")
- No capital first letter
- No period at end
- Max 50 characters

## Branches

### Format: `<type>/<ticket>-<description>`

```bash
feat/PROJ-123-add-auth
fix/PROJ-456-memory-leak
hotfix/PROJ-789-critical-bug
```

## Workflow

```bash
# Start feature
git checkout main && git pull
git checkout -b feat/PROJ-123-description

# Commit changes
git add specific-files
git commit -m "feat(scope): clear message"

# Stay updated
git fetch && git rebase origin/main

# Push changes
git push -u origin branch-name
```

## Pull Requests

### PR Title: Same as commit format

### PR Guidelines
- Keep PRs small (< 400 lines)
- One concern per PR
- Self-review before requesting
- All tests must pass
- Update documentation if needed

## Best Practices

**DO:**
- ✅ Write descriptive commit messages
- ✅ Keep commits atomic and focused
- ✅ Test before committing
- ✅ Follow conventional commits
- ✅ Keep PRs small

**DON'T:**
- ❌ Commit directly to main
- ❌ Force push to shared branches
- ❌ Commit sensitive data
- ❌ Use generic messages
- ❌ Skip code review
