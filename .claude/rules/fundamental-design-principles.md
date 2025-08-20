# Fundamental Design Principles

## Overview

DRY ("Don't Repeat Yourself"), YAGNI ("You Aren't Gonna Need It"), KISS ("Keep It Simple, Stupid"),
and TDA ("Tell, Don't Ask") form the foundation of software engineering best practices. These
**architectural design principles** are universally adopted to create systems that are simpler, more
efficient, scalable, and maintainable.

Together, they establish core guidelines for quality software construction, helping developers make
better decisions about code structure, feature implementation, and system architecture.

## DRY - Don't Repeat Yourself

### Core Principle

**Every piece of knowledge must have a single, unambiguous, authoritative representation**

### Common Patterns

#### Extract Utility Functions

```typescript
// ✅ Good - Reusable validation
const validateRequired = (value: string, fieldName: string): void => {
  if (!value?.trim()) {
    throw new ValidationError(`${fieldName} is required`);
  }
};

// Usage across multiple validators
class UserValidator {
  validateName(name: string): void {
    validateRequired(name, "name");
  }
}

class ProductValidator {
  validateTitle(title: string): void {
    validateRequired(title, "title");
  }
}

// ❌ Bad - Repeated logic
class UserValidator {
  validateName(name: string): void {
    if (!name?.trim()) {
      throw new ValidationError("Name is required");
    }
  }
}

class ProductValidator {
  validateTitle(title: string): void {
    if (!title?.trim()) {
      throw new ValidationError("Title is required");
    }
  }
}
```

#### Centralize Configuration

```typescript
// ✅ Good - Single source of truth
const CONFIG = {
  API_TIMEOUT: 5000,
  MAX_RETRIES: 3,
  PAGINATION_SIZE: 20,
} as const;

class ApiClient {
  async request(url: string): Promise<Response> {
    const controller = new AbortController();
    setTimeout(() => controller.abort(), CONFIG.API_TIMEOUT);

    return fetch(url, { signal: controller.signal });
  }
}

// ❌ Bad - Magic numbers scattered
class ApiClient {
  async request(url: string): Promise<Response> {
    setTimeout(() => controller.abort(), 5000); // Magic number
  }
}

class PaginationService {
  getPage(page: number) {
    return items.slice(page * 20, (page + 1) * 20); // Magic number
  }
}
```

#### Generic Types for Similar Operations

```typescript
// ✅ Good - Generic repository pattern
interface Repository<T> {
  findById(id: string): Promise<T | null>;
  save(entity: T): Promise<void>;
  delete(id: string): Promise<void>;
}

class UserRepository implements Repository<User> {
  // Implementation specific to User
}

class ProductRepository implements Repository<Product> {
  // Implementation specific to Product
}

// ❌ Bad - Repeated interface definitions
interface UserRepository {
  findUserById(id: string): Promise<User | null>;
  saveUser(user: User): Promise<void>;
  deleteUser(id: string): Promise<void>;
}

interface ProductRepository {
  findProductById(id: string): Promise<Product | null>;
  saveProduct(product: Product): Promise<void>;
  deleteProduct(id: string): Promise<void>;
}
```

### When NOT to Apply DRY

```typescript
// ✅ Good - Similar but different contexts
class UserValidator {
  validateEmail(email: string): void {
    if (!email.includes("@")) {
      throw new ValidationError("Invalid user email format");
    }
  }
}

class ContactValidator {
  validateEmail(email: string): void {
    if (!email.includes("@")) {
      throw new ValidationError("Invalid contact email format");
    }
  }
}

// Don't extract if the similarity is coincidental
// Different contexts may evolve differently
```

## YAGNI - You Aren't Gonna Need It

### Core Principle

**Don't implement functionality until you actually need it**

### Practical Applications

#### Start Simple, Refactor When Needed

```typescript
// ✅ Good - Start with simple implementation
class UserService {
  createUser(userData: CreateUserData): User {
    // Simple validation
    if (!userData.email) {
      throw new Error("Email required");
    }

    return new User(userData);
  }
}

// Later, when complexity is justified:
class UserService {
  constructor(
    private validator: UserValidator,
    private repository: UserRepository,
    private eventBus: EventBus,
  ) {}

  async createUser(userData: CreateUserData): Promise<User> {
    await this.validator.validate(userData);
    const user = new User(userData);
    await this.repository.save(user);
    await this.eventBus.publish(new UserCreatedEvent(user));
    return user;
  }
}

// ❌ Bad - Over-engineering from the start
class UserService {
  constructor(
    private validator: UserValidator,
    private repository: UserRepository,
    private eventBus: EventBus,
    private auditLogger: AuditLogger,
    private cacheService: CacheService,
    private notificationService: NotificationService,
  ) {}

  // Complex implementation for simple use case
}
```

#### Avoid Premature Abstraction

```typescript
// ✅ Good - Concrete implementation first
class OrderCalculator {
  calculateTotal(items: OrderItem[]): number {
    return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  }
}

// Later, when you need tax calculation:
class OrderCalculator {
  calculateTotal(items: OrderItem[], taxRate: number = 0): number {
    const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    return subtotal * (1 + taxRate);
  }
}

// ❌ Bad - Abstract strategy pattern before needed
interface PricingStrategy {
  calculate(items: OrderItem[]): number;
}

class SimplePricingStrategy implements PricingStrategy {
  calculate(items: OrderItem[]): number {
    return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  }
}

class OrderCalculator {
  constructor(private strategy: PricingStrategy) {}

  calculateTotal(items: OrderItem[]): number {
    return this.strategy.calculate(items);
  }
}
```

#### Feature Evolution Example

```typescript
// Phase 1: Simple user creation
class UserService {
  createUser(email: string, name: string): User {
    return new User({ email, name });
  }
}

// Phase 2: Add validation when needed
class UserService {
  createUser(email: string, name: string): User {
    this.validateEmail(email);
    return new User({ email, name });
  }

  private validateEmail(email: string): void {
    if (!email.includes("@")) {
      throw new Error("Invalid email");
    }
  }
}

// Phase 3: Add persistence when needed
class UserService {
  constructor(private repository: UserRepository) {}

  async createUser(email: string, name: string): Promise<User> {
    this.validateEmail(email);
    const user = new User({ email, name });
    await this.repository.save(user);
    return user;
  }
}
```

## KISS - Keep It Simple, Stupid

### Core Principle

**Simplicity should be a key goal in design - avoid unnecessary complexity**

### Practical Applications

#### Choose Simple Solutions First

```typescript
// ✅ Good - Simple and direct
class UserService {
  async findUser(id: string): Promise<User | null> {
    return await this.repository.findById(id);
  }
}

// ❌ Bad - Unnecessary complexity
class UserService {
  private cache = new Map<string, CacheEntry>();
  private strategies = new Map<string, FindStrategy>();

  async findUser(id: string, options?: FindOptions): Promise<User | null> {
    const strategy = this.getStrategy(options?.strategy || "default");
    const cacheKey = this.generateCacheKey(id, options);

    if (this.cache.has(cacheKey) && !this.isCacheExpired(cacheKey)) {
      return this.cache.get(cacheKey)?.data;
    }

    const user = await strategy.execute(id, options);
    this.updateCache(cacheKey, user);
    return user;
  }
}
```

#### Prefer Composition Over Complex Inheritance

```typescript
// ✅ Good - Simple composition
class OrderProcessor {
  constructor(
    private validator: OrderValidator,
    private calculator: PriceCalculator,
    private notifier: OrderNotifier,
  ) {}

  async process(order: Order): Promise<void> {
    this.validator.validate(order);
    const total = this.calculator.calculate(order);
    await this.notifier.notify(order, total);
  }
}

// ❌ Bad - Complex inheritance hierarchy
abstract class BaseOrderProcessor {
  abstract validate(order: Order): void;
  abstract calculate(order: Order): number;
  abstract notify(order: Order, total: number): Promise<void>;
}

class StandardOrderProcessor extends BaseOrderProcessor {
  // Implementation
}

class PremiumOrderProcessor extends StandardOrderProcessor {
  // Override methods
}

class EnterpriseOrderProcessor extends PremiumOrderProcessor {
  // More overrides
}
```

## TDA - Tell, Don't Ask

### Core Principle

**Tell objects what to do instead of asking for their data**

### Practical Applications

#### Encapsulate Behavior with Data

```typescript
// ✅ Good - Tell the object what to do
class BankAccount {
  private balance: number = 0;

  deposit(amount: number): void {
    if (amount <= 0) {
      throw new Error("Amount must be positive");
    }
    this.balance += amount;
  }

  withdraw(amount: number): void {
    if (amount > this.balance) {
      throw new Error("Insufficient funds");
    }
    this.balance -= amount;
  }

  canAfford(amount: number): boolean {
    return this.balance >= amount;
  }
}

// Usage
account.withdraw(100);
if (account.canAfford(50)) {
  account.withdraw(50);
}

// ❌ Bad - Ask for data, then tell
class BankAccount {
  private balance: number = 0;

  getBalance(): number {
    return this.balance;
  }

  setBalance(balance: number): void {
    this.balance = balance;
  }
}

// Usage - business logic leaked to client
if (account.getBalance() >= 100) {
  account.setBalance(account.getBalance() - 100);
}
```

#### Domain Logic Stays in Domain Objects

```typescript
// ✅ Good - Order knows how to calculate itself
class Order {
  constructor(private items: OrderItem[]) {}

  calculateTotal(): number {
    return this.items.reduce((sum, item) => sum + item.getSubtotal(), 0);
  }

  applyDiscount(percentage: number): void {
    if (percentage < 0 || percentage > 100) {
      throw new Error("Invalid discount percentage");
    }

    this.items.forEach((item) => item.applyDiscount(percentage));
  }

  isEligibleForFreeShipping(): boolean {
    return this.calculateTotal() > 100;
  }
}

// ❌ Bad - External service doing the work
class OrderService {
  calculateTotal(order: Order): number {
    let total = 0;
    for (const item of order.getItems()) {
      total += item.getPrice() * item.getQuantity();
    }
    return total;
  }

  applyDiscount(order: Order, percentage: number): void {
    const items = order.getItems();
    for (const item of items) {
      const discountedPrice = item.getPrice() * (1 - percentage / 100);
      item.setPrice(discountedPrice);
    }
  }
}
```

## Balancing All Principles

### Integrated Approach

```typescript
// Extract when you have 3+ similar implementations (DRY)
// And when the abstraction is stable and clear (KISS)
// Keep behavior with data (TDA)
// Don't build until needed (YAGNI)

// ✅ Good - Balanced approach
interface Validator<T> {
  validate(data: T): ValidationResult;
}

class EmailValidator implements Validator<string> {
  validate(email: string): ValidationResult {
    // Email validation logic
  }
}

// ✅ Good - Wait for real duplication before abstracting (YAGNI)
// Keep it simple until complexity is justified (KISS)
class UserController {
  async createUser(req: Request): Promise<Response> {
    try {
      const user = await this.userService.create(req.body);
      return { status: 201, data: user };
    } catch (error) {
      return { status: 400, error: error.message };
    }
  }
}

// Only extract error handling pattern after seeing it in 3+ controllers
```

## Key Takeaways

### DRY Guidelines

- Extract after seeing 3+ similar implementations
- Focus on business logic duplication, not coincidental similarity
- Create clear, stable abstractions
- Centralize configuration and constants

### YAGNI Guidelines

- Implement the simplest solution that works
- Add complexity only when requirements demand it
- Refactor when patterns become clear
- Avoid speculative features and abstractions

### KISS Guidelines

- Choose the simplest solution that works
- Avoid unnecessary abstractions and patterns
- Prefer composition over complex inheritance
- Question complexity - is it really needed?

### TDA Guidelines

- Encapsulate behavior with the data it operates on
- Avoid exposing internal state through getters/setters
- Tell objects what to do, don't ask for their data
- Keep domain logic in domain objects

### Balance All Four

- Apply DRY to proven patterns, but keep it simple (KISS)
- Use YAGNI to avoid premature abstraction
- Use TDA to keep behavior close to data
- Refactor when complexity is justified by actual needs
- These principles work together - they're not contradictory
