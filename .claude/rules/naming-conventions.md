# Naming Conventions & File Organization

## File Naming Conventions

### Consistent kebab-case naming with appropriate suffixes

**Domain Layer:**

- `user-identity.aggregate.ts` - Aggregate roots
- `company.entity.ts` - Entities
- `email.value-object.ts` - Value objects
- `user-created.event.ts` - Domain events
- `user-not-found.error.ts` - Domain errors
- `user-can-login.specification.ts` - Specifications
- `user-repository.ts` - Repository interfaces (no suffix for interfaces)

**Application Layer:**

- `login-user.use-case.ts` - Use cases
- `auth-request.dto.ts` - Data transfer objects
- `auth-mapper.ts` - Mappers
- `auth-validator.ts` - Validators

**Infrastructure Layer:**

- `postgres-user-repository.ts` - Repository implementations (prefixed with technology)
- `redis-cache.service.ts` - Services
- `jwt-token.service.ts` - External service adapters

**Base/Abstract Classes:**

- `aggregate-root.base.ts`
- `entity.base.ts`
- `value-object.base.ts`
- `use-case.base.ts`

### Directory Naming

- **Domain folders**: Use **singular** for single concepts (e.g., `entity/`, `aggregate/`,
  `value-object/`)
- **Mixed collections**: Use **plural** (e.g., `building-blocks/`, `types/`)
- **Feature modules**: Use **singular** kebab-case (e.g., `auth/`, `organization/`, `payment/`)
- **Infrastructure folders**: Use descriptive names (e.g., `persistence/`, `cache/`, `security/`)

### TypeScript File Extensions

- `.ts` for TypeScript files
- `.test.ts` for test files
- `.spec.ts` for specification files
- `.d.ts` for type declaration files

## Code Naming Conventions

### TypeScript Naming Standards

- **PascalCase** for types, classes, interfaces, enums
- **camelCase** for variables, functions, methods
- **UPPER_SNAKE_CASE** for constants
- **kebab-case** for file names

### Examples

```typescript
// ✅ Good: Clear, intention-revealing names
export interface WorkflowExecutionResult {
  taskResults: TaskResult[];
  executionTime: number;
  status: ExecutionStatus;
}

export class WorkflowService {
  async executeWorkflowWithRetry(
    workflowId: ID,
    maxRetries: number,
  ): Promise<WorkflowExecutionResult> {
    // Implementation
  }
}

// Constants
const MAX_RETRY_ATTEMPTS = 3;
const DEFAULT_TIMEOUT_MS = 5000;

// ❌ Bad: Unclear, abbreviated names
interface WfExecRes {
  tr: TskRes[];
  et: number;
  s: number;
}

class WfSvc {
  async execWf(id: string, mr: number): Promise<WfExecRes> {
    // Implementation
  }
}
```

### Naming Principles

- Use intention-revealing names
- Avoid mental mapping and abbreviations
- Use searchable names for important concepts
- Make names pronounceable
- Use consistent vocabulary across the codebase

### Domain-Specific Naming

```typescript
// ✅ Good: Domain-specific, clear names
export class OrderProcessor {
  async processPayment(order: Order): Promise<PaymentResult> {}
  async calculateShipping(order: Order): Promise<ShippingCost> {}
  async validateInventory(items: OrderItem[]): Promise<InventoryStatus> {}
}

// ✅ Good: Event naming
export class OrderCreatedEvent {
  constructor(public readonly order: Order) {}
}

export class PaymentProcessedEvent {
  constructor(
    public readonly orderId: OrderId,
    public readonly paymentResult: PaymentResult,
  ) {}
}
```

### Interface vs Implementation Naming

```typescript
// ✅ Good: Clear interface/implementation distinction
// No 'I' prefix for interfaces - use business language
export interface UserRepository {
  save(user: User): Promise<void>;
  findById(id: UserId): Promise<User | null>;
}

// Implementation uses technology prefix or suffix
export class PostgresUserRepository implements UserRepository {
  // Implementation
}

export class InMemoryUserRepository implements UserRepository {
  // Implementation for testing
}
```

### Generic Type Naming

```typescript
// ✅ Good: Descriptive generic names for complex cases
export interface Repository<TEntity, TId> {
  save(entity: TEntity): Promise<void>;
  findById(id: TId): Promise<TEntity | null>;
  delete(id: TId): Promise<void>;
}

// ✅ Good: Standard single letters for simple cases
export interface Mapper<T, U> {
  map(input: T): U;
}
```

### Error Class Naming

```typescript
// ✅ Good: Descriptive error names
export class UserNotFoundError extends Error {
  constructor(userId: UserId) {
    super(`User with ID ${userId} not found`);
    this.name = "UserNotFoundError";
  }
}

export class InvalidEmailFormatError extends Error {
  constructor(email: string) {
    super(`Invalid email format: ${email}`);
    this.name = "InvalidEmailFormatError";
  }
}
```

## Boolean Naming Conventions

```typescript
// ✅ Good: Clear boolean names
interface User {
  isActive: boolean;
  hasVerifiedEmail: boolean;
  canEditProfile: boolean;
}

// Methods
class OrderService {
  isOrderComplete(order: Order): boolean {}
  canProcessPayment(order: Order): boolean {}
  hasRequiredItems(order: Order): boolean {}
}

// ❌ Bad: Unclear boolean names
interface User {
  active: boolean; // Use isActive
  verified: boolean; // Use hasVerifiedEmail
  edit: boolean; // Use canEditProfile
}
```

## Method Naming Patterns

### CRUD Operations

```typescript
// ✅ Good: Standard CRUD naming
export class UserService {
  async createUser(userData: CreateUserData): Promise<User> {}
  async getUserById(id: UserId): Promise<User | null> {}
  async updateUser(id: UserId, updates: Partial<User>): Promise<User> {}
  async deleteUser(id: UserId): Promise<void> {}

  // Query methods
  async findUsersByEmail(email: string): Promise<User[]> {}
  async searchUsers(criteria: UserSearchCriteria): Promise<User[]> {}
}
```

### Business Operations

```typescript
// ✅ Good: Business-focused naming
export class OrderService {
  async processOrder(order: Order): Promise<OrderResult> {}
  async cancelOrder(orderId: OrderId): Promise<void> {}
  async refundOrder(orderId: OrderId, amount: Money): Promise<RefundResult> {}

  // Validation methods
  async validateOrderItems(items: OrderItem[]): Promise<ValidationResult> {}
  async checkInventoryAvailability(items: OrderItem[]): Promise<boolean> {}
}
```

## Variable Naming

### Collections

```typescript
// ✅ Good: Plural for collections
const users: User[] = [];
const activeOrders: Order[] = [];
const completedTasks: Task[] = [];

// ✅ Good: Descriptive collection names
const pendingPayments: Payment[] = [];
const expiredSessions: Session[] = [];
const validatedEmails: string[] = [];
```

### Temporary Variables

```typescript
// ✅ Good: Descriptive temporary names
async function processOrders(orders: Order[]): Promise<void> {
  for (const currentOrder of orders) {
    const paymentResult = await processPayment(currentOrder);
    const shippingCost = await calculateShipping(currentOrder);

    if (paymentResult.isSuccessful) {
      await updateOrderStatus(currentOrder.id, "paid");
    }
  }
}

// ❌ Bad: Generic temporary names
async function processOrders(orders: Order[]): Promise<void> {
  for (const item of orders) {
    // 'item' is too generic
    const result = await processPayment(item); // 'result' is too generic
    const cost = await calculateShipping(item); // 'cost' lacks context
  }
}
```

## Constant Naming

```typescript
// ✅ Good: Descriptive constants
export const DEFAULT_PAGE_SIZE = 20;
export const MAX_RETRY_ATTEMPTS = 3;
export const API_TIMEOUT_MS = 5000;
export const SUPPORTED_FILE_EXTENSIONS = [".jpg", ".png", ".gif"] as const;

// Configuration objects
export const DATABASE_CONFIG = {
  MAX_CONNECTIONS: 10,
  CONNECTION_TIMEOUT_MS: 30000,
  RETRY_DELAY_MS: 1000,
} as const;

// Enum-like constants
export const ORDER_STATUS = {
  PENDING: "pending",
  PROCESSING: "processing",
  SHIPPED: "shipped",
  DELIVERED: "delivered",
  CANCELLED: "cancelled",
} as const;

export type OrderStatus = (typeof ORDER_STATUS)[keyof typeof ORDER_STATUS];
```

## Anti-Patterns to Avoid

### Abbreviations and Acronyms

```typescript
// ❌ Bad: Unclear abbreviations
class UsrMgr {
  async createUsr(data: UsrData): Promise<Usr> {}
  async getUsrById(id: string): Promise<Usr> {}
}

// ✅ Good: Full names
class UserManager {
  async createUser(data: UserData): Promise<User> {}
  async getUserById(id: UserId): Promise<User> {}
}
```

### Mental Mapping

```typescript
// ❌ Bad: Requires mental mapping
const d = new Date(); // What does 'd' represent?
const u = await getUser(); // What does 'u' represent?
const temp = process(data); // What is 'temp'?

// ✅ Good: Clear intent
const currentDate = new Date();
const authenticatedUser = await getUser();
const processedData = process(data);
```

### Misleading Names

```typescript
// ❌ Bad: Misleading names
async function getUserList(): Promise<User> {
  // Returns single user, not list
  // Implementation
}

const userString = { id: 1, name: "John" }; // Object, not string

// ✅ Good: Accurate names
async function getUser(): Promise<User> {
  // Implementation
}

const userData = { id: 1, name: "John" };
```

### Inconsistent Vocabulary

```typescript
// ❌ Bad: Inconsistent terms for same concept
class UserService {
  async fetchUser(id: UserId): Promise<User> {}
  async retrieveUser(id: UserId): Promise<User> {}
  async getUser(id: UserId): Promise<User> {}
}

// ✅ Good: Consistent vocabulary
class UserService {
  async getUser(id: UserId): Promise<User> {}
  async getUserByEmail(email: string): Promise<User> {}
  async getUsersByRole(role: UserRole): Promise<User[]> {}
}
```

## Best Practices Summary

1. **Be Descriptive**: Names should clearly indicate purpose and content
2. **Be Consistent**: Use the same terms for the same concepts throughout the codebase
3. **Be Searchable**: Avoid single-letter variables and unclear abbreviations
4. **Be Pronounceable**: Names should be easy to say in team discussions
5. **Follow Conventions**: Stick to established TypeScript and domain conventions
6. **Context Matters**: Names should make sense within their scope and domain
7. **Avoid Mental Mapping**: Don't make readers translate abbreviated names
8. **Use Domain Language**: Prefer business domain terms over technical jargon when appropriate
9. **Use Appropriate Suffixes**: Apply consistent file suffixes to identify purpose (.entity.ts,
   .use-case.ts, etc.)
10. **Singular vs Plural**: Use singular for domain concepts, plural only for mixed collections
