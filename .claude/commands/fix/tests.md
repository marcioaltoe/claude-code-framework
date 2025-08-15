---
name: fix-tests
description: "Simple command dispatcher for Vitest test failure fixing"
type: maintainer
category: quality
complexity: simple
scope: project
allowed-tools: [Task]

# Activation Configuration
activation:
  manual-commands: ["/fix:tests"]
  flags: ["--tests", "--vitest"]
  auto-detect: ["vitest.config.*", "vite.config.*"]

# Integration Configuration
framework-integration:
  agents:
    - vitest-fixer
  mcp-servers:
    - context7
    - perplexity
  output-location: "reports/test-fixes/"

# Performance Profile
performance-profile: lightweight
performance-targets:
  dispatch: "<5s"
  agent-handoff: "immediate"
---

## /fix:tests - Vitest Test Fixer

**Simple command dispatcher** — Invokes the `vitest-fixer` agent with specified parameters. All Vitest test fixing logic is handled by the specialized agent.

### Usage

```bash
/fix:tests                             # Fix all failing tests
/fix:tests --staged --safe             # Safe fixes for staged files only
/fix:tests --path src/ --report        # Fix tests in src/ directory
```

### Options

- **--staged**: Fix only staged test files
- **--path [dir]**: Fix tests in specific directory
- **--since [ref]**: Fix tests for files changed since git ref
- **--safe**: Use safe fix level (default: standard)
- **--aggressive**: Use aggressive fix level
- **--update-snapshots**: Allow snapshot updates (with approval)
- **--report**: Generate detailed report
- **--dry-run**: Preview changes without applying
- **--review**: Invoke code-reviewer after fixes

### Workflow

1. Parse command options
2. Invoke `vitest-fixer` agent with parameters
3. Agent handles all test fixing logic (includes snapshot review)
4. Return results to user

### Examples

```bash
# Safe fixes for PR
/fix:tests --staged --safe --report

# Fix with snapshot updates
/fix:tests --path components/ --update-snapshots

# Preview changes
/fix:tests --dry-run --aggressive --review
```

### Integration

- Uses `vitest-fixer` agent for all business logic
- Agent integrates with `snapshot-reviewer` for snapshot decisions
- Can be chained with other `/fix` commands
- Integrates with git workflows via `--staged` and `--since`

### Output

- Direct file edits via `vitest-fixer` agent
- Optional reports in `reports/test-fixes/`
- Exit codes: 0 (success), 1 (tests still failing), 2 (blocked)
