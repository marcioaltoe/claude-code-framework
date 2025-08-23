# TypeScript Patterns

## Core Principles

- **Never use `any`** - Use `unknown` with type guards
- **Type everything** - Explicit types for all data structures
- **Validate at boundaries** - Runtime validation for external data

## Key Patterns

### Validation

- Use **Zod** for runtime validation and type inference
- Validate all external data (APIs, environment variables)
- Use `safeParse` for recoverable errors, `parse` for critical validation

### API Validation (Hono)

- Use `zValidator` middleware for automatic validation
- Support query, body, and param validation
- Coerce types where appropriate (e.g., query strings to numbers)

### Function Design

- **Options objects** for functions with multiple parameters
- **Result pattern** for expected errors
- **Dependency injection** via constructor

### Async Patterns

- Use `Promise.all` for parallel execution
- `Promise.allSettled` when all results are needed
- Always clean up resources with `try/finally`
- Use `AbortController` for timeouts

### Control Flow

- **Early returns** to avoid deep nesting
- **No flag parameters** - use separate functions instead
- Throw errors for invalid states

## Best Practices

1. **Never use `any`** - Use `unknown` with type guards
2. **Validate at boundaries** - Use Zod for external data
3. **Options objects** - For functions with multiple parameters
4. **Result pattern** - For expected errors
5. **Early returns** - Avoid deep nesting
6. **Composition over inheritance** - More flexible
7. **Resource cleanup** - Always use try/finally

---

**Note**: For detailed TypeScript patterns, advanced type system features, and code examples, refer to the `@agent-typescript-expert` which contains comprehensive guidance on:

- Branded types and domain modeling
- Discriminated unions and type guards
- Conditional and mapped types
- Template literal types
- Function overloads
- Const assertions
- Common type error solutions
- TypeScript configuration best practices
