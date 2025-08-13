## Development Philosophy

**Pragmatism over Purism:** Functionality first, perfect architecture second. Apply Clean Architecture and DDD patterns where they add clear value, not everywhere.

## Rules and Standards (source of truth)

Use the following rule files directly when necessary:

`./rules/api-standards.md`
`./rules/architecture-design-principles.md`
`./rules/clean-architecture.md`
`./rules/code-standards.md`
`./rules/database-drizzle.md`
`./rules/database-sql.md`
`./rules/logging.md`
`./rules/react.md`
`./rules/tests.md`
`./rules/use-bun-instead-node.md`

## Essential Guidelines

### NEVER

1. **NEVER** use Bun built-in test runner or Node.js test runners (use Vitest)
2. **NEVER** use npm or yarn commands (always use Bun)
3. **NEVER** manually edit Drizzle migration meta files
4. **NEVER** commit without: authorization, running tests, or directly to `main`
5. **NEVER** use `any` type without explicit justification
6. **NEVER** catch errors without proper handling
7. **NEVER** use synchronous file operations
8. **NEVER** store secrets in code
9. **NEVER** skip tests for "quick fixes"
10. **NEVER** use shared/ or utils/ folders - colocate by context
11. **NEVER** create files unless absolutely necessary
12. **NEVER** proactively create documentation files unless requested
13. **NEVER** use non null assertion (eg: const conditions = this.props.havingConditions!)

### ALWAYS

1. **ALWAYS** use Bun commands for all operations
2. **ALWAYS** write tests first (TDD)
3. **ALWAYS** use Result pattern for fallible operations
4. **ALWAYS** validate input at boundaries
5. **ALWAYS** use dependency injection
6. **ALWAYS** emit domain events for state changes
7. **ALWAYS** use transactions for multi-step operations
8. **ALWAYS** prefer composition over inheritance
9. **ALWAYS** use English for all code and documentation
10. **ALWAYS** follow existing patterns in the codebase
11. **ALWAYS** use ULID instead uuid
12. **ALWAYS** use bun run test
13. **ALWAYS** use typebox for schema validation in backends and use zod **ONLY** in react frontends
14. **ALWAYS** keep in mind that I prefer specialized agents using the best model they can so that the focus of the opus is generating
    code.

---

Last Updated: August 2025
Version: 1.0.0
