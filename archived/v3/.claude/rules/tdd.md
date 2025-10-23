# Test-Driven Development (TDD)

## The Sacred Cycle: RED-GREEN-REFACTOR

### 🔴 RED - Write Failing Test First

**NO PRODUCTION CODE WITHOUT A FAILING TEST**

- Write test that describes desired behavior
- Run test to see it fail (proves test is testing something)

### 🟢 GREEN - Minimal Code to Pass

**WRITE THE LEAST CODE POSSIBLE**

- Implement just enough to make test pass
- Don't add features not required by test
- Run test to see it pass

### ♻️ REFACTOR - Improve with Safety

**ONLY REFACTOR WITH GREEN TESTS**

- Clean up code while tests stay green
- Remove duplication, improve names
- Tests protect against breaking changes

## Core TDD Rules

1. **Write test first** - Always RED before GREEN
2. **One test at a time** - Don't write multiple failing tests
3. **Minimal implementation** - Simplest code that passes
4. **Refactor frequently** - Clean code after each GREEN
5. **Tests are documentation** - Clear test names describe behavior

## Framework & Tools

- **Bun built-in test** - Our testing framework
- **TypeScript** - Full type safety in tests
- Run tests: `bun run test`
- **Never** use `bun test` (wrong framework)

## Test Structure

### AAA Pattern / Given-When-Then

```
Arrange (Given) - Setup test data
Act (When)      - Execute the action
Assert (Then)   - Verify outcome
```

### Test Naming

- Describe behavior, not implementation
- Use "should" for clarity
- Be specific about conditions
- Tests as documentation

## Unit Test Organization

**Colocate tests with code in `__tests__` folders:**

```
src/domain/user/
├── __tests__/
│   └── user.entity.test.ts
└── user.entity.ts
```

**`/tests` directory - Only for shared resources:**

- `/tests/setup` - Test configuration
- `/tests/mocks` - Shared mock factories
- `/tests/helpers` - Test utilities
- `/tests/integration` - Integration tests
- `/tests/e2e` - End-to-end tests

## Coverage Requirements

- **Domain Layer**: 95% (critical business logic)
- **Application Layer**: 85% (use cases)
- **Infrastructure**: 70% (external integrations)
- **New Code**: 100% (TDD ensures this)

## What NOT to Test

- Third-party libraries
- Framework code
- Simple getters/setters without logic
- Configuration files

## Best Practices

1. **One behavior per test** - Single concept per test
2. **Test isolation** - No shared state between tests
3. **Mock at boundaries** - Keep unit tests fast
4. **Clean up resources** - Use lifecycle hooks

## Integration with Workflow

- **PRs**: Rejected without tests
- **CI/CD**: All tests run automatically
- Start with test tasks, then implementation

For detailed patterns and examples, consult @agent-tdd-engineer
