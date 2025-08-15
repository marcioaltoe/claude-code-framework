---
name: fix-lint
description: "Simple command dispatcher for Biome error fixing"
type: maintainer
category: quality
complexity: simple
scope: project
allowed-tools: [Task]

# Activation Configuration
activation:
  manual-commands: ["/fix:lint"]
  flags: ["--lint"]
  auto-detect: ["biome.json", "biome.jsonc"]

# Integration Configuration
framework-integration:
  agents:
    - lint-fixer
  output-location: "reports/lint-fixes/"

# Performance Profile
performance-profile: lightweight
performance-targets:
  dispatch: "<5s"
  agent-handoff: "immediate"
---

## /fix:lint - Biome Error Fixer

**Simple command dispatcher** — Invokes the `lint-fixer` agent with specified parameters. All Biome fixing logic is handled by the specialized agent.

### Usage

```bash
/fix:lint                              # Fix all lint errors
/fix:lint --staged --safe              # Safe fixes for staged files only
/fix:lint --path src/ --report         # Fix src/ directory with report
```

### Options

- **--staged**: Fix only staged files
- **--path [dir]**: Fix specific directory
- **--since [ref]**: Fix files changed since git ref
- **--safe**: Use safe fix level (default: standard)
- **--aggressive**: Use aggressive fix level
- **--report**: Generate detailed report
- **--dry-run**: Preview changes without applying
- **--review**: Invoke code-reviewer after fixes

### Workflow

1. Parse command options
2. Invoke `lint-fixer` agent with parameters
3. Agent handles all Biome fixing logic
4. Return results to user

### Examples

```bash
# Safe fixes for PR
/fix:lint --staged --safe --report

# Fix specific module with review
/fix:lint --path packages/api --review

# Preview changes
/fix:lint --dry-run --aggressive
```

### Integration

- Uses `lint-fixer` agent for all business logic
- Can be chained with other `/fix` commands
- Integrates with git workflows via `--staged` and `--since`
- Optional code review integration

### Output

- Direct file edits via `lint-fixer` agent
- Optional reports in `reports/lint-fixes/`
- Exit codes: 0 (success), 1 (errors remain), 2 (blocked)
