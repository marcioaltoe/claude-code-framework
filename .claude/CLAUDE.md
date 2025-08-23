# Claude Code Configuration

## Core Philosophy

- **Clean Architecture** - Separation of concerns through layers
- **Test-Driven Development** - Always RED-GREEN-REFACTOR
- **SOLID Principles** - Guide all design decisions
- **KISS** - Keep It Simple, avoid over-engineering
- **YAGNI** - Build only what's needed now
- **DRY** - Don't repeat, but don't abstract prematurely
- **TDA** - Tell, Don't Ask - objects handle their own state

## Quick Commands

### Development Commands

```bash
bun run test        # Run tests (NEVER use 'bun test')
bun run craft       # Update barrel files after creating/moving files
bun db:generate     # Generate database migrations
bun db:migrate      # Apply migrations
bun format          # Format code
bun lint            # Run linter
bun type-check      # Check TypeScript types
```

### Import Strategy - Barrel Files

This project uses **barrel-craft** to automatically generate index.ts files, enabling clean imports:

```typescript
// ✅ Good - uses barrel files
import { UserIdentity } from '@/domain/aggregate'
import { Email, Password } from '@/domain/value-object'

// ❌ Avoid - relative path imports
import { UserIdentity } from '../../domain/aggregate/user-identity.aggregate'
```

**IMPORTANT**: After creating new files or moving existing ones, run `bun run craft` to update
barrel files.

### Fix Commands (Claude Code)

```bash
/fix:lint          # Fix Biome linting errors automatically
/fix:types         # Fix TypeScript errors with @agent-typescript-expert
/fix:tests         # Fix failing tests following TDD principles
```

### Git Workflow Commands (Claude Code)

```bash
/git:commit        # Commit all pending changes with conventional message
/git:branch NAME   # Create feature branch with conventional naming
/git:push          # Push changes and create PR with summary
/git:sync          # Synchronize local repository with remote
```

### Task Management (Claude Code)

```bash
/implement         # Execute next pending task from plan
/implement "task"  # Execute specific task
/implement #3      # Execute task number 3
```

## Code Style

- **TypeScript only** - NEVER use `any`, use `unknown` with type guards
- **Bun runtime** - Use Bun APIs over Node.js equivalents
- **ULID for IDs** - Never UUID or auto-increment
- **Vitest for testing** - Use `vi` for all mocking
- **Unit tests colocated** - In `__tests__` folders next to code
- **Barrel exports** - Run `bun run craft` after file changes

## Architecture Patterns

- **Simple by default** - Use `use-cases/` for most features
- **CQRS only when justified** - High complexity domains only
- **Domain Events only when needed** - Async workflows only
- **No shared/utils folders** - Colocate by context

## Code Quality

- **Small functions** - Single responsibility
- **Simple parameters** - Use objects for complex data
- **Clear control flow** - Avoid deep nesting, early returns
- **Composition over inheritance** - Flexible and testable

## Database

- **Drizzle ORM** with PostgreSQL
- **Snake_case** tables/columns, **camelCase** TypeScript
- **Soft deletes** with `deleted_at`
- **Always**: `created_at`, `updated_at`

## API Standards

- **Hono** for HTTP routing
- **Zod** for validation (backend and frontend)
- **Structured JSON logging** with Winston

## Git Workflow

- **Protected branches**: `main` (production) and `dev` (staging) - NO direct commits
- **Feature branches**: Created from `dev` → `feat/TICKET-123-description`
- **PR flow**: Feature branches → `dev` → (manual) `main`
- **Conventional commits**: `type(scope): subject`

## Testing Workflow

1. Write failing test first (RED)
2. Write minimal code to pass (GREEN)
3. Refactor with passing tests (REFACTOR)
4. Minimum 80% coverage for new code

## IMPORTANT Rules

- YOU MUST write tests BEFORE implementation
- YOU MUST run `bun run craft` after creating/moving files
- YOU MUST use thinking mode for complex problems
- YOU MUST verify with subagents for critical decisions
- NEVER use `any` type - use `unknown` with type guards
- NEVER commit without running tests and type-check
- NEVER commit directly to `main` or `dev` branches
- ALWAYS create feature branches from `dev`
- ALWAYS open PRs to `dev` branch (not `main`)

## Available Agents

Use @agent-[name] for specialized help. All agents now follow standardized documentation with:

- **Tools You Must Use** - MCP tools for specialized tasks
- **Research Protocol** - Investigation workflows
- **Integration with Other Agents** - Collaboration patterns

### Development Agents

- @agent-api-standards-expert - API design, HTTP standards, Hono patterns
- @agent-database-architect - Database design, Drizzle ORM, migrations
- @agent-react-clean-architect - React Clean Architecture patterns
- @agent-react-coder - React 19 component development
- @agent-software-architect - System design, Clean Architecture
- @agent-typescript-expert - Type errors, advanced TypeScript patterns

### Quality & Testing Agents

- @agent-tdd-test-engineer - TDD with Vitest, React Testing Library
- @agent-tech-lead-reviewer - Code review, architecture decisions
- @agent-design-review - UI/UX compliance, Playwright testing
- @agent-ux-guardian - Edge case discovery, user journey testing
- @agent-biome-lint-fixer - Automated Biome linting fixes, code quality
- @agent-typescript-diagnostics-fixer - Automated TypeScript error resolution

### Orchestration Agents

- @agent-task-analyzer - Pre-implementation analysis for token optimization
- @agent-task-implementation-orchestrator - Task execution coordination

### Product & Business Agents

- @agent-business-analyst - Requirements gathering, user stories
- @agent-domain-expert-validator - Business logic validation
- @agent-product-manager-prd - PRD creation, feature planning
- @agent-ux-ui-designer - UI/UX design, Tailwind v4, ShadcnUI

### Workflow Agent

- @agent-git-workflow - Git operations, conventional commits

## Available Commands

Commands are in `~/.claude/commands/`:

### Fix Commands

- `/fix:lint` - Automatic Biome error fixing with @agent-biome-lint-fixer
- `/fix:types` - TypeScript error resolution with @agent-typescript-diagnostics-fixer
- `/fix:tests` - Test failure fixing following TDD with @agent-tdd-test-engineer

### Git Workflow

- `/git:commit` - Smart conventional commits (feature branches only)
- `/git:branch` - Create feature branch from `dev`
- `/git:push` - Push and create PR to `dev`
- `/git:sync` - Synchronize with `dev` branch

### Feature Development

- `/feature:discovery` - Feature discovery and planning
- `/feature:prd` - Product requirement documents
- `/feature:techspec` - Technical specifications
- `/feature:tasks` - Task breakdown and planning
- `/feature:workflow` - Complete feature workflow
- `/analyze` - Pre-implementation analysis (dispatcher to @agent-task-analyzer)
- `/implement` - Task execution (dispatcher to @agent-task-implementation-orchestrator)

### Design & Testing

- `/design:review` - UI/UX compliance review

## Reference Documentation

Core rules are in `~/.claude/rules/`:

- `~/.claude/rules/tdd.md` - Test-Driven Development
- `~/.claude/naming-conventions.md` - File naming patterns
- `~/.claude/clean-architecture.md` - Architecture principles
- `~/.claude/folder-structure.md` - Project organization
- `~/.claude/solid.md` - SOLID principles
- `~/.claude/react.md` - React technology stack and patterns

Context files are in `~/.claude/context/`:

- `~/.claude/context/design-principles.md` - S-Tier SaaS design standards

Detailed knowledge is in agents - use them for specifics!
