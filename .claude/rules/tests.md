# Testing Standards with Vitest

## Framework

- Use **Vitest** for all tests
- Use `vi.fn`, `vi.spyOn`, `vi.mock` for mocking
- Run tests: `bun run test`
- **Never** use `bun test` (uses wrong framework)

## Organization

- Tests in `/test` directory only
- `/test/unit` – Unit tests (isolated)
- `/test/integration` – Integration tests (with external systems)
- File naming: `[feature-name].test.ts`

## Structure

Follow **Arrange-Act-Assert**:

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

## Best Practices

- **One behavior per test** - Keep tests focused
- **Test isolation** - Each test runs independently  
- **Full coverage** - Test all production code
- **Clean up resources** - Use `afterEach` or `afterAll`
- **Mock external dependencies** - Keep unit tests fast

## Example

```typescript
import { describe, it, beforeEach, expect, vi } from 'vitest';

describe('UserService', () => {
  const mockRepository = { save: vi.fn(), findById: vi.fn() };
  let userService: UserService;

  beforeEach(() => {
    vi.clearAllMocks();
    userService = new UserService(mockRepository);
  });

  it('should create user successfully', async () => {
    mockRepository.save.mockResolvedValueOnce({ id: '123' });
    
    const result = await userService.createUser({ email: 'test@test.com' });
    
    expect(result.id).toBe('123');
    expect(mockRepository.save).toHaveBeenCalledOnce();
  });
});
```
