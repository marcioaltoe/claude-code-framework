---
allowed-tools: [Task, Read, Grep, Glob]
description: "Analyze agent ecosystem for optimization opportunities"
---

# /agent:analyze - Agent Ecosystem Analysis

## Purpose
Deep analysis of the agent ecosystem to identify optimization opportunities, redundancies, and improvement areas.

## Usage
```bash
/agent:analyze                      # Full ecosystem analysis
/agent:analyze [agent-name]         # Analyze specific agent
/agent:analyze --performance        # Performance analysis
/agent:analyze --cost              # Cost optimization analysis
/agent:analyze --coverage          # Coverage gap analysis
```

## Analysis Types

### Full Ecosystem Analysis
```bash
/agent:analyze

# Analyzes:
# - Agent overlap and redundancy
# - Missing capabilities
# - Integration opportunities
# - Cost optimization potential
# - Performance bottlenecks
```

### Individual Agent Analysis
```bash
/agent:analyze git-analyst

# Reports:
# - Current configuration
# - Usage patterns
# - Performance metrics
# - Optimization opportunities
# - Integration suggestions
```

### Performance Analysis
```bash
/agent:analyze --performance

# Metrics:
# - Response times by agent
# - Token consumption
# - Model efficiency
# - Tool usage patterns
# - Bottleneck identification
```

### Cost Analysis
```bash
/agent:analyze --cost

# Evaluates:
# - Token usage by agent
# - Model cost distribution
# - Optimization opportunities
# - ROI per agent
# - Cost reduction strategies
```

## Analysis Workflow

### 1. Data Collection
```yaml
agent: agent-creator
task: Collect agent ecosystem data
gathers:
  - All agent configurations
  - Usage patterns from commands
  - Integration points
  - Performance metrics
```

### 2. Pattern Analysis
```yaml
agent: agent-creator
task: Identify patterns and issues
analyzes:
  - Redundant capabilities
  - Missing coverage areas
  - Inefficient model usage
  - Suboptimal tool permissions
```

### 3. Optimization Planning
```yaml
agent: agent-creator
task: Generate optimization plan
produces:
  - Specific recommendations
  - Priority ranking
  - Implementation steps
  - Expected improvements
```

### 4. Report Generation
```yaml
agent: agent-creator
task: Create comprehensive report
includes:
  - Executive summary
  - Detailed findings
  - Recommendations
  - Action items
```

## Report Sections

### Executive Summary
```markdown
## Agent Ecosystem Analysis - Executive Summary

**Date**: 2024-01-15
**Total Agents**: 15
**Health Score**: 78/100

### Key Findings
1. 3 agents can be migrated to lower-cost models
2. 2 agents have overlapping responsibilities
3. Missing coverage for database operations
4. 30% cost reduction possible with MCP optimization

### Immediate Actions
1. Migrate git-analyst to full MCP Zen
2. Merge overlapping capabilities
3. Create database specialist agent
```

### Detailed Analysis
```markdown
## Detailed Findings

### 1. Model Optimization
- **git-analyst**: Can use gemini-flash instead of sonnet
- **code-reviewer**: Over-provisioned, can use gpt-5 via Zen
- **task-analyzer**: Optimize to use flash exclusively

### 2. Capability Gaps
- No database migration specialist
- Missing API documentation generator
- No performance profiling agent

### 3. Integration Opportunities
- git-analyst + pr-generator can share context
- All architects can use shared domain model
- Discovery outputs can auto-trigger analysis
```

### Cost Optimization
```markdown
## Cost Analysis

### Current Monthly Estimate
- Opus agents: $120 (2 agents, heavy usage)
- Zen agents: $80 (7 agents, moderate usage)
- Sonnet+MCP: $40 (6 agents, optimized)
**Total: $240/month**

### After Optimization
- Opus agents: $80 (reduced usage)
- Zen agents: $60 (better routing)
- Sonnet+MCP: $30 (improved efficiency)
**Projected: $170/month (29% reduction)**

### Recommendations
1. Implement MCP caching
2. Use Perplexity for all web searches
3. Route simple tasks to Flash
4. Batch related operations
```

### Coverage Matrix
```markdown
## Capability Coverage

| Domain            | Coverage | Agents                    | Gaps           |
|-------------------|----------|---------------------------|----------------|
| Git Operations    | 95%      | 3 agents                  | Merge tools    |
| Architecture      | 90%      | 4 agents                  | Microservices  |
| Testing           | 70%      | 2 agents                  | E2E, Load      |
| Documentation     | 60%      | 1 agent                   | API docs       |
| Database          | 30%      | 0 dedicated               | Migration, opt |
| Security          | 85%      | 2 agents                  | Pen testing    |
| Performance       | 40%      | 1 agent                   | Profiling      |
```

### Redundancy Analysis
```markdown
## Redundancy & Overlap

### Duplicate Capabilities
1. **Commit Analysis**
   - git-analyst: Full analysis
   - commit-generator: Partial analysis
   - Recommendation: Centralize in git-analyst

2. **Code Quality**
   - code-reviewer: Full review
   - quality-delivery: Partial review
   - Recommendation: Specialize responsibilities

### Consolidation Opportunities
- Merge technical + domain architects for small projects
- Combine git agents into git-suite
- Unify discovery + business strategy
```

### Performance Metrics
```markdown
## Performance Analysis

### Response Times
| Agent               | Avg Time | 95th % | Status    |
|---------------------|----------|--------|-----------|
| git-analyst         | 2.3s     | 4.1s   | ✅ Good   |
| orchestrator        | 45s      | 62s    | ⚠️ Slow   |
| task-analyzer       | 1.8s     | 3.2s   | ✅ Good   |
| code-reviewer       | 12s      | 18s    | ⚠️ Slow   |

### Token Efficiency
| Agent               | Avg Tokens | Cost/Call |
|---------------------|------------|-----------|
| orchestrator        | 15,000     | $0.30     |
| discovery-agent     | 8,000      | $0.08     |
| git-analyst         | 500        | $0.005    |
```

## Recommendations Priority

### High Priority
1. **Migrate to MCP Zen** (30% cost reduction)
   - All non-opus agents should use MCP
   - Implement proper fallback chains

2. **Create Missing Agents** (improve coverage)
   - Database specialist
   - API doc generator
   - Performance profiler

3. **Optimize Expensive Agents**
   - Reduce orchestrator scope
   - Cache discovery outputs

### Medium Priority
1. **Consolidate Overlapping Agents**
2. **Implement Agent Metrics Tracking**
3. **Create Agent Test Suite**

### Low Priority
1. **Visual Agent Dashboard**
2. **Agent Version Management**
3. **Custom Agent Templates**

## Action Items

```yaml
immediate: # This week
  - Update git-analyst for full MCP
  - Create database specialist agent
  - Implement basic metrics

short_term: # This month
  - Consolidate git agents
  - Add performance profiler
  - Optimize orchestrator

long_term: # This quarter
  - Full ecosystem redesign
  - Implement agent marketplace
  - Create visual management tools
```

## Export Options

```bash
# Export full report
/agent:analyze --export markdown > analysis.md

# Export recommendations only
/agent:analyze --export actions > actions.yaml

# Export metrics
/agent:analyze --export metrics > metrics.json
```

## Notes
- Uses agent-creator for intelligent analysis
- Provides actionable recommendations
- Tracks improvement over time
- Integrates with cost management
- Supports continuous optimization