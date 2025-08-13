---
allowed-tools: [LS, Read, Grep]
description: "List and explore available agents"
---

# /agent:list - Agent Registry

## Purpose
List, search, and explore all available agents in the system.

## Usage
```bash
/agent:list                    # List all agents
/agent:list --type specialist  # List by type
/agent:list --model opus       # List by model
/agent:list --search "git"     # Search agents
/agent:list --details          # Show detailed info
```

## Display Modes

### Standard List
```bash
/agent:list

# Output:
📊 Available Agents (15 total)

Git & Version Control:
  • git-analyst         [sonnet]  - Git change analysis
  • commit-generator    [sonnet]  - Commit message generation
  • pr-generator        [sonnet]  - PR description creation

Development:
  • task-analyzer       [sonnet]  - Pre-implementation analysis
  • code-reviewer       [zen]     - Code review specialist
  • agent-creator       [opus]    - Meta-agent for agent creation

Architecture:
  • orchestrator        [opus]    - PRD orchestration
  • domain-architect    [zen]     - Domain modeling expert
  • technical-architect [zen]     - System design specialist
  • ux-architect        [zen]     - UX design expert

Business & Strategy:
  • business-strategist [zen]     - Business analysis
  • discovery-agent     [zen]     - Feature discovery
  • quality-delivery    [zen]     - Quality assurance

Utilities:
  • mcp-orchestrator    [n/a]     - MCP server routing
```

### Detailed View
```bash
/agent:list --details

# Output:
╔══════════════════════════════════════════════════════════╗
║ git-analyst                                              ║
╠══════════════════════════════════════════════════════════╣
║ Model:       sonnet (via MCP Zen → gemini-2.5-flash)    ║
║ Type:        specialist                                  ║
║ Tools:       Bash, Read, Glob, Task                     ║
║ Purpose:     Git commit analysis and conventional       ║
║              commit standards                           ║
║ Triggers:    git operations, commit analysis            ║
║ Cost:        $0.003/1K tokens (via MCP)                ║
║ Location:    .claude/agents/git-analyst.md             ║
╚══════════════════════════════════════════════════════════╝
```

### Filter by Type
```bash
/agent:list --type orchestrator

# Output:
🎭 Orchestrator Agents (2)
  • orchestrator       [opus]  - PRD creation orchestrator
  • mcp-orchestrator   [n/a]   - MCP server routing
```

### Filter by Model
```bash
/agent:list --model zen

# Output:
🤖 MCP Zen Agents (7)
  • domain-architect    → gemini-2.5-pro
  • technical-architect → gemini-2.5-pro
  • ux-architect        → gpt-5
  • business-strategist → gpt-5
  • discovery-agent     → gemini-2.5-flash
  • quality-delivery    → o3
  • code-reviewer       → gemini-2.5-pro
```

### Search Agents
```bash
/agent:list --search "test"

# Output:
🔍 Search Results for "test" (2)
  • quality-delivery    - Testing strategies and QA
  • code-reviewer       - Includes test validation
```

## Agent Categories

### By Purpose
- **Analysis**: task-analyzer, git-analyst, discovery-agent
- **Generation**: commit-generator, pr-generator, orchestrator
- **Architecture**: domain-architect, technical-architect, ux-architect
- **Quality**: code-reviewer, quality-delivery
- **Meta**: agent-creator, mcp-orchestrator

### By Model Usage
- **Opus Direct**: orchestrator, agent-creator
- **Sonnet + MCP**: git-analyst, commit-generator, task-analyzer
- **Zen Orchestrated**: All architect agents, strategists

### By Workflow Integration
- **Git Workflow**: git-analyst, commit-generator, pr-generator
- **Feature Development**: discovery-agent, orchestrator, architects
- **Quality Gates**: code-reviewer, quality-delivery

## Statistics Dashboard

```bash
/agent:list --stats

# Output:
📈 Agent Ecosystem Statistics

Total Agents:        15
By Model:
  • Opus:           2 (13%)
  • Sonnet + MCP:   6 (40%)
  • Zen:            7 (47%)

Cost Profile:
  • High:           2 agents (Opus)
  • Medium:         7 agents (Zen)
  • Low:            6 agents (Sonnet/MCP)

Tool Usage:
  • Read:           14 agents
  • Task:           9 agents
  • Bash:           5 agents
  • Write/Edit:     3 agents

Integration:
  • Git Commands:   3 agents
  • Feature Flow:   8 agents
  • Standalone:     4 agents
```

## Agent Health Check

```bash
/agent:list --health

# Output:
🏥 Agent Health Status

✅ Healthy (12)
  All configurations valid

⚠️ Needs Update (3)
  • git-analyst       - Can optimize MCP usage
  • task-analyzer     - Output path needs fixing
  • discovery-agent   - Perplexity integration incomplete

❌ Issues (0)
  No critical issues found
```

## Dependency Map

```bash
/agent:list --dependencies

# Output:
🔗 Agent Dependencies

git:push
  └→ pr-generator
       └→ git-analyst

feature:prd
  └→ orchestrator
       ├→ business-strategist
       ├→ ux-architect
       ├→ domain-architect
       ├→ technical-architect
       └→ quality-delivery

git:commit
  └→ commit-generator
       └→ git-analyst
```

## Export Options

### Export as JSON
```bash
/agent:list --export json > agents.json
```

### Export as Markdown
```bash
/agent:list --export markdown > agents.md
```

### Export Configuration
```bash
/agent:list --export config > agent-config.yaml
```

## Interactive Mode

```bash
/agent:list --interactive

# Provides menu:
1. View agent details
2. Test agent
3. Update agent
4. View usage examples
5. Check dependencies
```

## Notes
- List is generated from `.claude/agents/` directory
- Includes real-time validation
- Shows MCP Zen routing information
- Displays cost implications
- Tracks agent health and optimization opportunities