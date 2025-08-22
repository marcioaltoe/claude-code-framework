# Development Standards & Guidelines

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## Core Philosophy

1. **Clean Architecture** - Clear separation of concerns through layers
2. **Clean Code** - Readable, maintainable, self-documenting code
3. **SOLID Principles** - Guide all design decisions
4. **Pragmatic Approach** - CQRS and Domain Events only when complexity justifies
5. **KISS, YAGNI, DRY** - Fundamental design principles

## Quick Commands

- **Run tests**: `bun run test`
- **Generate migrations**: `bun db:generate`
- **Apply migrations**: `bun db:migrate`
- **Format code**: `bun format`
- **Lint**: `bun lint`
- **Type check**: `bun type-check`
- **Update barrels**: `bun run craft`

## Import Strategy - Barrel Files

This project uses **barrel-craft** to automatically generate index.ts files, enabling clean imports:

```typescript
// ✅ Good - uses barrel files
import { UserIdentity } from '@/domain/aggregate'
import { Email, Password } from '@/domain/value-object'

// ❌ Avoid - relative path imports
import { UserIdentity } from '../../domain/aggregate/user-identity.aggregate'
```

**IMPORTANT**: After creating new files or moving existing ones, run `bun run craft` to update barrel files.

## Rules and Standards

> (use only when needed)

<!-- Core references:
- `.claude/rules/essentials.md` - Core development standards
- `.claude/rules/clean-architecture.md` - Clean Architecture patterns
- `.claude/rules/solid.md` - SOLID principles
- `.claude/rules/fundamental-design-principles.md` - DRY, YAGNI, KISS, TDA
- `.claude/rules/naming-conventions.md` - Naming conventions

Technical references:

- `.claude/rules/typescript-patterns.md` - TypeScript patterns
- `.claude/rules/api-standards.md` - HTTP/API standards
- `.claude/rules/database-drizzle.md` - Drizzle ORM patterns
- `.claude/rules/database-sql.md` - SQL standards
- `.claude/rules/tests.md` - Testing with Vitest
- `.claude/rules/logging.md` - Logging with Winston
- `.claude/rules/git-workflow.md` - Git workflow and commits
- `.claude/rules/folder-structure.md` - Project organization
- `.claude/rules/object-calisthenics.md` - OO best practices

Readct references:

- `.claude/rules/react.md` -->
