# Claude Code Framework

A comprehensive configuration framework for Claude Code CLI, featuring specialized agents, custom commands, rules, and templates. This framework is built upon learnings from AI for Development by [Rodrigo Branas](https://branas.io/) and [Pedro Nauck](https://compozy.com/).

## 🏗️ Framework Structure

```
.claude/
├── agents/          # Specialized AI agents for different tasks
├── commands/        # Custom slash commands
├── config/          # Configuration files
├── rules/           # Development rules and standards
└── templates/       # Document templates
```

## 🤖 Specialized Agents

This framework includes purpose-built agents for different development workflows:

### Architecture & Planning

- **software-architect**: System design, Clean Architecture patterns, technical solutions
- **database-architect**: Database design, Drizzle ORM, schema optimization, migrations
- **react-clean-architect**: React Clean Architecture, state management, custom hooks

### Development & Implementation

- **api-standards-expert**: API design patterns, HTTP standards, Hono framework
- **react-coder**: React 19 component development, simplicity-first philosophy
- **typescript-expert**: TypeScript guidance, type errors, advanced type features
- **task-implementation-orchestrator**: Task execution coordination from plans

### Quality & Testing

- **tdd-test-engineer**: Test-Driven Development with Vitest, mocking strategies
- **tech-lead-reviewer**: Technical leadership, code review, architecture decisions
- **design-review**: UI/UX compliance, visual consistency, accessibility
- **ux-guardian**: Edge case discovery, user journey testing, critical test paths

### Code Quality & Fixing

- **typescript-diagnostics-fixer**: Automated TypeScript error resolution
- **biome-lint-fixer**: Automated Biome linting fixes with rule awareness

### Product & Business

- **business-analyst**: Requirements gathering, process modeling, use cases
- **product-manager-prd**: PRD creation, feature specification, success metrics
- **domain-expert-validator**: Domain logic validation, business rule verification
- **ux-ui-designer**: UI/UX design, wireframes, design systems, accessibility

### Workflow & Orchestration

- **git-workflow**: Git operations, conventional commits, branch strategies
- **task-analyzer**: Pre-implementation analysis for token optimization

## 📋 Slash Commands

### Feature Development

- `/feature:discovery` - Feature discovery and planning process
- `/feature:prd` - Product Requirements Document creation
- `/feature:techspec` - Technical specification generation
- `/feature:tasks` - Task breakdown and planning
- `/feature:workflow` - Complete feature development workflow

### Code Quality & Fixing

- `/fix:types` - TypeScript error fixing with automated diagnostics
- `/fix:lint` - Biome linting with rule-aware automated fixes
- `/fix:tests` - Vitest failure analysis and TDD-based fixes

### Git Operations

- `/git:commit` - Smart conventional commits (feature branches only)
- `/git:branch` - Create feature branch from dev
- `/git:push` - Push changes and create PR to dev
- `/git:sync` - Synchronize local repository with dev branch

### Analysis & Implementation

- `/analyze` - Pre-implementation analysis for token optimization
- `/implement` - Task execution from plans and specifications

### Design & Testing

- `/design:review` - UI/UX compliance and accessibility review

## 📚 Rules & Standards

### Core Principles

- **Clean Architecture & DDD**: Applied where they add clear value
- **TypeScript-first**: Strict typing with meaningful types
- **Test-Driven Development**: Tests first, implementation second

### Fundamental Design Principles

- **DRY (Don't Repeat Yourself)**: Single source of truth for knowledge
- **YAGNI (You Aren't Gonna Need It)**: Implement only when actually needed
- **KISS (Keep It Simple, Stupid)**: Simplicity as key design goal
- **TDA (Tell, Don't Ask)**: Tell objects what to do, don't ask for their data
- **SOLID Principles**: Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **Object Calisthenics**: 9 rules for better object-oriented code quality

### Technology Standards

- **Runtime**: Bun (never npm/yarn) - `bun run test`, never `bun test`
- **Testing**: Vitest via `bun run test` with TDD approach
- **Schema Validation**: TypeBox for backends, Zod for React frontends
- **Database**: Drizzle ORM with PostgreSQL, snake_case tables, camelCase TypeScript
- **IDs**: ULID instead of UUID
- **API**: Hono for HTTP routing (not Express or Bun.serve)
- **Logging**: Structured JSON logging with Winston

### Code Quality Standards

- **TypeScript Patterns**: Never use `any`, proper interfaces, type guards
- **Function Design**: Options objects for complex parameters, Result pattern for expected errors
- **Naming Conventions**: Descriptive, consistent, searchable names
- **Folder Structure**: Feature-driven organization with Clean Architecture layers
- **Essential Rules**: Comprehensive development guidelines for consistent code quality

## 🔌 MCP (Model Context Protocol) Servers

This framework leverages multiple MCP servers for enhanced capabilities:

### Available MCP Servers

| Server                    | Purpose                                 | Documentation                                                                                                     |
| ------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **context7**              | Library documentation and code examples | [Context7 MCP](https://context7.com/)                                                                             |
| **Docker_MCP_Toolkit**    | Docker container management             | [Docker MCP](https://www.docker.com/products/mcp-catalog-and-toolkit/)                                            |
| **magic**                 | UI component generation and logo search | [Magic MCP](https://21st.dev/magic)                                                                               |
| **perplexity-mcp**        | Web search and reasoning                | [Perplexity MCP](https://www.perplexity.ai/help-center/en/articles/11502712-local-and-remote-mcps-for-perplexity) |
| **playwright**            | Browser automation and testing          | [Playwright MCP](https://github.com/microsoft/playwright-mcp)                                                     |
| **sequential-thinking**   | Step-by-step problem solving            | [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)       |
| **zen**                   | Comprehensive AI workflows              | [Zen MCP](https://github.com/BeehiveInnovations/zen-mcp-server)                                                   |
| **serena**                | Semantic code analysis                  | [Serena MCP](https://github.com/oraios/serena)                                                                    |
| **filesystem-with-morph** | Advanced file operations                | [Filesystem Morph MCP](https://docs.morphllm.com/guides/claude-code)                                              |

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

- Perplexity: Get your API key from [Perplexity API](https://docs.perplexity.ai/docs/getting-started)
- Zen: Requires OpenAI, Gemini, and/or OpenRouter API keys
- Morph: Get your API key from [Morph](https://morphllm.com/)

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
   claude /agent:list
   claude /feature:discovery "new user authentication"
   ```

## 🎓 Credits & Inspiration

This framework is built upon learnings and best practices shared by:

- **[Rodrigo Branas](https://branas.io/)** - Developer, Software Architect, Professor, Author and Speaker
- **[Pedro Nauck](https://compozy.com/)** - Founder & CEO at Compozy.com | Building the Next-Gen AI Orchestration Platform for Enterprise | Simplifying Multi-Agent Systems with YAML | Open Source Pioneer

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

_Framework Version: 2.0.0 | Last Updated: August 2025_
