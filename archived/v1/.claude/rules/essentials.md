# Essential Development Rules

## Language & Runtime

- **TypeScript only** - Never use `any`
- **Bun runtime** - `bun run test`, never `bun test`
- **Bun APIs** - Use `bun:sqlite`, `Bun.file` over Node.js equivalents
- **ULID for IDs** - Never UUID or auto-increment

## Architecture

- **Clean Architecture** - Domain → Application → Infrastructure
- **Simple features**: `use-cases/` folder
- **Complex features**: `commands/` + `queries/` (CQRS)
- **No shared/utils folders** - Colocate by context

## Database

- **Drizzle ORM** with PostgreSQL
- **Snake_case** tables/columns, **camelCase** TypeScript
- **Soft deletes** with `deleted_at`
- **Always**: `created_at`, `updated_at`

## Testing

- **Vitest** via `bun run test`
- **TDD approach** - Write tests first
- Tests in `/test` directory, not `/src`

## Code Quality

- **Small functions** - Single responsibility
- **Simple parameters** - Use objects for complex data
- **Clear control flow** - Avoid deep nesting
- **Composition over inheritance**

## API

- **Hono** for HTTP routing - Don't use Express or Bun.serve()
- **TypeBox** for backend validation
- **Zod** only in React frontends
- **Structured JSON logging** with Winston

## React (when applicable)

- **Functional components** with hooks
- **Tailwind CSS** for styling
- **React Query** for data fetching

## Git

- **Conventional commits**: `type(scope): subject`
- **Feature branches**: `feat/TICKET-123-description`
- **No direct commits to main**

## Automation

- **Use `/fix` commands** for TypeScript/Linter/test errors
- **Run `bun run craft`** after creating/moving files to update barrel files (index.ts)
- **Context7** for official docs
- **Perplexity** for research
