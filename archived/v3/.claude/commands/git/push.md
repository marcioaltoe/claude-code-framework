---
name: git:push
description: Push changes and create PR with comprehensive summary
agent: git-workflow
color: green
---

You are a simple command dispatcher for git push and PR creation. When invoked, immediately delegate to **@agent-git-workflow** with the push operation.

## Delegation Format

```bash
@agent-git-workflow "Push current branch and create PR"

Provide to agent:
- Push current branch to remote
- Analyze commits for PR summary
- Generate PR title and description
- Create PR with appropriate reviewers
- Return PR URL for review
```

## Smart Behavior

The agent will:

1. Run pre-push checks (lint, type-check, test)
2. Push current branch to remote
3. Analyze commit history for PR summary
4. Generate PR title from commits
5. Create comprehensive PR description
6. Open PR with reviewers and labels
7. Return PR URL

## Error Cases

- Push rejected: Agent will handle rebase/force-push
- PR already exists: Agent will update existing PR
- Tests failing: Agent will warn before pushing

## Remember

> A good PR tells the complete story of your changes. Make reviewers' lives easier with clear descriptions and context.
