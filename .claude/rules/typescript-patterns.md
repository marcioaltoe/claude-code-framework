# TypeScript Patterns

## Core Principles

- **Never use `any`** - Use `unknown` with type guards
- **Type everything** - Interfaces for all data structures
- **Validate at boundaries** - Runtime validation for external data

## Validation with Zod

```typescript
import { z } from "zod";

// Define schema and infer type
const UserSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1),
  email: z.string().email(),
  age: z.coerce.number().min(18).optional(), // Coercion for type conversion
});

type User = z.infer<typeof UserSchema>;

// Validate data
const user = UserSchema.parse(data); // Throws on error
const result = UserSchema.safeParse(data); // Returns success/error object

// Environment variables
const EnvSchema = z.object({
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  DEBUG: z.coerce.boolean().default(false),
});

const env = EnvSchema.parse(process.env);
```

## Hono API Validation

```typescript
import { zValidator } from "@hono/zod-validator";

// Query parameters
const QuerySchema = z.object({
  page: z.coerce.number().default(1),
  limit: z.coerce.number().max(100).default(10),
  active: z.coerce.boolean().optional(),
});

app.get("/api/users", zValidator("query", QuerySchema), (c) => {
  const { page, limit, active } = c.req.valid("query");
  // Automatically validated and typed
});

// JSON body
const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

app.post("/api/users", zValidator("json", CreateUserSchema), (c) => {
  const user = c.req.valid("json");
  // Validated and typed
});

// Multiple validators
app.patch(
  "/api/users/:id",
  zValidator("param", z.object({ id: z.string().uuid() })),
  zValidator("json", UpdateSchema),
  (c) => {
    const { id } = c.req.valid("param");
    const updates = c.req.valid("json");
  }
);
```

## Function Patterns

```typescript
// Options object for multiple parameters
interface CreateUserOptions {
  name: string;
  email: string;
  role?: UserRole;
  sendWelcomeEmail?: boolean;
}

async function createUser(options: CreateUserOptions): Promise<User> {
  const { name, email, role = "user", sendWelcomeEmail = true } = options;
  // Implementation
}

// Result pattern for errors
type Result<T, E = Error> = 
  | { success: true; data: T } 
  | { success: false; error: E };

async function validateUser(data: unknown): Promise<Result<User>> {
  const result = UserSchema.safeParse(data);
  if (!result.success) {
    return { success: false, error: new Error(result.error.message) };
  }
  return { success: true, data: result.data };
}

// Constructor dependency injection
class UserService {
  constructor(
    private readonly repository: UserRepository,
    private readonly emailService: EmailService,
  ) {}
}
```

## Async Patterns

```typescript
// Parallel execution
const results = await Promise.all([
  fetchUser(id),
  fetchOrders(id),
  fetchPayments(id),
]);

// With error handling
const results = await Promise.allSettled(operations);

// Timeout with AbortController
const controller = new AbortController();
const timeoutId = setTimeout(() => controller.abort(), 5000);

try {
  const response = await fetch(url, { signal: controller.signal });
} finally {
  clearTimeout(timeoutId);
}

// Resource cleanup
try {
  const connection = await getConnection();
  return await operation(connection);
} finally {
  await connection.close();
}
```

## Control Flow

```typescript
// Early returns
function processOrder(order: Order): void {
  if (!order) throw new Error("Order required");
  if (!order.items.length) throw new Error("Items required");
  if (!order.customer?.isActive) throw new Error("Active customer required");
  
  // Process order
}

// Avoid flag parameters
function saveUser(user: User): Promise<void> { }
function saveUserAsDraft(user: User): Promise<void> { }
// NOT: saveUser(user, isDraft: boolean)
```

## Best Practices

1. **Never use `any`** - Use `unknown` with type guards
2. **Validate at boundaries** - Use Zod for external data
3. **Options objects** - For functions with multiple parameters
4. **Result pattern** - For expected errors
5. **Early returns** - Avoid deep nesting
6. **Composition over inheritance** - More flexible
7. **Resource cleanup** - Always use try/finally
