# Testing Standards with Vitest

## Testing Framework

- Use **Vitest** for running tests and writing assertions
- Use **Vitest's native mocking API** (`vi.fn`, `vi.spyOn`, `vi.mock`)
- Use **vitest-mock-extended** for deep mocks, type-safe stubs, and integration with TypeScript
- Run tests with: `bun run test` or `npm test` or `vitest`
- **NEVER** use `bun test` because this will use built-in test and not vitest

---

## Test Organization

### Directory Structure

- All tests must reside inside the `/test` directory
- **Do not place tests** inside `/src`
- Organize test files by type:
  - `/test/unit` – Unit tests
  - `/test/integration` – Integration tests

### File Naming

- Use `.test.ts` extension for all test files
- File names should follow the pattern: `[feature-name].test.ts`

---

## Test Design Principles

### Independence

- Tests must be completely independent
- Each test should run in isolation
- Avoid dependencies between tests

### Structure

Follow the **Arrange-Act-Assert** or **Given-When-Then** structure:

```typescript
describe("UserService", () => {
  it("should create a new user", () => {
    // Arrange / Given
    const userData = { name: "John", email: "john@example.com" };

    // Act / When
    const result = userService.create(userData);

    // Assert / Then
    expect(result).toBeDefined();
    expect(result.id).toBeTruthy();
  });
});
```

### Date/Time Handling

- Use `vi.useFakeTimers()` and `vi.setSystemTime()` for time-dependent tests
- Ensure time does not affect test reliability

---

## Test Categories

### Integration Tests (`/test/integration`)

Should involve external systems like:

- HTTP requests
- Database operations
- Message queues
- File system access
- External APIs

### Unit Tests (`/test/unit`)

Should be isolated from external dependencies:

- Business logic
- Domain entities
- Value objects
- Utility functions

---

## Testing Guidelines

### HTTP Endpoints

- Write integration tests for HTTP routes
- **Do not** use request libraries like `supertest`
- Focus on:
  - Main flow behavior
  - Alternate flows and edge cases
  - Response codes
  - Error messages

### Use Cases

- Fully test all use case logic
- Include the main path and at least one alternative condition
- Use **mocks or stubs** (`vi.fn` or `vitest-mock-extended`) to isolate from APIs
- Prefer keeping these as **unit tests**

### Domain Layer

- Test all domain entities and value objects
- Cover all rules, boundaries, and edge cases
- Keep all domain logic in the **unit test** layer

---

## Best Practices

### Test Scope

- Test **a single behavior** per test
- Keep tests short, simple, and focused

### Code Coverage

- New code must be fully covered by tests
- Production logic should not be untested

### Assertions

- Write meaningful and complete expectations
- Always validate both happy paths and error conditions

### Resource Management

- Always release resources (DB, queues, etc.) in `afterEach` or `afterAll`

### Test Initialization

- Use `beforeEach` for setting up common logic
- Keep setup minimal and deterministic

---

## Example with `vitest-mock-extended`

```typescript
import { describe, it, beforeEach, afterEach, expect, vi } from ‘vitest’;
import { mock } from ‘vitest-mock-extended’;
import { OrderService } from ‘@/services/OrderService’;
import { OrderRepository } from ‘@/repositories/OrderRepository’;

describe(‘OrderService’, () => {
  const mockRepository = mock();
  let orderService: OrderService;

  beforeEach(() => {
    // Reset mock history
    vi.clearAllMocks();
    orderService = new OrderService(mockRepository);
  });

  afterEach(() => {
    // Clean up resources if needed
  });

  describe(‘createOrder’, () => {
    it(‘should create an order successfully’, async () => {
    mockRepository.save.mockResolvedValueOnce({ id: ‘abc123’ });
    const result = await orderService.createOrder({ customerId: 'c1' });

    expect(result.id).toBe('abc123');
  });

  it('should throw error when customer is not found', async () => {
    mockRepository.save.mockRejectedValueOnce(new Error('Customer not found'));

    await expect(() =>
    orderService.createOrder({ customerId: 'invalid' })
    ).rejects.toThrow('Customer not found');
    });
  });
});
```
