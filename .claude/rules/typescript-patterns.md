# TypeScript Code Patterns & Standards

## Type Safety & Definitions

### Strict TypeScript Rules

- **Never use `any`** - Use `unknown` with type guards instead
- **Install `@types/*`** packages for all dependencies
- **Create interfaces** for all data structures
- **Use type guards** for runtime validation

```typescript
// ✅ Good: Proper typing
interface UserData {
  id: string;
  name: string;
  email: string;
  role?: UserRole;
}

function isUserData(obj: unknown): obj is UserData {
  return (
    typeof obj === "object" &&
    obj !== null &&
    "id" in obj &&
    "name" in obj &&
    typeof (obj as UserData).name === "string"
  );
}

// ❌ Bad: Using any
function processUser(data: any): void {
  // Loses all type safety
}
```

## Function Design Patterns

### Options Object Pattern

Use objects for functions with multiple parameters:

```typescript
// ✅ Good: Options object for complex parameters
interface ExecuteWorkflowOptions {
  workflowId: string;
  maxRetries?: number;
  timeout?: number;
  context?: Record<string, unknown>;
  onProgress?: (progress: number) => void;
}

async function executeWorkflow(
  options: ExecuteWorkflowOptions
): Promise<WorkflowResult> {
  const {
    workflowId,
    maxRetries = 3,
    timeout = 30000,
    context = {},
    onProgress,
  } = options;

  // Implementation
}

// Usage
await executeWorkflow({
  workflowId: "workflow-123",
  maxRetries: 5,
  onProgress: (progress) => console.log(`Progress: ${progress}%`),
});

// ❌ Bad: Too many parameters
async function executeWorkflow(
  workflowId: string,
  maxRetries: number,
  timeout: number,
  context: Record<string, unknown>,
  onProgress: (progress: number) => void
): Promise<WorkflowResult> {
  // Hard to use and maintain
}
```

### Result Pattern for Error Handling

Use Result pattern for expected errors instead of exceptions:

```typescript
// ✅ Good: Result pattern for expected errors
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function validateUser(
  userData: CreateUserData
): Promise<Result<User, ValidationError[]>> {
  const errors: ValidationError[] = [];

  if (!userData.email) {
    errors.push(new ValidationError("Email is required"));
  }

  if (!userData.name) {
    errors.push(new ValidationError("Name is required"));
  }

  if (errors.length > 0) {
    return { success: false, error: errors };
  }

  const user = UserFactory.create(userData);
  return { success: true, data: user };
}

// Usage
const result = await validateUser(userData);
if (result.success) {
  console.log("User created:", result.data);
} else {
  console.log("Validation errors:", result.error);
}
```

### Constructor Dependency Injection

Always use constructor injection for dependencies:

```typescript
// ✅ Good: Constructor injection with validation
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly emailService: EmailService,
    private readonly logger: Logger,
    private readonly config: UserServiceConfig
  ) {
    // Validate required dependencies
    if (!userRepository) {
      throw new Error("UserRepository is required");
    }
    if (!emailService) {
      throw new Error("EmailService is required");
    }
  }

  async createUser(userData: CreateUserData): Promise<User> {
    this.logger.info("Creating user", { email: userData.email });

    const user = UserFactory.create(userData);
    await this.userRepository.save(user);

    if (this.config.sendWelcomeEmail) {
      await this.emailService.sendWelcomeEmail(user.email);
    }

    return user;
  }
}

// Configuration interface
interface UserServiceConfig {
  sendWelcomeEmail: boolean;
  maxUsersPerDay: number;
  defaultRole: UserRole;
}
```

## Async/Await Patterns

### Proper Promise Handling

```typescript
// ✅ Good: Sequential operations with proper error handling
export class OrderService {
  async processOrder(order: Order): Promise<OrderResult> {
    try {
      // Sequential operations that depend on each other
      const paymentResult = await this.processPayment(order);
      const inventoryResult = await this.updateInventory(order);
      const shippingResult = await this.scheduleShipping(order);

      return {
        orderId: order.id,
        paymentResult,
        inventoryResult,
        shippingResult,
        status: "completed",
      };
    } catch (error) {
      await this.rollbackOrder(order);
      throw new OrderProcessingError(
        `Failed to process order ${order.id}`,
        error
      );
    }
  }

  // ✅ Good: Parallel operations for independent tasks
  async processOrdersInParallel(orders: Order[]): Promise<OrderResult[]> {
    const results = await Promise.allSettled(
      orders.map((order) => this.processOrder(order))
    );

    return results.map((result, index) => {
      if (result.status === "fulfilled") {
        return result.value;
      } else {
        this.logger.error("Order processing failed", {
          orderId: orders[index].id,
          error: result.reason,
        });
        throw result.reason;
      }
    });
  }
}
```

### Timeout and Cancellation

```typescript
// ✅ Good: Timeout and cancellation support
export class ApiService {
  async fetchWithTimeout<T>(
    url: string,
    options: RequestOptions = {},
    timeoutMs: number = 5000
  ): Promise<T> {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

    try {
      const response = await fetch(url, {
        ...options,
        signal: controller.signal,
      });

      if (!response.ok) {
        throw new ApiError(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      if (error.name === "AbortError") {
        throw new TimeoutError(`Request timed out after ${timeoutMs}ms`);
      }
      throw error;
    } finally {
      clearTimeout(timeoutId);
    }
  }
}
```

### Resource Management

```typescript
// ✅ Good: Proper resource cleanup
export class DatabaseService {
  async executeTransaction<T>(
    operation: (transaction: Transaction) => Promise<T>
  ): Promise<T> {
    const transaction = await this.database.beginTransaction();

    try {
      const result = await operation(transaction);
      await transaction.commit();
      return result;
    } catch (error) {
      await transaction.rollback();
      throw error;
    } finally {
      await transaction.close();
    }
  }

  async withConnection<T>(
    operation: (connection: Connection) => Promise<T>
  ): Promise<T> {
    const connection = await this.pool.getConnection();

    try {
      return await operation(connection);
    } finally {
      await this.pool.releaseConnection(connection);
    }
  }
}
```

## Function Composition

```typescript
// ✅ Good: Function composition for reusable validation
type Validator<T> = (value: T) => Result<T, ValidationError>;

const required: Validator<string> = (value) => {
  if (!value?.trim()) {
    return { success: false, error: new ValidationError("Value is required") };
  }
  return { success: true, data: value };
};

const minLength =
  (min: number): Validator<string> =>
  (value) => {
    if (value.length < min) {
      return {
        success: false,
        error: new ValidationError(`Minimum length is ${min}`),
      };
    }
    return { success: true, data: value };
  };

const email: Validator<string> = (value) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(value)) {
    return {
      success: false,
      error: new ValidationError("Invalid email format"),
    };
  }
  return { success: true, data: value };
};

// Compose validators
function compose<T>(...validators: Validator<T>[]): Validator<T> {
  return (value: T) => {
    for (const validator of validators) {
      const result = validator(value);
      if (!result.success) {
        return result;
      }
    }
    return { success: true, data: value };
  };
}

// Usage
const emailValidator = compose(required, email);
const passwordValidator = compose(required, minLength(8));
```

## Class Design Patterns

### Property Visibility and Encapsulation

```typescript
// ✅ Good: Proper encapsulation
class UserService {
  private readonly repository: UserRepository;
  private cache: Map<string, User>;

  constructor(repository: UserRepository) {
    this.repository = repository;
    this.cache = new Map();
  }

  async getUser(id: string): Promise<User | null> {
    // Check cache first
    if (this.cache.has(id)) {
      return this.cache.get(id)!;
    }

    // Fetch from repository
    const user = await this.repository.findById(id);
    if (user) {
      this.cache.set(id, user);
    }

    return user;
  }
}
```

### Composition Over Inheritance

```typescript
// ✅ Good: Composition pattern
interface Logger {
  log(message: string): void;
}

interface EmailService {
  sendEmail(to: string, subject: string, body: string): Promise<void>;
}

class UserService {
  constructor(
    private readonly logger: Logger,
    private readonly emailService: EmailService
  ) {}

  async notifyUser(user: User, message: string): Promise<void> {
    this.logger.log(`Notifying user ${user.id}`);
    await this.emailService.sendEmail(user.email, "Notification", message);
  }
}

// ❌ Avoid: Inheritance
class BaseService {
  protected log(message: string): void {
    console.log(message);
  }
}

class UserService extends BaseService {
  // Inherits logging behavior, but less flexible
}
```

## Naming Conventions

### TypeScript-Specific Naming

```typescript
// ✅ Good: Clear TypeScript naming
interface CreateUserRequest {
  name: string;
  email: string;
  role?: UserRole;
}

type UserStatus = "active" | "inactive" | "pending";

enum OrderStatus {
  PENDING = "pending",
  PROCESSING = "processing",
  COMPLETED = "completed",
  CANCELLED = "cancelled",
}

class UserRepository {
  async findByEmail(email: string): Promise<User | null> {
    // Implementation
  }
}

// Constants
const MAX_RETRY_ATTEMPTS = 3;
const DEFAULT_TIMEOUT_MS = 5000;
```

## Bun-Specific Patterns

### Bun Runtime APIs

```typescript
// ✅ Good: Use Bun native APIs for data and files
import { Database } from "bun:sqlite";
import { Hono } from "hono";

// Database with bun:sqlite
const db = new Database("mydb.sqlite");
const query = db.query("SELECT * FROM users WHERE id = ?");
const user = query.get(userId);

// HTTP Server with Hono (not Bun.serve)
const app = new Hono();

app.get("/api/users/:id", async (c) => {
  const userId = c.req.param("id");
  const user = getUserById(userId);
  return c.json(user);
});

export default {
  port: 3000,
  fetch: app.fetch,
};

// File operations with Bun.file
const file = Bun.file("./data.json");
const data = await file.json();
await Bun.write("./output.json", JSON.stringify(data));

// ❌ Avoid: Node.js equivalents for files/DB
import express from "express"; // Use Hono instead
import fs from "node:fs/promises"; // Use Bun.file instead
import sqlite3 from "sqlite3"; // Use bun:sqlite instead
```

### Bun Shell Commands

```typescript
// ✅ Good: Use Bun.$ for shell commands
import { $ } from "bun";

async function deployApp() {
  await $`bun run build`;
  await $`docker build -t myapp .`;
  await $`docker push myapp:latest`;
}

// ❌ Avoid: External shell libraries
import { execa } from "execa";
await execa("npm", ["run", "build"]);
```

## Module System & Imports

### ES6 Module Patterns

```typescript
// ✅ Good: Clean imports and exports
// user.types.ts
export interface User {
  id: string;
  name: string;
  email: string;
}

export type CreateUserData = Omit<User, "id">;

// user.service.ts
import { User, CreateUserData } from "./user.types";
import { UserRepository } from "./user.repository";

export class UserService {
  constructor(private readonly repository: UserRepository) {}

  async createUser(data: CreateUserData): Promise<User> {
    // Implementation
  }
}

// index.ts (barrel exports)
export { UserService } from "./user.service";
export { UserRepository } from "./user.repository";
export type { User, CreateUserData } from "./user.types";

// ❌ Avoid: CommonJS
const UserService = require("./user.service");
module.exports = { UserService };
```

## Functional Programming Patterns

### Array Operations

```typescript
// ✅ Good: Functional array methods
const activeUsers = users.filter((user) => user.isActive);
const userNames = users.map((user) => user.name);
const totalAge = users.reduce((sum, user) => sum + user.age, 0);

// Find specific user
const adminUser = users.find((user) => user.role === "admin");

// Check if any user matches condition
const hasActiveUsers = users.some((user) => user.isActive);

// Check if all users match condition
const allUsersVerified = users.every((user) => user.isVerified);

// ❌ Avoid: Imperative loops
const activeUsers = [];
for (let i = 0; i < users.length; i++) {
  if (users[i].isActive) {
    activeUsers.push(users[i]);
  }
}
```

## Control Flow Patterns

### Early Returns and Guard Clauses

```typescript
// ✅ Good: Early returns to avoid nesting
function processOrder(order: Order): void {
  if (!order) {
    throw new Error("Order is required");
  }

  if (order.items.length === 0) {
    throw new Error("Order must have items");
  }

  if (!order.customer) {
    throw new Error("Customer is required");
  }

  if (!order.customer.isActive) {
    throw new Error("Customer is not active");
  }

  if (order.total <= 0) {
    throw new Error("Order total must be positive");
  }

  // Process order logic here
}

// ❌ Avoid: Deep nesting
function processOrder(order: Order): void {
  if (order) {
    if (order.items.length > 0) {
      if (order.customer) {
        if (order.customer.isActive) {
          if (order.total > 0) {
            // Process order - too deeply nested
          }
        }
      }
    }
  }
}
```

### Avoid Flag Parameters

```typescript
// ✅ Good: Separate functions instead of flags
function saveUser(user: User): Promise<void> {
  return this.repository.save(user);
}

function saveUserAsDraft(user: User): Promise<void> {
  return this.repository.saveDraft(user);
}

// ❌ Avoid: Boolean flags
function saveUser(user: User, isDraft: boolean): Promise<void> {
  if (isDraft) {
    return this.repository.saveDraft(user);
  } else {
    return this.repository.save(user);
  }
}
```

## Best Practices Summary

1. **Type Safety**: Never use `any`, create proper interfaces, use type guards
2. **Function Design**: Options objects for multiple params, Result pattern for expected errors
3. **Async Patterns**: Proper Promise handling, timeout/cancellation, resource cleanup
4. **Class Design**: Constructor injection, composition over inheritance, proper encapsulation
5. **Error Handling**: Result pattern for expected errors, exceptions for unexpected errors
6. **Module System**: ES6 imports/exports, barrel exports for clean API
7. **Functional Style**: Array methods over loops, pure functions when possible
8. **Control Flow**: Early returns, guard clauses, avoid flag parameters
9. **Naming**: Clear TypeScript conventions, descriptive names
10. **Resource Management**: Always clean up resources, use try/finally blocks
