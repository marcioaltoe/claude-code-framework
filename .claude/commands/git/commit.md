---
allowed-tools: [Bash, Task]
description: "Smart commit with automatic analysis and conventional standards"
---

# /git:commit - Always Smart Commit

## Purpose
Automatically analyze changes and create commits following conventional standards.

## Usage
```bash
/git:commit              # Analyze and commit with generated message
/git:commit --amend      # Amend previous commit with analysis
```

## Workflow

Every commit automatically follows this smart flow:

### 1. Pre-check Phase
- Verify staged changes exist
- Check for uncommitted changes
- Validate working directory state

### 2. Analysis Phase
```yaml
agent: git-analyst
task: Analyze all staged changes using Gemini Flash
output:
  - Commit type detection (feat/fix/refactor/etc)
  - Scope identification (domain/application/etc)
  - Breaking changes detection
  - File grouping suggestions
  - Generated commit message
```

### 3. Message Generation
```yaml
agent: commit-message-generator  
model: gemini-2.5-flash
task: Create conventional commit message
output:
  - Subject line (<50 chars, imperative)
  - Optional body (detailed description)
  - Optional footer (breaking changes, issues)
```

### 4. Validation & Confirmation
- Show generated message to user
- Display affected files
- Highlight any breaking changes
- Ask for confirmation (Y/n)

### 5. Execution
- Run pre-commit hooks (test, lint, type-check)
- Create commit with generated message
- Show success confirmation

## Examples

### Standard flow
```bash
/git:commit
# Automatically:
# 1. Analyzes staged changes
# 2. Generates: "feat(domain): add Organization entity with ULID support"
# 3. Shows preview and confirms
# 4. Creates commit
```

### With amendment
```bash
/git:commit --amend
# Analyzes new changes and amends previous commit
```

## Integration Points
- **git-analyst**: Central intelligence for change analysis (Gemini Flash)
- **commit-message-generator**: Specialized message creation (Gemini Flash)
- **Pre-commit hooks**: Automatic quality gates (test, lint, type-check)
- **Configuration**: Uses `.claude/config/git.json` settings

## Notes
- No manual message option - always uses intelligent analysis
- Focuses on quality over speed - proper analysis prevents bad commits
- Uses Gemini Flash to preserve Opus tokens for code generation
- Automatically detects and handles breaking changes