# Naming Conventions

## File Naming

**kebab-case with descriptive suffixes:**

- `user.entity.ts` - Entities
- `email.value-object.ts` - Value objects
- `create-user.use-case.ts` - Use cases
- `user.repository.ts` - Repository interfaces
- `postgres-user.repository.ts` - Repository implementations
- `user.dto.ts` - Data transfer objects
- `entity.base.ts` - Base/abstract classes

## Directory Naming

- **All folders**: Use **plural** (e.g., `entities/`, `use-cases/`, `repositories/`)
- **Feature modules**: Use **singular** kebab-case (e.g., `auth/`, `user/`, `payment/`)

## Code Naming

- **PascalCase**: Classes, interfaces, types, enums
- **camelCase**: Variables, functions, methods
- **UPPER_SNAKE_CASE**: Constants
- **kebab-case**: File names

## Principles

- Use intention-revealing names
- Avoid abbreviations
- Be consistent across the codebase
- Make names searchable and pronounceable

## Examples

```typescript
// ✅ Good
export class UserService {
  async createUser(data: CreateUserDto): Promise<User> {}
  async findUserById(id: string): Promise<User | null> {}
}

const MAX_RETRY_ATTEMPTS = 3;
const DEFAULT_TIMEOUT_MS = 5000;

// ❌ Bad
export class UsrSvc {
  async createUsr(d: CrtUsrDto): Promise<Usr> {}
}

const max = 3; // What is max?
const timeout = 5000; // Timeout for what?
```

## Boolean Naming

```typescript
// ✅ Good
interface User {
  isActive: boolean;
  hasVerifiedEmail: boolean;
  canEditProfile: boolean;
}

// ❌ Bad
interface User {
  active: boolean; // Use isActive
  verified: boolean; // Use hasVerifiedEmail
}
```

## Interface vs Implementation

```typescript
// No 'I' prefix for interfaces
export interface UserRepository {
  save(user: User): Promise<void>;
  findById(id: string): Promise<User | null>;
}

// Implementation uses technology prefix
export class PostgresUserRepository implements UserRepository {
  // Implementation
}
```

## Best Practices

1. **Be Descriptive** - Names should clearly indicate purpose
2. **Be Consistent** - Use the same terms throughout
3. **Avoid Abbreviations** - Use full, clear names
4. **Use Domain Language** - Prefer business terms over technical jargon
