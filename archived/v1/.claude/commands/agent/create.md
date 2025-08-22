---
allowed-tools: [Task]
description: "Create new specialized agents using agent-creator"
---

# /agent:create - Agent Creation

## Purpose
Create new specialized agents following Claude Code best practices using the agent-creator meta-agent.

## Usage
```bash
/agent:create [type] [name]           # Create agent of specific type
/agent:create specialist api-tester   # Create specialist agent
/agent:create orchestrator workflow   # Create orchestrator agent
/agent:create validator security      # Create validator agent
```

## Agent Types

### specialist
Single-responsibility expert focused on one domain
- Examples: api-tester, db-optimizer, css-stylist

### orchestrator
Coordinates multiple agents for complex workflows
- Examples: feature-dev, deployment, migration

### validator
Ensures quality and compliance
- Examples: security-gate, performance-checker, lint-runner

### researcher
Information gathering and analysis
- Examples: codebase-analyzer, dependency-mapper, doc-reader

## Workflow

### 1. Requirements Gathering
```yaml
agent: agent-creator
task: Analyze requirements for new agent
inputs:
  - Type of agent needed
  - Domain expertise required
  - Integration points
output:
  - Agent design specification
```

### 2. Configuration Design
```yaml
agent: agent-creator
task: Design optimal configuration
decisions:
  - Model selection (haiku/sonnet/opus)
  - Tool permissions needed
  - MCP Zen integration requirements
  - Trigger patterns
```

### 3. Implementation
```yaml
agent: agent-creator
task: Generate complete agent definition
creates:
  - YAML frontmatter configuration
  - System prompt with examples
  - Integration instructions
  - Test scenarios
```

### 4. Validation
```yaml
agent: agent-creator
task: Validate agent configuration
checks:
  - Syntax correctness
  - Tool permission boundaries
  - MCP integration setup
  - Best practices compliance
```

### 5. Deployment
```yaml
location: .claude/agents/[agent-name].md
integration: Update relevant commands if needed
documentation: Add to agent registry
```

## Examples

### Create API Testing Specialist
```bash
/agent:create specialist api-tester

# Creates agent that:
# - Uses MCP Zen for intelligent testing
# - Validates REST endpoints
# - Checks response schemas
# - Measures performance
```

### Create Feature Development Orchestrator
```bash
/agent:create orchestrator feature-dev

# Creates agent that:
# - Coordinates discovery, PRD, implementation
# - Manages agent handoffs
# - Tracks progress
# - Ensures quality gates
```

### Create Security Validator
```bash
/agent:create validator security-audit

# Creates agent that:
# - Scans for vulnerabilities
# - Checks OWASP compliance
# - Validates authentication
# - Reviews encryption
```

## Integration with MCP Zen

All created agents will automatically include:
- Proper MCP Zen configuration
- Model routing through MCP Orchestrator
- Fallback strategies
- Cost optimization

## Advanced Options

### Custom Requirements
```bash
/agent:create custom --requirements "Need agent for GraphQL testing with subscription support"
```

### From Template
```bash
/agent:create from-template fullstack-dev
```

### With Specific Tools
```bash
/agent:create specialist logger --tools "Read, Write, Bash"
```

## Quality Assurance

Every created agent includes:
- ✅ Single responsibility principle
- ✅ Clear activation triggers
- ✅ Minimal necessary permissions
- ✅ Comprehensive documentation
- ✅ Example usage scenarios
- ✅ Error handling
- ✅ Self-assessment metrics

## Output Structure

```
.claude/agents/
└── [agent-name].md
    ├── YAML frontmatter
    ├── System prompt
    ├── Capabilities
    ├── Workflow
    ├── Examples
    └── Integration guide
```

## Notes
- Agent-creator uses Opus for complex agent design
- All agents follow Claude Code best practices
- Automatic MCP Zen integration for non-Opus models
- Version controlled in Git