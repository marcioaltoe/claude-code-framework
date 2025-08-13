# Claude Code Framework

A comprehensive configuration framework for Claude Code CLI, featuring specialized agents, custom commands, rules, and templates. This framework is built upon learnings from AI for Development courses by [Rodrigo Branas](https://branas.io/) and [Pedro Nauck](https://compozy.com/).

## 🏗️ Framework Structure

```
.claude/
├── agents/           # Specialized AI agents for different tasks
├── commands/         # Custom slash commands
├── config/          # Configuration files
├── rules/           # Development rules and standards
└── templates/       # Document templates
```

## 🤖 Specialized Agents

This framework includes purpose-built agents for different development workflows:

### Architecture & Planning
- **domain-architect**: Domain-driven design expert using MCP Zen
- **technical-architect**: Clean Architecture expert for system design
- **business-strategist**: Business strategy and market analysis
- **ux-architect**: UX design expert for creative solutions

### Development & Quality
- **implementation-specialist**: TypeScript, DDD, and Clean Architecture implementation
- **code-reviewer**: Strict code review following established processes
- **task-analyzer**: Pre-implementation analysis to minimize token usage
- **quality-delivery**: QA and delivery expert with comprehensive strategies

### Git & Collaboration
- **git-analyst**: Git commit analysis specialist
- **commit-message-generator**: Conventional commit message generation
- **pr-description-generator**: Comprehensive PR description creation

### Orchestration
- **orchestrator**: Master orchestrator for PRD creation
- **mcp-orchestrator**: Intelligent MCP server routing
- **agent-creator**: Meta-agent for creating and updating subagents
- **discovery-agent**: Active feature discovery specialist

## 📋 Custom Commands

### Feature Development
- `/feature` - Feature development workflows
  - `/feature/discovery` - Feature discovery process
  - `/feature/prd` - Product Requirements Document creation
  - `/feature/techspec` - Technical specification generation
  - `/feature/tasks` - Task breakdown and planning

### Agent Management
- `/agent` - Agent management commands
  - `/agent/create` - Create new specialized agents
  - `/agent/update` - Update existing agents
  - `/agent/list` - List available agents
  - `/agent/analyze` - Analyze agent performance

### Git Operations
- `/git` - Enhanced git workflows
  - `/git/commit` - Smart conventional commits
  - `/git/branch` - Branch management
  - `/git/push` - Enhanced push operations
  - `/git/sync` - Repository synchronization

### Analysis & Implementation
- `/analyze` - Code analysis workflows
- `/implement` - Implementation guidance

## 📚 Rules & Standards

### Core Principles
- **Pragmatism over Purism**: Functionality first, perfect architecture second
- **Clean Architecture & DDD**: Applied where they add clear value
- **TypeScript-first**: Strict typing with meaningful types
- **Test-Driven Development**: Tests first, implementation second

### Technology Standards
- **Runtime**: Bun (never npm/yarn)
- **Testing**: Vitest (never built-in test runners)
- **Schema Validation**: TypeBox for backends, Zod for React frontends
- **Database**: Drizzle ORM with SQL best practices
- **IDs**: ULID instead of UUID

## 🔌 MCP (Model Context Protocol) Servers

This framework leverages multiple MCP servers for enhanced capabilities:

### Available MCP Servers

| Server | Purpose | Documentation |
|--------|---------|---------------|
| **context7** | Library documentation and code examples | [Context7 MCP](https://github.com/codeium/context7-mcp) |
| **Docker_MCP_Toolkit** | Docker container management | [Docker MCP](https://github.com/codeium/docker-mcp) |
| **magic** | UI component generation and logo search | [Magic MCP](https://github.com/codeium/magic-mcp) |
| **perplexity-mcp** | Web search and reasoning | [Perplexity MCP](https://github.com/codeium/perplexity-mcp) |
| **playwright** | Browser automation and testing | [Playwright MCP](https://github.com/codeium/playwright-mcp) |
| **sequential-thinking** | Step-by-step problem solving | [Sequential Thinking MCP](https://github.com/codeium/sequential-thinking-mcp) |
| **zen** | Comprehensive AI workflows | [Zen MCP](https://github.com/codeium/zen-mcp) |
| **serena** | Semantic code analysis | [Serena MCP](https://github.com/codeium/serena-mcp) |
| **filesystem-with-morph** | Advanced file operations | [Filesystem Morph MCP](https://github.com/codeium/filesystem-with-morph-mcp) |

### MCP Server Capabilities

- **Code Analysis**: Semantic understanding with Serena
- **UI Generation**: Component creation with Magic
- **Documentation**: Real-time library docs via Context7
- **Testing**: Browser automation with Playwright
- **Reasoning**: Advanced problem-solving with Sequential Thinking
- **Search**: Web research capabilities with Perplexity
- **Infrastructure**: Docker management toolkit

### Configuration

To configure these MCP servers, add the `mcpServers` section to your `~/.claude.json` file. See [mcp-config-example.json](mcp-config-example.json) for a complete configuration template with all servers.

**Required API Keys:**
- Magic: Get your API key from [21st.dev](https://21st.dev)
- Perplexity: Get your API key from [Perplexity API](https://docs.perplexity.ai/docs/getting-started)
- Zen: Requires OpenAI, Gemini, and/or OpenRouter API keys
- Morph: Get your API key from [Morph](https://morph.so)

**No API Keys Required:**
- Context7, Docker_MCP_Toolkit, Playwright, Sequential-thinking, Serena

## 🚀 Getting Started

1. **Install Claude Code CLI**
   ```bash
   npm install -g @anthropic/claude-code
   ```

2. **Clone this framework**
   ```bash
   git clone <your-repo-url>
   cd claude-code-framework
   ```

3. **Copy configuration to your global Claude directory**
   ```bash
   cp -r .claude/* ~/.claude/
   ```

4. **Configure MCP servers** in `~/.claude.json` (see [mcp-config-example.json](mcp-config-example.json) for configuration template)

5. **Start using specialized agents and commands**
   ```bash
   claude /agent/list
   claude /feature/discovery "new user authentication"
   ```

## 🎓 Credits & Inspiration

This framework is built upon learnings and best practices shared by:

- **[Rodrigo Branas](https://branas.io/)** - Full-stack development expertise and Clean Architecture principles
- **[Pedro Nauck](https://compozy.com/)** - AI-driven development workflows and modern tooling

Special thanks to their AI for Development course which provided the foundation for these patterns and practices.

## 📖 Documentation

For detailed information about specific components:

- **Rules**: See individual files in `.claude/rules/`
- **Agents**: Each agent has comprehensive documentation in `.claude/agents/`
- **Templates**: Standard document templates in `.claude/templates/`
- **Claude Code CLI**: [Official Documentation](https://docs.anthropic.com/en/docs/claude-code)

## 🤝 Contributing

This framework follows the established rules and standards. Before contributing:

1. Review the rules in `.claude/rules/`
2. Follow the git workflow in `.claude/rules/git-workflow.md`
3. Use conventional commits
4. Ensure all tests pass with `bun run test`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Framework Version: 1.0.0 | Last Updated: August 2025*
