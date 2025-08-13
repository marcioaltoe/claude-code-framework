---
allowed-tools: [Task, Read, Glob, Bash, Edit]
description: "Task analysis command with organized output structure"
---

# /analyze - Task Analysis Command

## Purpose
Performs pre-implementation analysis of tasks with proper organization of output files in feature directories.

## Usage
```bash
/analyze --task T001                    # Analyze specific task
/analyze --prd path/to/prd.md          # Analyze from PRD
/analyze --feature feat-slug --task T001 # Analyze with feature context
/analyze --update T001                   # Update existing analysis
```

## Output Organization

### Standard Structure
```
docs/features/
└── feat-[slug]/
    └── 04-implementation/
        └── analysis/
            ├── T001-[name]-analysis.md     # Task-specific
            ├── T002-[name]-analysis.md     # Task-specific
            └── feature-overview.md         # Feature-level summary
```

### File Naming Patterns
- **Task Analysis**: `T[XXX]-[descriptive-name]-analysis.md`
- **Sequential Updates**: `T[XXX]-[name]-update-001.md`
- **Feature Overview**: `feature-overview.md`

## Options

### --task TASK_ID
Analyze specific task from tasks.md

### --prd PATH
Extract task from PRD path and analyze

### --feature SLUG
Specify feature context for organization

### --update
Update existing analysis instead of creating new

### --scope [full|minimal|quick]
Analysis depth:
- `full`: Complete analysis with all MCPs
- `minimal`: Essential files only
- `quick`: Rapid assessment

## Integration with task-analyzer Agent

The command automatically:
1. Invokes `task-analyzer` agent
2. Determines feature context
3. Creates proper directory structure
4. Generates analysis with correct naming
5. Links to related documents

## Workflow

### 1. Context Detection
```yaml
# From PRD path
path: docs/features/feat-etl-erp/02-requirements/prd.md
feature: feat-etl-erp
task: (extracted from PRD)

# From explicit parameters
feature: feat-etl-erp
task: T001
```

### 2. Directory Creation
```bash
mkdir -p docs/features/${FEATURE}/04-implementation/analysis
```

### 3. Analysis Generation
```yaml
agent: task-analyzer
model: flash/gemini-2.5-flash
output: docs/features/${FEATURE}/04-implementation/analysis/${TASK}-analysis.md
```

### 4. Linking
Updates references in:
- `04-implementation/tasks.md`
- `04-implementation/workflow.md`
- Feature README if exists

## Examples

### Analyze from PRD
```bash
/analyze --prd docs/features/feat-etl-erp/02-requirements/prd.md
# Output: docs/features/feat-etl-erp/04-implementation/analysis/T001-organization-analysis.md
```

### Analyze Specific Task
```bash
/analyze --feature etl-erp --task T002
# Output: docs/features/feat-etl-erp/04-implementation/analysis/T002-pipeline-analysis.md
```

### Update Existing Analysis
```bash
/analyze --update T001 --feature etl-erp
# Output: docs/features/feat-etl-erp/04-implementation/analysis/T001-organization-update-001.md
```

### Quick Assessment
```bash
/analyze --task T003 --scope quick
# Rapid analysis for simple tasks
```

## Output Format

Each analysis includes:
1. **Metadata**: Task ID, feature, timestamp, cost
2. **Executive Summary**: Opus vs Flash allocation
3. **File Mapping**: Precise files needed
4. **MCP Strategy**: Which tools handle what
5. **Implementation Plan**: Phased approach
6. **Risk Analysis**: Complexity assessment
7. **Cost Savings**: Token usage comparison

## Best Practices

1. **Always specify feature context** for proper organization
2. **Run before implementation** to optimize token usage
3. **Update analyses** when requirements change
4. **Link analyses** in task tracking documents
5. **Archive old analyses** when tasks complete

## Error Handling

- Missing feature context � Prompts for feature
- No task found � Lists available tasks
- Duplicate analysis � Suggests update flag
- Invalid path � Shows correct structure

## Integration Points

### With /implement
```bash
/analyze --task T001
/implement --task T001  # Uses the analysis
```

### With /feature
```bash
/feature init "New payment system"
/analyze --feature payment --task T001
```

### With task-reviewer
Analysis outputs are used by code-reviewer for validation