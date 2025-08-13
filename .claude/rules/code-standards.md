# TypeScript & Node.js Code Standards

## Language Requirements

- All source code must be written in **English**
- All source code must be written in **TypeScript**
- Use **Yarn** as the standard package manager
- Run scripts with `yarn` commands

## Type Definitions & Safety

### Type Installation
- Install type definitions for all libraries
- Example: `jest` requires `@types/jest`
- Always validate typing correctness before completing tasks

### Type Safety Rules
- **Never use `any`** type
- Create proper interfaces or types for all data structures
- Use `unknown` when type is truly unknown and add type guards
- Install `@types/*` packages for all dependencies

```typescript
// ✅ Good
interface UserData {
  id: string
  name: string
  email: string
}

function processUser(data: UserData): void {
  // Implementation with full type safety
}

// ❌ Bad
function processUser(data: any): void {
  // Loses all type safety
}
```

## Variable Declaration

### Best Practices
- Use `const` wherever possible
- Use `let` only when reassignment is necessary
- **Never use `var`** for variable declarations
- Never declare multiple variables on same line
- Declare variables close to where they're used

```typescript
// ✅ Good
const API_URL = 'https://api.example.com'
const users = []
let currentIndex = 0

const firstName = user.firstName
const lastName = user.lastName

// ❌ Bad
var oldVariable = 'avoid this'
const firstName = user.firstName, lastName = user.lastName
```

## Naming Conventions

### Case Styles
- **camelCase**: Methods, functions, and variables
  - `getUserById()`, `calculateTotal()`, `isActive`
- **PascalCase**: Classes and interfaces
  - `UserService`, `OrderRepository`, `PaymentGateway`
- **kebab-case**: Files and directories
  - `user-service.ts`, `order-repository.ts`, `payment-gateway/`

### Naming Guidelines
- Avoid abbreviations (exception: well-known terms like `API`, `URL`)
- Keep names descriptive but concise (max 30 characters)
- Use meaningful, self-documenting names
- Functions must start with a verb, never a noun

```typescript
// ✅ Good
const userAuthenticationToken = '...'
const calculateOrderTotal = () => {}
class CustomerRepository {}
function createUser() {}
function validateEmail() {}
function isValidDate() {}

// ❌ Avoid
const usrAuthTkn = '...'
const calc = () => {}
class CustRepo {}
function userCreation() {}
function emailValidation() {}
```

## Constants and Magic Numbers

- Declare constants for all magic numbers
- Use descriptive names that explain the value's purpose

```typescript
// ✅ Good
const MAX_RETRY_ATTEMPTS = 3
const DEFAULT_PAGE_SIZE = 20
const TAX_RATE = 0.08

// ❌ Avoid
if (retries > 3) { ... }
const pageSize = 20
```

## Class Design

### Property Visibility
- Declare class properties as `private` or `readonly`
- Avoid using `public` modifier (it's implicit)
- Use dependency injection through constructors

```typescript
class UserService {
  private readonly repository: UserRepository
  private cache: Map<string, User>

  constructor(repository: UserRepository) {
    this.repository = repository
    this.cache = new Map()
  }
}
```

## Functions and Methods

### Parameter Guidelines
- Limit to 3 parameters maximum
- Use objects for multiple related parameters
- A function should either return data OR cause a side effect, never both

```typescript
// ✅ Good - Limited parameters
function createOrder(
  customerId: string,
  items: OrderItem[],
  options?: OrderOptions
) {}

// ✅ Better - Object parameter for many params
interface CreateOrderParams {
  customerId: string
  items: OrderItem[]
  shippingAddress: Address
  billingAddress: Address
  discountCode?: string
}

function createOrder(params: CreateOrderParams) {}

// ✅ Good - Separate queries from commands
function getUser(id: string): User {
  return database.findUser(id)
}

function updateUser(id: string, data: UserData): void {
  database.updateUser(id, data)
}

// ❌ Avoid - Mixed responsibility
function getUserAndLog(id: string): User {
  const user = database.findUser(id)
  logger.info(`User ${id} accessed`) // Side effect in query
  return user
}
```

### Control Flow Best Practices

#### Early Returns
- Use early returns to avoid deep nesting
- Maximum nesting level: 2

```typescript
// ✅ Good
function processOrder(order: Order): void {
  if (!order) {
    throw new Error('Order is required')
  }

  if (!order.items.length) {
    throw new Error('Order must have items')
  }

  // Process order
}

// ❌ Avoid
function processOrder(order: Order): void {
  if (order) {
    if (order.items.length) {
      // Process order
    } else {
      throw new Error('Order must have items')
    }
  } else {
    throw new Error('Order is required')
  }
}
```

#### Flag Parameters
- Never use boolean flags to control function behavior
- Create separate functions instead

```typescript
// ✅ Good
function saveUser(user: User): void {}
function saveUserAsDraft(user: User): void {}

// ❌ Avoid
function saveUser(user: User, isDraft: boolean): void {
  if (isDraft) {
    // Save as draft
  } else {
    // Save normally
  }
}
```

## Functional Programming

### Array Operations
Prefer functional methods over imperative loops:
- `find()` - locate single element
- `filter()` - select multiple elements
- `map()` - transform elements
- `reduce()` - aggregate values

```typescript
// ✅ Good
const activeUsers = users.filter((user) => user.isActive)
const userNames = users.map((user) => user.name)
const totalAge = users.reduce((sum, user) => sum + user.age, 0)

// ❌ Avoid
const activeUsers = []
for (let i = 0; i < users.length; i++) {
  if (users[i].isActive) {
    activeUsers.push(users[i])
  }
}
```

## Asynchronous Programming

### Async/Await
- Always use `async/await` for Promise handling
- Avoid callbacks and `.then()` chains
- Handle errors appropriately with try/catch

```typescript
// ✅ Good
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`)
    return response.data
  } catch (error) {
    throw new Error(`Failed to fetch user: ${error.message}`)
  }
}

// ❌ Avoid
function fetchUser(id: string, callback: (err: Error, user?: User) => void) {
  api
    .get(`/users/${id}`)
    .then((response) => callback(null, response.data))
    .catch((error) => callback(error))
}
```

## Module System

### Imports and Exports
- Always use ES6 `import` syntax
- Never use `require()` or `module.exports`
- Use `export default` for single exports
- Use named exports for multiple exports

```typescript
// ✅ Single export
export default class UserService {
  // Implementation
}

// ✅ Multiple exports
export interface User {
  id: string
  name: string
}

export class UserRepository {
  // Implementation
}

// ✅ Importing
import UserService from './UserService'
import { User, UserRepository } from './user'

// ❌ Avoid
const UserService = require('./UserService')
module.exports = UserService
```

## Code Size Limits

### Methods and Functions
- Maximum **50 lines** per function
- If exceeding, extract helper functions

### Classes
- Maximum **300 lines** per class
- If exceeding, split responsibilities following SRP

## Dependency Management

### Dependency Inversion Principle
- Always invert dependencies for external resources (HTTP, storage, etc.)
- Use interfaces to define contracts
- Inject implementations through constructors
- Avoid circular dependencies
- Keep module dependencies clear and minimal

```typescript
// ✅ Good - Dependency inversion
interface PaymentGateway {
  processPayment(amount: number): Promise<PaymentResult>
}

class PaymentService {
  constructor(private readonly gateway: PaymentGateway) {}

  async processOrder(order: Order): Promise<void> {
    await this.gateway.processPayment(order.total)
  }
}

// ❌ Avoid - Direct dependency
class PaymentService {
  async processOrder(order: Order): Promise<void> {
    const stripe = new Stripe() // Direct dependency
    await stripe.charge(order.total)
  }
}

// ✅ Good - Clear dependency flow
// UserController → UserService → UserRepository → Database

// ❌ Bad - Circular dependency
// UserService → NotificationService → UserService
```

## Design Principles

### Composition Over Inheritance
- Prefer composition to class inheritance
- Use interfaces for contracts
- Compose behaviors through dependency injection

```typescript
// ✅ Good - Composition
interface Logger {
  log(message: string): void
}

class UserService {
  constructor(private readonly logger: Logger) {}
}

// ❌ Avoid - Inheritance
class BaseService {
  protected log(message: string): void {}
}

class UserService extends BaseService {}
```

## Code Formatting

### Blank Lines and Organization
- Avoid blank lines within methods and functions
- Use blank lines between methods/functions
- Group related code together

### Comments
- Avoid comments when possible
- Write self-documenting code instead
- Use comments only for:
  - Complex algorithms explanation
  - Business rule clarification
  - TODO/FIXME with ticket references

## Best Practices Summary

1. **Type Safety**: Use TypeScript strictly, never `any`
2. **Naming**: Clear, descriptive names in appropriate case styles
3. **Functions**: Small (≤50 lines), single responsibility, early returns
4. **Classes**: Limited size (≤300 lines), proper encapsulation
5. **Async**: Always use async/await, never callbacks
6. **Modules**: ES6 imports/exports only
7. **Arrays**: Functional methods over imperative loops
8. **Dependencies**: Invert dependencies, use interfaces
9. **Design**: Composition over inheritance
10. **Code Quality**: Self-documenting, minimal comments, consistent formatting