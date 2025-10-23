# Core Development Rules

## **CRITICAL - NEVER IGNORE:**

- **ALWAYS** run `bun run craft` after creating/moving files to update barrel imports
- **NEVER** use `any` type - use `unknown` with type guards instead
- **NEVER** use `bun test` - always use `bun run test`
- **NEVER** commit without running tests and type-check first
- **NEVER** commit directly to `main` or `dev` branches
- **ALWAYS** create feature branches from `dev`

## SOLID Principles (Mandatory)

- **Single Responsibility**: One reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable
- **Interface Segregation**: No fat interfaces
- **Dependency Inversion**: Depend on abstractions

## Clean Code Standards

**Naming:**

- Intention-revealing names
- Pronounceable and searchable
- Class names: nouns, method names: verbs

**Functions:**

- Small (< 20 lines preferred)
- Single purpose
- No side effects
- Descriptive names over comments

**Error Handling:**

- Use exceptions, not return codes
- Provide context with exceptions
- Don't return null, use Optional or throw exceptions

**Comments:**

- Explain WHY, not WHAT
- Avoid redundant comments
- Update comments when code changes

## Naming Conventions (Mandatory)

- `kebab-case` for file and folder names
- `PascalCase` for class names
- `camelCase` for function and variable names
- `SCREAMING_SNAKE_CASE` for constants

## Code Quality Standards (Mandatory)

- **KISS principle enforcement (avoid over-engineering)**
- **YAGNI validation (build only what's needed)**
- DRY balance (don't abstract prematurely)
- TDA pattern compliance (Tell, Don't Ask)

## Technology Stack

- **Runtime**: Bun (prefer Bun APIs over Node.js)
- **Language**: TypeScript (strict mode, no any types)
- **Database**: PostgreSQL with Drizzle ORM
- **Web Framework**: Hono for HTTP routing
- **Validation**: Zod for schema validation
- **Testing**: Bun built-in tests
- **IDs**: UUIDv7 generated in the app (`Bun.randomUUIDv7()`); **NEVER** `defaultRandom()` in database.

## Barrel Files Strategy

**Use barrel files for clean imports:**

```typescript
// ✅ Good - uses barrel files
import { UserIdentity } from "@/domain/aggregate";
import { Email, Password } from "@/domain/value-object";

// ❌ Avoid - relative imports
import { UserIdentity } from "../../domain/aggregate/user-identity.aggregate";
```

**IMPORTANT**: Run `bun run craft` after creating/moving files to update barrel files.

## Git Workflow

**Branching:**

- Create feature branches from `dev`
- Use descriptive names: `feature/user-authentication`
- Never commit directly to `main` or `dev`

**Commit Standards:**

- Write clear, descriptive commit messages
- Include test changes in commits
- Keep commits atomic and focused
- Run tests before committing

## Error Handling Strategy

**Principles:**

- Validate input at system boundaries
- Handle exceptions at appropriate layers
- Provide meaningful error messages
- Implement recovery mechanisms where possible

**Patterns:**

- Use Result/Either types for expected failures
- Throw exceptions for unexpected/unrecoverable errors
- Log errors with correlation IDs for tracing
- Implement circuit breakers for external services

## Security Requirements

**Input Validation:**

- Validate all input at system boundaries
- Use Zod schemas for validation
- Sanitize user input
- Implement rate limiting

**Data Protection:**

- Hash passwords with bcrypt
- Use environment variables for secrets
- Implement proper session management
- Log security events

# SuperClaude

## Core Framework

<!-- @BUSINESS_PANEL_EXAMPLES.md -->
<!-- @BUSINESS_SYMBOLS.md -->

@FLAGS.md
@PRINCIPLES.md
@RULES.md

## Behavioral Modes

@MODE_Brainstorming.md

<!-- @MODE_Business_Panel.md -->

@MODE_Introspection.md
@MODE_Orchestration.md
@MODE_Task_Management.md
@MODE_Token_Efficiency.md

## MCP Server Usage Rules

**MANDATORY - ALWAYS FOLLOW:**

### Code Editing Operations

- **ALWAYS** use **Morphllm MCP** for:
  - Multi-file edit operations requiring consistent patterns
  - Framework updates, style guide enforcement, code cleanup
  - Bulk text replacements across multiple files
  - Pattern-based transformations (30-50% efficiency gains)

### File Search & Navigation

- **ALWAYS** use **Serena MCP** for:
  - Symbol operations: rename, extract, move functions/classes
  - Project-wide code navigation and exploration
  - Large codebase analysis (>50 files, complex architecture)
  - Session persistence: `/sc:load`, `/sc:save`, project memory
  - Shell operations via `execute_shell_command` (preferred over native Bash for routine operations to reduce context usage)

### Documentation Lookup (Primary)

- **ALWAYS** use **Ref MCP** for:
  - Comprehensive documentation search across multiple sources
  - Private documentation or internal resources
  - Library documentation and framework patterns
  - Import statements, API usage, configuration guidance
  - Version-specific implementation requirements

### Web Research & Documentation (UPDATED PRIORITY)

- **ALWAYS** use **EXA Search MCP** for (PRIMARY):

  - Technical research & documentation (hundreds of QPS)
  - Code patterns, benchmarks, and technical solutions
  - Real-time semantic search with superior accuracy
  - Developer-focused research and API documentation

- **Use Perplexity MCP** for (FALLBACK):
  - Complex reasoning validation (30 QPS limit)
  - Conversational synthesis when EXA insufficient
  - Latest trends and emerging technologies

### Multi-Tool Orchestration & Analysis

- **ALWAYS** use **Zen MCP** for:
  - Complex workflow orchestration and multi-model analysis
  - Multi-step workflow coordination with pipeline customization
  - Architecture decision-making requiring consensus building
  - Quality assurance pipelines with collaborative validation
  - Agent composition and specialization for complex tasks
  - Deep analysis requiring structured thinking (`thinkdeep`)
  - Multi-perspective consensus building (`consensus`)
  - Code review workflows (`codereview`, `challenge`)

### Framework Documentation (Fallback/Enhancement)

- **Use Context7 MCP** when:
  - Ref doesn't have sufficient official documentation
  - Need curated, version-specific framework patterns
  - Framework compliance verification (React, Vue, Angular, Next.js, etc.)
  - Official documentation enhancement for incomplete Ref results

### MCP Selection Priority (UPDATED)

1. **Morphllm** → All code editing and pattern transformations
2. **Serena** → All file search, navigation, and semantic operations
3. **EXA Search** → Technical research & documentation (PRIMARY - hundreds QPS)
4. **Ref** → Documentation and comprehensive search
5. **Zen** → Complex workflows, orchestration, and multi-model analysis
6. **Perplexity** → Complex reasoning validation (FALLBACK - 30 QPS)
7. **Context7** → Framework docs enhancement when needed

**Research Strategy:**

- **EXA Search**: Primary for technical research, documentation, patterns, benchmarks
- **Perplexity**: Fallback for complex reasoning validation and conversational synthesis

**Anti-Patterns to Avoid:**

- ❌ Using Perplexity when EXA's semantic search available
- ❌ Basic search when EXA's technical research capabilities available

**CRITICAL**: Never use native tools for operations that have dedicated MCP servers. Always leverage MCP capabilities for maximum efficiency and accuracy.

## MCP Documentation

@MCP_Context7.md
@MCP_Morphllm.md
@MCP_Playwright.md
@MCP_Sequential.md
@MCP_Serena.md
