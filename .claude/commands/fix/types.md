---
name: fix-types
description: "Simple command dispatcher for TypeScript error fixing"
type: maintainer
category: quality
complexity: simple
scope: project
allowed-tools: [Task]

# Activation Configuration
activation:
  manual-commands: ["/fix:types"]
  flags: ["--types", "--type-check", "--ts"]
  auto-detect: ["tsconfig.json"]

# Integration Configuration
framework-integration:
  agents:
    - type-fixer
  output-location: "reports/type-fixes/"

# Performance Profile
performance-profile: lightweight
performance-targets:
  dispatch: "<5s"
  agent-handoff: "immediate"
---

## /fix:types - TypeScript Error Fixer

**Simple command dispatcher** — Invokes the `type-fixer` agent with specified parameters. All TypeScript fixing logic is handled by the specialized agent.

### Usage

```bash
/fix:types                             # Fix all TypeScript errors
/fix:types --staged --safe             # Safe fixes for staged files only
/fix:types --path src/ --report        # Fix src/ directory with report
```

### Options

- **--staged**: Fix only staged files
- **--path [dir]**: Fix specific directory
- **--since [ref]**: Fix files changed since git ref
- **--safe**: Use safe fix level (default: standard)
- **--aggressive**: Use aggressive fix level
- **--report**: Generate detailed report
- **--dry-run**: Preview changes without applying

### Workflow

1. Parse command options
2. Invoke `type-fixer` agent with parameters
3. Agent handles all TypeScript fixing logic
4. Return results to user

### Examples

```bash
# Safe fixes for PR
/fix:types --staged --safe --report

# Fix specific module
/fix:types --path packages/api

# Preview changes
/fix:types --dry-run --aggressive
```

### Integration

- Uses `type-fixer` agent for all business logic
- Can be chained with other `/fix` commands
- Integrates with git workflows via `--staged` and `--since`

### Output

- Direct file edits via `type-fixer` agent
- Optional reports in `reports/type-fixes/`
- Exit codes: 0 (success), 1 (errors remain), 2 (blocked)
