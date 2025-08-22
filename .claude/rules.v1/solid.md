# SOLID Principles

## Single Responsibility Principle (SRP)

**One reason to change per class/module**

```typescript
// ✅ Good - Single responsibility
class UserValidator {
  validate(user: User): ValidationResult {
    // Only validation logic
  }
}

class UserRepository {
  save(user: User): Promise<void> {
    // Only data persistence
  }
}

// ❌ Bad - Multiple responsibilities
class UserManager {
  validate(user: User): boolean {
    /* validation */
  }
  save(user: User): Promise<void> {
    /* persistence */
  }
  sendEmail(user: User): Promise<void> {
    /* notification */
  }
}
```

## Open/Closed Principle (OCP)

**Open for extension, closed for modification**

```typescript
// ✅ Good - Extensible via interface
interface PaymentProcessor {
  process(amount: number): Promise<PaymentResult>;
}

class StripeProcessor implements PaymentProcessor {
  process(amount: number): Promise<PaymentResult> {
    // Stripe implementation
  }
}

class PayPalProcessor implements PaymentProcessor {
  process(amount: number): Promise<PaymentResult> {
    // PayPal implementation
  }
}

// ❌ Bad - Requires modification to extend
class PaymentService {
  process(amount: number, type: "stripe" | "paypal"): Promise<PaymentResult> {
    if (type === "stripe") {
      // Stripe logic
    } else if (type === "paypal") {
      // PayPal logic
    }
    // Adding new payment method requires modifying this class
  }
}
```

## Liskov Substitution Principle (LSP)

**Subtypes must be substitutable for base types**

```typescript
// ✅ Good - Subtypes work correctly
interface Bird {
  move(): void;
}

class Sparrow implements Bird {
  move(): void {
    this.fly();
  }

  private fly(): void {
    console.log("Flying");
  }
}

class Penguin implements Bird {
  move(): void {
    this.swim();
  }

  private swim(): void {
    console.log("Swimming");
  }
}

// ❌ Bad - Penguin can't fly, breaks substitution
interface FlyingBird {
  fly(): void;
}

class Penguin implements FlyingBird {
  fly(): void {
    throw new Error("Penguins can't fly!"); // Breaks LSP
  }
}
```

## Interface Segregation Principle (ISP)

**Small, focused interfaces**

```typescript
// ✅ Good - Focused interfaces
interface Readable {
  read(): string;
}

interface Writable {
  write(data: string): void;
}

interface Executable {
  execute(): void;
}

class TextFile implements Readable, Writable {
  read(): string {
    /* implementation */
  }
  write(data: string): void {
    /* implementation */
  }
}

class Script implements Readable, Executable {
  read(): string {
    /* implementation */
  }
  execute(): void {
    /* implementation */
  }
}

// ❌ Bad - Fat interface forces unnecessary implementations
interface FileOperations {
  read(): string;
  write(data: string): void;
  execute(): void;
}

class TextFile implements FileOperations {
  read(): string {
    /* implementation */
  }
  write(data: string): void {
    /* implementation */
  }
  execute(): void {
    throw new Error("Text files can't be executed"); // Forced to implement
  }
}
```

## Dependency Inversion Principle (DIP)

**Depend on abstractions, not concretions**

```typescript
// ✅ Good - Depends on abstraction
interface Logger {
  log(message: string): void;
}

class UserService {
  constructor(private logger: Logger) {}

  createUser(userData: UserData): User {
    // Business logic
    this.logger.log("User created");
    return user;
  }
}

// Implementations
class ConsoleLogger implements Logger {
  log(message: string): void {
    console.log(message);
  }
}

class FileLogger implements Logger {
  log(message: string): void {
    // Write to file
  }
}

// ❌ Bad - Depends on concrete implementation
class UserService {
  private logger = new ConsoleLogger(); // Hard dependency

  createUser(userData: UserData): User {
    // Business logic
    this.logger.log("User created");
    return user;
  }
}
```

## Practical Application

### Constructor Injection Pattern

```typescript
// Always use constructor injection for dependencies
class OrderService {
  constructor(
    private readonly orderRepository: OrderRepository,
    private readonly paymentService: PaymentService,
    private readonly logger: Logger,
  ) {}
}
```

### Factory Pattern for OCP

```typescript
interface NotificationSender {
  send(message: string): Promise<void>;
}

class NotificationFactory {
  static create(type: "email" | "sms" | "push"): NotificationSender {
    switch (type) {
      case "email":
        return new EmailSender();
      case "sms":
        return new SmsSender();
      case "push":
        return new PushSender();
      default:
        throw new Error(`Unknown notification type: ${type}`);
    }
  }
}
```

### Interface Composition

```typescript
// Compose larger interfaces from smaller ones
interface DatabaseOperations extends Readable, Writable, Deletable {
  // Inherits read(), write(), delete()
}
```

## Benefits

- **Maintainability** - Easier to modify and extend
- **Testability** - Easy to mock dependencies
- **Flexibility** - Swap implementations without changing code
- **Reusability** - Components can be reused in different contexts
- **Reduced Coupling** - Components depend on abstractions, not implementations
