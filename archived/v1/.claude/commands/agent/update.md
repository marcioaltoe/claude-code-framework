---
allowed-tools: [Task, Read]
description: "Update and optimize existing agents"
---

# /agent:update - Agent Update & Optimization

## Purpose
Update, optimize, and enhance existing agents using the agent-creator meta-agent.

## Usage
```bash
/agent:update [agent-name]                    # Update specific agent
/agent:update [agent-name] --add [capability] # Add new capability
/agent:update [agent-name] --optimize         # Optimize performance
/agent:update [agent-name] --mcp-zen         # Add MCP Zen integration
/agent:update --all --mcp-zen                # Update all agents for MCP
```

## Update Types

### Add Capability
Extend agent with new features
```bash
/agent:update git-analyst --add "merge conflict resolution"
/agent:update task-analyzer --add "complexity scoring"
```

### Optimize Performance
Improve efficiency and resource usage
```bash
/agent:update discovery-agent --optimize
# - Reviews model selection
# - Optimizes tool usage
# - Improves prompt efficiency
```

### MCP Zen Integration
Convert direct model usage to MCP Zen
```bash
/agent:update commit-generator --mcp-zen
# Converts from direct Gemini to MCP Zen routing
```

### Fix Issues
Resolve problems or bugs
```bash
/agent:update pr-generator --fix "breaking changes detection"
```

## Workflow

### 1. Analysis Phase
```yaml
agent: agent-creator
task: Analyze current agent implementation
actions:
  - Load agent definition
  - Identify improvement areas
  - Check best practices compliance
  - Analyze performance metrics
```

### 2. Planning Phase
```yaml
agent: agent-creator
task: Plan updates and improvements
outputs:
  - List of changes needed
  - Risk assessment
  - Compatibility check
  - Migration strategy
```

### 3. Implementation Phase
```yaml
agent: agent-creator
task: Apply updates to agent
changes:
  - Update YAML configuration
  - Enhance system prompt
  - Add new examples
  - Integrate MCP if needed
```

### 4. Validation Phase
```yaml
agent: agent-creator
task: Validate updated agent
checks:
  - Backward compatibility
  - New feature testing
  - Performance benchmarks
  - Integration tests
```

## Common Updates

### 1. MCP Zen Migration
Convert agents to use MCP Zen instead of direct models:
```bash
/agent:update git-analyst --mcp-zen

# Changes:
# - model: gemini-2.5-flash → model: sonnet
# - Adds Task tool
# - Adds MCP Zen configuration section
# - Updates examples to use Task orchestration
```

### 2. Tool Permission Adjustment
Modify agent's tool access:
```bash
/agent:update security-scanner --tools "+Write, -Bash"

# Adds Write permission
# Removes Bash permission
```

### 3. Model Optimization
Adjust model selection for better performance:
```bash
/agent:update code-reviewer --model sonnet

# Downgrade from opus to sonnet if complexity allows
```

### 4. Prompt Enhancement
Improve system prompt and examples:
```bash
/agent:update task-analyzer --enhance-prompt

# - Adds more examples
# - Clarifies edge cases
# - Improves output format
# - Adds quality checklist
```

## Batch Operations

### Update All Agents for MCP Zen
```bash
/agent:update --all --mcp-zen

# Migrates all agents to use MCP Zen
# Preserves functionality while optimizing costs
```

### Optimize All Validators
```bash
/agent:update --type validator --optimize

# Optimizes all validation agents
# Reviews model usage
# Improves performance
```

### Add Logging to All Agents
```bash
/agent:update --all --add "performance logging"

# Adds self-assessment metrics
# Enables performance tracking
```

## Update Report

After updates, generates report with:
- Changes applied
- Performance impact
- Cost implications
- Testing recommendations
- Rollback instructions

## Version Control

```yaml
pre-update:
  - Backup current version
  - Create git branch
  - Document current metrics

post-update:
  - Commit changes
  - Update documentation
  - Tag version
```

## Examples

### Example 1: Add PR Description to Git Analyst
```bash
/agent:update git-analyst --add "PR description generation"

# Adds capability to generate PR descriptions
# Updates prompt with PR examples
# Adds PR template knowledge
```

### Example 2: Optimize Discovery Agent
```bash
/agent:update discovery-agent --optimize

# Reviews all MCP calls
# Optimizes Perplexity usage
# Reduces token consumption
# Improves response time
```

### Example 3: Fix Task Analyzer Output
```bash
/agent:update task-analyzer --fix "output location"

# Fixes file path generation
# Corrects directory structure
# Updates examples
```

## Safety Features

- **Backup**: Always creates backup before updates
- **Validation**: Tests agent after updates
- **Rollback**: Can revert if issues detected
- **Compatibility**: Ensures no breaking changes
- **Documentation**: Updates docs automatically

## Integration Points

- Works with existing agent ecosystem
- Maintains inter-agent compatibility
- Preserves command integrations
- Updates workflow dependencies

## Notes
- Uses agent-creator for intelligent updates
- Preserves agent's core functionality
- Follows Claude Code best practices
- Automatic testing after updates