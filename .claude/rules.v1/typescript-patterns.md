# TypeScript Code Patterns & Standards

## Type Safety & Definitions

### Strict TypeScript Rules

- **Never use `any`** - Use `unknown` with type guards instead
- **Install `@types/*`** packages for all dependencies
- **Create interfaces** for all data structures
- **Use Zod schemas** for runtime validation and type inference
- **Use type guards** for simple runtime validation

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

## Schema Validation with Zod

### Schema Definition and Type Inference

**ALWAYS use Zod for schema validation** - provides runtime validation with TypeScript type
inference:

```typescript
// ✅ Good: Zod schema with automatic type inference
import { z } from "zod";

// Define schema
const UserSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Invalid email format"),
  age: z.coerce.number().min(18, "Must be at least 18"),
  isActive: z.coerce.boolean().default(true),
  roles: z.array(z.enum(["admin", "user", "moderator"])).default(["user"]),
  metadata: z.record(z.string()).optional(),
});

// Automatic type inference - no manual interface needed!
type User = z.infer<typeof UserSchema>;

// Validation with detailed error messages
function validateUser(data: unknown): User {
  return UserSchema.parse(data); // Throws on validation error
}

// Safe validation with error handling
function safeValidateUser(
  data: unknown,
): { success: true; data: User } | { success: false; error: string } {
  const result = UserSchema.safeParse(data);

  if (result.success) {
    return { success: true, data: result.data };
  }

  const errorMessage = result.error.errors
    .map((err) => `${err.path.join(".")}: ${err.message}`)
    .join(", ");

  return { success: false, error: errorMessage };
}
```

### Environment Variables with Coercion

Use Zod's coercion for environment variable validation:

```typescript
// ✅ Good: Environment schema with automatic coercion
const EnvSchema = z.object({
  PORT: z.coerce.number().min(1).max(65535).default(3000),
  DATABASE_URL: z.string().url(),
  DEBUG: z.coerce.boolean().default(false),
  MAX_CONNECTIONS: z.coerce.number().min(1).default(10),
  ALLOWED_ORIGINS: z.string().default("http://localhost:3000"),
  LOG_LEVEL: z.enum(["error", "warn", "info", "debug"]).default("info"),
});

type Env = z.infer<typeof EnvSchema>;

// Validation with defaults and coercion
const env = EnvSchema.parse(process.env);
// PORT automatically converted from string to number
// DEBUG automatically converted from "true"/"false" to boolean
```

### API Request/Response Validation

```typescript
// ✅ Good: API validation with Zod
const CreateUserRequestSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  password: z.string().min(8),
  age: z.coerce.number().min(18).optional(),
});

const UserResponseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  email: z.string().email(),
  createdAt: z.string().datetime(),
  isActive: z.boolean(),
});

type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;
type UserResponse = z.infer<typeof UserResponseSchema>;

// In your API handler
app.post("/api/users", async (c) => {
  // Validate request body
  const body = CreateUserRequestSchema.parse(await c.req.json());

  // Business logic
  const user = await createUser(body);

  // Validate response (ensures API contract compliance)
  const response = UserResponseSchema.parse({
    id: user.id,
    name: user.name,
    email: user.email,
    createdAt: user.createdAt.toISOString(),
    isActive: user.isActive,
  });

  return c.json(response);
});
```

### Complex Validation with Refinements

```typescript
// ✅ Good: Complex validation rules with Zod refinements
const UserRegistrationSchema = z
  .object({
    email: z.string().email(),
    password: z.string().min(8),
    confirmPassword: z.string(),
    terms: z.boolean(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ["confirmPassword"],
  })
  .refine((data) => data.terms === true, {
    message: "Must accept terms and conditions",
    path: ["terms"],
  });

// Production-specific validation
const ProductionConfigSchema = BaseConfigSchema.refine(
  (data) => {
    if (data.NODE_ENV === "production") {
      return !data.JWT_SECRET.includes("dev_");
    }
    return true;
  },
  {
    message: "JWT_SECRET must not use development defaults in production",
    path: ["JWT_SECRET"],
  },
);
```

### Domain Value Objects with Zod

```typescript
// ✅ Good: Domain value objects with Zod validation
const EmailSchema = z
  .string()
  .email()
  .transform((email) => email.toLowerCase());

class Email {
  private constructor(private readonly value: string) {}

  static create(email: string): Email {
    const validated = EmailSchema.parse(email);
    return new Email(validated);
  }

  getValue(): string {
    return this.value;
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }
}

// Usage
const userEmail = Email.create("USER@EXAMPLE.COM"); // Automatically lowercased
```

### Hono Route Validation with @hono/zod-validator

**ALWAYS use @hono/zod-validator for API route validation** - provides automatic request validation
with type safety:

```typescript
// ✅ Good: Route validation with @hono/zod-validator
import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";

const app = new Hono();

// JSON Body Validation
const CreateUserSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Invalid email format"),
  age: z.coerce.number().min(18, "Must be at least 18"),
});

app.post("/api/users", zValidator("json", CreateUserSchema), (c) => {
  // Automatically validated and typed!
  const { name, email, age } = c.req.valid("json");

  // Create user logic
  return c.json({ id: "123", name, email, age }, 201);
});

// Query Parameters Validation
const GetUsersQuerySchema = z.object({
  page: z.coerce.number().min(1).default(1),
  limit: z.coerce.number().min(1).max(100).default(10),
  search: z.string().optional(),
  active: z.coerce.boolean().default(true),
});

app.get("/api/users", zValidator("query", GetUsersQuerySchema), (c) => {
  const { page, limit, search, active } = c.req.valid("query");

  // Query users with validated parameters
  return c.json({ users: [], page, limit });
});

// Route Parameters + Body Validation
const UpdateUserParamsSchema = z.object({
  id: z.string().uuid("Invalid user ID"),
});

const UpdateUserBodySchema = z
  .object({
    name: z.string().min(1).optional(),
    email: z.string().email().optional(),
  })
  .refine((data) => Object.keys(data).length > 0, {
    message: "At least one field must be provided",
  });

app.patch(
  "/api/users/:id",
  zValidator("param", UpdateUserParamsSchema),
  zValidator("json", UpdateUserBodySchema),
  (c) => {
    const { id } = c.req.valid("param");
    const updateData = c.req.valid("json");

    // Update user logic
    return c.json({ id, ...updateData });
  },
);

// Form Data Validation
const UploadFileSchema = z.object({
  title: z.string().min(1),
  description: z.string().optional(),
  file: z.instanceof(File),
});

app.post("/api/upload", zValidator("form", UploadFileSchema), async (c) => {
  const { title, description, file } = c.req.valid("form");

  // Handle file upload
  return c.json({ message: "File uploaded", title, size: file.size });
});

// Headers Validation (for API keys, auth tokens, etc.)
const AuthHeaderSchema = z.object({
  "x-api-key": z.string().min(1, "API key is required"),
  "content-type": z.literal("application/json").optional(),
});

app.post("/api/protected", zValidator("header", AuthHeaderSchema), (c) => {
  const headers = c.req.valid("header");

  // Access validated headers
  return c.json({ message: "Authenticated", apiKey: headers["x-api-key"] });
});
```

### Advanced Validation Patterns

```typescript
// Multiple validators with error handling
const CreatePostSchema = z.object({
  title: z.string().min(1).max(200),
  content: z.string().min(10),
  tags: z.array(z.string()).max(5).default([]),
  publishAt: z.string().datetime().optional(),
});

const PostParamsSchema = z.object({
  userId: z.string().uuid(),
});

app.post(
  "/api/users/:userId/posts",
  zValidator("param", PostParamsSchema),
  zValidator("json", CreatePostSchema),
  async (c) => {
    const { userId } = c.req.valid("param");
    const postData = c.req.valid("json");

    try {
      const post = await createPost(userId, postData);
      return c.json(post, 201);
    } catch (error) {
      return c.json({ error: "Failed to create post" }, 500);
    }
  },
);

// Custom error responses for validation failures
app.onError((err, c) => {
  if (err instanceof ValidationError) {
    return c.json(
      {
        error: "Validation failed",
        details: err.message,
        status: 400,
      },
      400,
    );
  }

  return c.json({ error: "Internal server error" }, 500);
});
```

### Why @hono/zod-validator Over Manual Validation

**✅ Benefits:**

- **Automatic validation**: No manual parsing and checking
- **Type safety**: Validated data is automatically typed
- **Error handling**: Built-in error responses with detailed messages
- **Multiple targets**: Validate json, form, query, param, header in one middleware
- **Composable**: Easily combine multiple validators per route
- **Performance**: Runs validation before your handler, failing fast on invalid input

**❌ Avoid manual validation:**

```typescript
// ❌ Bad: Manual validation (error-prone, verbose)
app.post("/api/users", async (c) => {
  const body = await c.req.json();

  if (!body.name || typeof body.name !== "string") {
    return c.json({ error: "Name is required and must be string" }, 400);
  }

  if (!body.email || !isValidEmail(body.email)) {
    return c.json({ error: "Valid email is required" }, 400);
  }

  if (body.age && (typeof body.age !== "number" || body.age < 18)) {
    return c.json({ error: "Age must be number and at least 18" }, 400);
  }

  // No type safety for body properties
  const user = { name: body.name, email: body.email, age: body.age };
  return c.json(user);
});
```

### Why Zod Over Other Libraries

- **Type Safety**: Automatic TypeScript type inference from schemas
- **Coercion**: Automatic type conversion (string "123" → number 123)
- **Rich Validation**: Built-in validators for common patterns (email, UUID, etc.)
- **Detailed Errors**: Precise error messages with path information
- **Schema Composition**: Easy to combine and extend schemas
- **Runtime Safety**: Validates data at runtime, not just compile time
- **No Code Generation**: Pure TypeScript, no build steps required
- **Hono Integration**: First-class support with @hono/zod-validator middleware

**❌ Avoid these validation libraries:**

- `joi` - No TypeScript inference, requires separate type definitions
- `yup` - Limited TypeScript support, verbose API
- `ajv` - JSON Schema based, no automatic type inference
- `@hono/typebox-validator` - Less ecosystem support, limited coercion
- Manual validation - Error-prone, no type safety

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

async function executeWorkflow(options: ExecuteWorkflowOptions): Promise<WorkflowResult> {
  const { workflowId, maxRetries = 3, timeout = 30000, context = {}, onProgress } = options;

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
  onProgress: (progress: number) => void,
): Promise<WorkflowResult> {
  // Hard to use and maintain
}
```

### Result Pattern for Error Handling

Use Result pattern for expected errors instead of exceptions:

```typescript
// ✅ Good: Result pattern for expected errors
type Result<T, E = Error> = { success: true; data: T } | { success: false; error: E };

async function validateUser(userData: CreateUserData): Promise<Result<User, ValidationError[]>> {
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
    private readonly config: UserServiceConfig,
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
      throw new OrderProcessingError(`Failed to process order ${order.id}`, error);
    }
  }

  // ✅ Good: Parallel operations for independent tasks
  async processOrdersInParallel(orders: Order[]): Promise<OrderResult[]> {
    const results = await Promise.allSettled(orders.map((order) => this.processOrder(order)));

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
    timeoutMs: number = 5000,
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
  async executeTransaction<T>(operation: (transaction: Transaction) => Promise<T>): Promise<T> {
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

  async withConnection<T>(operation: (connection: Connection) => Promise<T>): Promise<T> {
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
    private readonly emailService: EmailService,
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
