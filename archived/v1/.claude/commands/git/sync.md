---
allowed-tools: [Bash, Task]
description: "Synchronize repository with remote changes"
---

# /git:sync - Repository Synchronization

## Purpose
Keep local repository synchronized with remote changes, especially after PR merges.

## Usage
```bash
/git:sync              # Sync current branch with remote
/git:sync --all        # Sync all branches and clean merged ones
/git:sync --prune      # Remove local branches deleted on remote
```

## Options

### --all
Full synchronization:
- Fetch all remotes
- Update all local branches
- Prune deleted remote branches
- Clean merged feature branches

### --prune
Remove branches that no longer exist on remote

### --force
Force sync even with local changes (stashes them)

## Workflow

### 1. Standard Sync (After PR Merge)
```yaml
steps:
  - Fetch latest from remote
  - Switch to main branch
  - Pull latest changes
  - Delete merged feature branch
  - Prune remote-tracking branches
  - Show updated status
```

### 2. Full Sync (--all)
```yaml
steps:
  - Stash any local changes
  - Fetch all remotes with prune
  - Update main/master branch
  - Update all tracking branches
  - Delete merged local branches
  - Clean up remote-tracking refs
  - Restore stashed changes
```

### 3. Safety Checks
- Warn about uncommitted changes
- Confirm branch deletion
- Verify remote connectivity
- Check for conflicts

## Post-PR Merge Flow
After your PR is merged:
```bash
/git:sync
# Automatically:
# 1. Switches to main
# 2. Pulls latest changes
# 3. Deletes your feature branch
# 4. Cleans remote references
```

## Examples

### After PR merge
```bash
/git:sync
# Updates main and removes merged feature branch
```

### Full repository cleanup
```bash
/git:sync --all
# Synchronizes everything and cleans up
```

### Force sync with local changes
```bash
/git:sync --force
# Stashes changes, syncs, then restores
```

## Integration
- Works with /git:push PR workflow
- Maintains clean branch structure
- Integrates with team workflow
- Respects protected branches

## Notes
- Safe by default - warns before destructive actions
- Automatically identifies merged branches
- Preserves local work via stashing
- Keeps repository organized and clean