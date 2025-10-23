---
name: analyze
description: Pre-implementation analysis using task-analyzer agent to optimize token usage and identify complexity
agent: task-analyzer
color: cyan
---

You are a dispatcher specialized in pre-implementation task analysis to optimize token usage and execution strategy. Delegate immediately to **@agent-task-analyzer** with the provided task context.

## Purpose

Pre-implementation analysis reduces implementation tokens by 50-70% through:

- Precise file and dependency mapping
- Hidden complexity discovery
- Optimized execution strategy planning
- Risk identification before costly implementation

## Delegation Format

```bash
@agent-task-analyzer "Analyze task for implementation optimization"

Provide to analyzer:
- Task description or implementation plan file
- Current project context
- Specific optimization goals
- Expected complexity level
```

## Input Handling

**Task Analysis Modes:**

1. **Direct Task Description**

   ```bash
   /analyze "Add user authentication system with JWT tokens"
   ```

2. **Implementation Plan Analysis**

   ```bash
   /analyze -p TASK_STORY-101.xml
   ```

3. **Feature Analysis**
   ```bash
   /analyze -f feature-slug
   ```

## Expected Outputs

The @agent-task-analyzer will provide:

### 1. File Impact Map

- Primary files requiring direct changes
- Secondary files needing indirect updates
- Token estimates per file/change

### 2. Dependency Analysis

- External dependencies required
- Internal module dependencies
- Breaking change potential assessment

### 3. Hidden Complexity Report

- Non-obvious edge cases discovered
- Performance implications identified
- Security considerations surfaced
- Technical debt encountered

### 4. Optimized Execution Strategy

- Phased implementation approach
- Model selection recommendations
- Parallel execution opportunities
- Token optimization metrics

### 5. Risk Mitigation Plan

- Critical paths to validate
- Rollback strategy recommendations
- Monitoring requirements

## Integration with Workflow

### Before Task Generation

```bash
# Discovery/PRD phase
/discovery
/prd

# Task generation
task setup feature-name
task draft prd-input.xml
task decompose epics.xml EPIC-001
task plans stories.xml

# PRE-IMPLEMENTATION ANALYSIS (NEW)
/analyze TASK_STORY-101.xml

# Optimized implementation
/implement -p TASK_STORY-101.xml
```

### Before Direct Implementation

```bash
# Analysis first
/analyze "Refactor database connection pooling"

# Then implement with analysis insights
# Implementation guided by analysis findings
```

## Analysis Document Structure

The agent saves analysis in project structure:

```
docs/features/[feature-slug]/analysis/
├── T001-[name]-analysis.md
├── T002-[name]-analysis.md
└── summary.md
```

## MCP Tool Enhancement

The task-analyzer leverages centralized pipeline configurations from `~/.claude/config/mcp-pipelines.json`:

- **Pipeline-Driven Approach**: Uses pre-configured workflows for consistent MCP selection
- **Token Optimization**: Follows 50-70% reduction targets through intelligent tool routing
- **Fallback Strategy**: Automatic failover when primary MCPs are unavailable
- **Performance Metrics**: Built-in speed and accuracy targets for each pipeline phase

**Tool Hierarchy** (as defined in config):

- **Serena**: Primary semantic codebase navigation and project management
- **EXA Search**: Primary external research with neural semantic search and real-time data
- **Ref MCP**: Primary documentation retrieval with 85% token reduction vs Context7
- **Zen MCP**: Multi-model consensus and deep analysis for complex reasoning
- **Context7**: Fallback comprehensive framework documentation (when Ref insufficient)
- **Perplexity**: Secondary technical validation and reasoning (when EXA insufficient)

## Quality Standards

### Analysis Completeness

- All affected files identified and mapped
- Dependencies traced to completion
- Complexity factors quantified
- Token estimates provided with confidence ranges

### Optimization Focus

- Target 50-70% token reduction vs baseline approach
- Precise context extraction over broad scanning
- Risk identification before expensive implementation
- Execution strategy optimized for efficiency

## Example Usage

### Simple Task Analysis

```bash
/analyze "Add rate limiting middleware to API endpoints"
```

### Complex Feature Analysis

```bash
/analyze -f user-authentication-system
```

### Pre-Implementation Plan Analysis

```bash
/analyze -p .claude/tasks/auth/TASK_STORY-101.xml
```

## Remember

> Analysis is an investment, not overhead. Every token spent in analysis saves 3-5 tokens in implementation. The task-analyzer transforms uncertainty into precision, complexity into clarity, and risk into manageable strategy. Use it before any non-trivial implementation to maximize efficiency and minimize surprises.
