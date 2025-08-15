---
name: fix
description: "Unified command dispatcher for types, lint, and tests fixing"
type: maintainer
category: quality
complexity: simple
scope: project
allowed-tools: [Task]

# Activation Configuration
activation:
  manual-commands: ["/fix"]
  flags:
    [
      "--all",
      "--types",
      "--lint",
      "--tests",
      "--staged",
      "--safe",
      "--aggressive",
    ]

# Integration Configuration
framework-integration:
  commands:
    - fix-types
    - fix-lint
    - fix-tests

# Performance Profile
performance-profile: lightweight
performance-targets:
  dispatch: "<10s"
  parallel-execution: "supported"
---

## /fix - Unified Fixer Dispatcher

**Simple umbrella command** — Routes to specialized fix commands (`/fix:types`, `/fix:lint`, `/fix:tests`) based on flags.

### Usage

```bash
/fix --all                             # Run all fixers
/fix --types --lint                    # Run specific fixers
/fix --staged --safe                   # Safe fixes for staged files
```

### Options

**Target Selection:**

- **--all**: Run types, lint, and tests fixers
- **--types**: Run TypeScript fixer only
- **--lint**: Run Biome fixer only
- **--tests**: Run Vitest fixer only

**Scope Options:**

- **--staged**: Fix only staged files
- **--path [dir]**: Fix specific directory
- **--since [ref]**: Fix files changed since git ref

**Fix Level:**

- **--safe**: Use safe fix level (default: standard)
- **--aggressive**: Use aggressive fix level

**Output:**

- **--report**: Generate reports for all fixers
- **--dry-run**: Preview changes without applying
- **--review**: Invoke code-reviewer after fixes

### Workflow

1. Parse command options
2. Determine which fixers to run
3. Execute fixers in parallel or sequence
4. Aggregate results

### Examples

```bash
# Fix everything safely for PR
/fix --all --staged --safe --report

# Quick type and lint check
/fix --types --lint --dry-run

# Aggressive fix with review
/fix --all --aggressive --review
```

### Routing Logic

```yaml
--all: ["/fix:types", "/fix:lint", "/fix:tests"]
--types: ["/fix:types"]
--lint: ["/fix:lint"]
--tests: ["/fix:tests"]
default (no flags): ["/fix:types", "/fix:lint"]
```

### Integration

- Dispatches to specialized fix commands
- Aggregates exit codes (0: all success, 1: some errors, 2: blocked)
- Can run fixers in parallel for better performance

### Output

- Combined results from all executed fixers
- Aggregated reports in `reports/fix/`
- Summary of all fixes applied
