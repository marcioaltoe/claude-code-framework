# Agent-Technology Stack Alignment

## Technology Stack Overview

### Backend Stack

- **Runtime**: Node.js with Bun
- **Framework**: Hono
- **Language**: TypeScript
- **Architecture**: Clean Architecture
- **Database**: PostgreSQL with Drizzle ORM
- **Validation**: Zod
- **Logging**: Winston

### Frontend Stack

- **Framework**: React 19
- **Build**: Vite
- **Routing**: TanStack Router
- **Data Fetching**: TanStack Query
- **State Management**: Zustand
- **Styling**: Tailwind CSS v4 + ShadcnUI
- **Testing**: Vitest + React Testing Library

## Agent Standardization

All agents now follow a unified documentation structure:

1. **Tools You Must Use** - MCP tools specific to the agent's role
2. **Research Protocol** - Step-by-step investigation workflows
3. **Integration with Other Agents** - Detailed collaboration patterns with specific contexts
4. **Remember** - Inspirational closing statement encapsulating the agent's philosophya

This standardization ensures:

- Consistent workflow patterns across all agents
- Clear handoff points between agents
- Explicit tool usage guidelines
- Predictable research methodologies

## Agent Role Mapping

### Backend Development Roles

#### Software Architect

- **Agent**: @agent-software-architect
- **Stack Focus**: Clean Architecture patterns for Node.js/Hono
- **Tools**: context7 (Hono docs), zen.thinkdeep (architecture decisions)
- **Responsibilities**: Layer separation, domain modeling, service boundaries

#### API Designer

- **Agent**: @agent-api-standards-expert
- **Stack Focus**: Hono framework, HTTP standards, Winston logging
- **Tools**: context7 (Hono patterns), perplexity (REST best practices)
- **Responsibilities**: RESTful endpoints, middleware, structured logging

#### Database Architect

- **Agent**: @agent-database-architect
- **Stack Focus**: PostgreSQL, Drizzle ORM, migrations
- **Tools**: context7 (Drizzle docs), zen.thinkdeep (schema design)
- **Responsibilities**: Schema design, indexing, query optimization

#### Domain Expert Validator

- **Agent**: @agent-domain-expert-validator
- **Stack Focus**: Business logic validation in Clean Architecture
- **Tools**: perplexity (domain standards), zen.consensus (rule conflicts)
- **Responsibilities**: Domain model accuracy, business rule implementation

### Frontend Development Roles

#### React Clean Architect

- **Agent**: @agent-react-architect
- **Stack Focus**: React 19 + Zustand + TanStack architecture
- **Tools**: context7 (React 19, Zustand, TanStack docs)
- **Responsibilities**: Frontend Clean Architecture, state management strategy

#### React Coder

- **Agent**: @agent-react-coder
- **Stack Focus**: React 19 components, TanStack, ShadcnUI
- **Tools**: context7 (React 19, ShadcnUI), firecrawl (component examples)
- **Responsibilities**: Component implementation, hooks, performance

#### UX/UI Designer

- **Agent**: @agent-ux-ui-designer
- **Stack Focus**: Tailwind v4, ShadcnUI components
- **Tools**: context7 (ShadcnUI), firecrawl (design patterns)
- **Responsibilities**: Design systems, accessibility, user flows

#### Design Review

- **Agent**: @agent-react-design-review
- **Stack Focus**: S-Tier SaaS standards, WCAG compliance
- **Tools**: playwright (automated testing), firecrawl (competitor analysis)
- **Responsibilities**: Design compliance, accessibility testing

### Testing & Quality Roles

#### TDD Test Engineer

- **Agent**: @agent-tdd-engineer
- **Stack Focus**: Vitest, React Testing Library, Bun test runner
- **Tools**: context7 (Vitest, RTL docs), perplexity (TDD patterns)
- **Responsibilities**: Unit tests, integration tests, test coverage

#### UX Guardian

- **Agent**: @agent-ux-guardian
- **Stack Focus**: User journey testing, edge cases
- **Tools**: playwright (automated flows), zen.thinkdeep (edge discovery)
- **Responsibilities**: User scenario testing, edge case identification

#### Tech Lead Reviewer

- **Agent**: @agent-tech-lead-reviewer
- **Stack Focus**: Full stack review (Hono + React + TypeScript)
- **Tools**: perplexity (best practices), zen.consensus (trade-offs)
- **Responsibilities**: Code review, architectural decisions, risk assessment

### Code Quality & Automation Roles

#### Biome Lint Fixer

- **Agent**: @agent-biome-lint-fixer
- **Stack Focus**: Biome linting rules, ESLint patterns, code quality
- **Tools**: context7 (Biome docs), perplexity (rule patterns), zen.thinkdeep (fix strategies)
- **Responsibilities**: Automated linting fixes, rule compliance, code quality enforcement

#### TypeScript Diagnostics Fixer

- **Agent**: @agent-typescript-diagnostics-fixer
- **Stack Focus**: TypeScript type system, error resolution, type safety
- **Tools**: context7 (TypeScript docs), perplexity (error solutions), zen.thinkdeep (type patterns)
- **Responsibilities**: Automated type error fixes, type safety maintenance, diagnostic resolution

### Cross-Cutting Roles

#### TypeScript Expert

- **Agent**: @agent-typescript-expert
- **Stack Focus**: TypeScript for both backend (Hono) and frontend (React)
- **Tools**: context7 (TypeScript docs), zen.thinkdeep (type design)
- **Responsibilities**: Type safety, advanced patterns, type system design

#### Business Analyst

- **Agent**: @agent-business-analyst
- **Stack Focus**: Requirements for Clean Architecture implementation
- **Tools**: perplexity (industry standards), zen.planner (user stories)
- **Responsibilities**: Requirements gathering, use case documentation

#### Product Manager PRD

- **Agent**: @agent-product-manager-prd
- **Stack Focus**: Product requirements documentation, feature planning
- **Tools**: perplexity (market research), zen.consensus (stakeholder alignment)
- **Responsibilities**: PRD creation, success metrics, feature prioritization

#### Git Workflow

- **Agent**: @agent-git-workflow
- **Stack Focus**: Conventional commits, feature branches
- **Tools**: perplexity (git best practices)
- **Responsibilities**: Version control, commit standards, PR workflows

### Orchestration Roles

#### Task Analyzer

- **Agent**: @agent-task-analyzer
- **Stack Focus**: Pre-implementation analysis for token optimization
- **Tools**: Serena (symbol mapping), zen.thinkdeep (complexity analysis), zen.consensus (trade-offs)
- **Responsibilities**: File mapping, dependency analysis, risk assessment, execution strategy

#### Task Implementation Orchestrator

- **Agent**: @agent-task-implementation-orchestrator
- **Stack Focus**: Task execution coordination across all layers
- **Tools**: Task (agent delegation), TodoWrite (progress tracking), zen.consensus (approach resolution)
- **Responsibilities**: Analysis verification, agent coordination, quality assurance, progress tracking

## Build & DevOps Specialization

### Bun Expertise

All agents are aware of Bun-specific considerations:

- **Package Management**: Bun's package.json handling
- **Test Runner**: `bun run test` (never `bun test`)
- **Build Scripts**: `bun run craft` for barrel exports
- **Performance**: Bun's speed advantages
- **CI/CD**: Bun-optimized pipelines

## Enhanced Collaboration Patterns

### Multi-Agent Handoff Protocol

Each agent's "Integration with Other Agents" section now includes:

- **Agent name**: Purpose of collaboration
  - Specific context 1 (e.g., "Component hierarchy decisions")
  - Specific context 2 (e.g., "State management strategy")
  - Specific context 3 (e.g., "Performance implications")
  - Specific context 4 (e.g., "Testing strategies")

This detailed structure ensures:

- Clear understanding of when to engage other agents
- Specific contexts for collaboration
- Reduced ambiguity in multi-agent workflows
- Better knowledge transfer between agents

## Workflow Integration Patterns

### Feature Development Flow

```
1. @agent-business-analyst → Requirements (with detailed acceptance criteria)
2. @agent-ux-ui-designer → Design (with accessibility standards)
3. @agent-software-architect → System design (with Clean Architecture boundaries)
4. @agent-react-architect → Frontend architecture (with Zustand state design)
5. @agent-api-standards-expert → API contracts (with Hono patterns)
6. @agent-database-architect → Schema design (with Drizzle ORM models)
7. @agent-tdd-engineer → Test specs (RED phase)
8. @agent-react-coder → Implementation (GREEN phase)
9. @agent-typescript-expert → Type refinement (type safety validation)
10. @agent-ux-guardian → Edge case testing (user journey validation)
11. @agent-react-design-review → UI compliance (WCAG and S-Tier standards)
12. @agent-tech-lead-reviewer → Final review (architecture and quality)
```

### Bug Fix Flow

```
1. @agent-tech-lead-reviewer → Impact analysis
2. @agent-typescript-expert → Type investigation
3. @agent-tdd-engineer → Reproduction test
4. @agent-react-coder OR @agent-api-standards-expert → Fix implementation
5. @agent-ux-guardian → Regression testing
```

### Automated Fix Flow

```
1. @agent-biome-lint-fixer → Lint error resolution (/fix:lint)
2. @agent-typescript-diagnostics-fixer → Type error fixes (/fix:types)
3. @agent-tdd-engineer → Test failure fixes (/fix:tests)
```

### Refactoring Flow

```
1. @agent-software-architect → Refactoring strategy
2. @agent-react-architect → Frontend restructuring
3. @agent-database-architect → Data layer optimization
4. @agent-tdd-engineer → Test coverage
5. @agent-tech-lead-reviewer → Quality assurance
```

### Analysis & Implementation Flow

```
1. @agent-task-analyzer → Pre-implementation analysis
   - File mapping and dependencies
   - Complexity assessment
   - Risk identification
   - Token optimization strategy
2. @agent-task-implementation-orchestrator → Execution coordination
   - Check/create analysis
   - Delegate to specialist agents
   - Track progress with TodoWrite
   - Ensure quality standards
```

## MCP Tool Integration

All agents leverage MCP tools aligned with the stack:

- **context7**: Documentation for Hono, React 19, TanStack, Zustand, Drizzle, Vitest
- **perplexity**: Industry best practices and patterns
- **zen tools**: Complex decision making and consensus building
- **firecrawl**: Competitor analysis and pattern discovery
- **playwright**: Automated testing and validation

## Key Principles

1. **Clean Architecture First**: Both backend (Hono) and frontend (React) follow Clean Architecture
2. **Type Safety**: TypeScript across the entire stack
3. **Test-Driven**: Vitest/RTL with TDD methodology
4. **Performance**: Leverage Bun's speed, React 19's features
5. **Simplicity**: Avoid over-engineering, use stack capabilities
