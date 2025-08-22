# Clean Architecture Guide

## Core Principles

### Dependency Rule

Dependencies always point inward: **Infrastructure → Application → Domain**

1. **Dependency Direction**: Dependencies point inward (Infrastructure → Application → Domain)
2. **Domain Independence**: Domain layer has no external dependencies
3. **Framework Isolation**: Business logic is independent of frameworks
4. **Testability**: Each layer can be tested independently
5. **Separation of Concerns**: Each directory has a single, well-defined purpose
6. **Selective Complexity**: Use CQRS only where complexity demands it

### Architecture Layers Overview

```bash
src/
├── domain/            # Core enterprise logic (singular folders)
├── application/       # Use cases organized by feature/module
├── infrastructure/    # Adapters to external systems (DB, cache, messaging)
├── presentation/      # HTTP routes, controllers, middlewares, presenters
└── main.ts            # Application entry point
```

**Important Conventions:**

- Use **singular** names for domain concept folders (entity, aggregate, value-object)
- Use **plural** only for collections of mixed types (building-blocks, types)
- Organize application layer by **feature/module**, not by pattern
- Keep repository **interfaces** in domain layer, **implementations** in infrastructure

## Project Structure Reference

**Complete project structure**: See `./rules/folder-structure.md` for the full directory layout
including src/, test/, docs/, docker/, scripts/, and configuration files.

## Dependency Flow Examples

```typescript
// ✅ Good: Dependencies flow inward (Infrastructure → Application → Domain)

// Domain Layer - Core business logic
// src/domain/entities/Task.ts
export class Task {
  constructor(
    public readonly id: ID,
    public readonly title: string,
    public readonly status: TaskStatus,
  ) {}

  markAsCompleted(): void {
    if (this.status === TaskStatus.COMPLETED) {
      throw new TaskAlreadyCompletedError(this.id);
    }
    // Domain logic here
  }
}

// Domain interfaces (ports)
// src/domain/interfaces/repositories/TaskRepository.ts
export interface TaskRepository {
  save(task: Task): Promise<void>;
  findById(id: ID): Promise<Task | null>;
}

// Application Layer - Use cases
// src/application/features/task/use-case/complete-task.use-case.ts
import { Task } from "@/domain/entity";
import { TaskRepository } from "@/domain/repository";

export class CompleteTaskUseCase {
  constructor(private readonly taskRepository: TaskRepository) {}

  async execute(taskId: ID): Promise<void> {
    const task = await this.taskRepository.findById(taskId);
    if (!task) {
      throw new TaskNotFoundError(taskId);
    }

    task.markAsCompleted();
    await this.taskRepository.save(task);
  }
}

// Infrastructure Layer - Adapters
// src/infrastructure/repository/postgres-task-repository.ts
import { TaskRepository } from "@/domain/repository";
import { Task } from "@/domain/entity";

export class PostgresTaskRepository implements TaskRepository {
  constructor(private readonly db: DatabaseConnection) {}

  async save(task: Task): Promise<void> {
    // Implementation details
  }

  async findById(id: ID): Promise<Task | null> {
    // Implementation details
  }
}

// Presentation Layer - Controllers
// src/infrastructure/controller/task-controller.ts
import { CompleteTaskUseCase } from "@/application/features/task/use-case";

export class TaskController {
  constructor(private readonly completeTaskUseCase: CompleteTaskUseCase) {}

  async completeTask(request: Request): Promise<Response> {
    const { taskId } = request.params;
    await this.completeTaskUseCase.execute(taskId);
    return { success: true };
  }
}
```

## Selective CQRS Implementation

### Core Principle: Complexity-Driven Architecture

Use **unified use cases** by default, apply **CQRS** only when complexity demands it.

### Default Approach: Simple Features (Unified Use Cases)

Use a unified `use-cases/` folder per feature, containing both read and write logic. This reduces
boilerplate and cognitive overhead for straightforward features.

```typescript
// Simple feature structure
src/application/features/user/
├── use-cases/
│   ├── CreateUser.ts
│   ├── GetUserDetails.ts
│   ├── UpdateUser.ts
│   └── DeleteUser.ts
├── dtos/
├── validators/
└── mappers/

// Example implementation
export class CreateUserUseCase {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly emailService: EmailService
  ) {}

  async execute(dto: CreateUserDto): Promise<UserResponseDto> {
    const user = UserMapper.toDomain(dto);
    await this.userRepository.save(user);
    await this.emailService.sendWelcomeEmail(user.email);
    return UserMapper.toResponseDto(user);
  }
}
```

**Example - Simple Feature (Payment):**

```bash
src/application/features/payment/
├── use-cases/
│   ├── process-payment.use-case.ts
│   ├── get-payment-details.use-case.ts
│   └── refund-payment.use-case.ts
├── dtos/
├── validators/
└── mappers/
```

### Complex Features: CQRS Implementation

Split into `commands/` (writes/modifications) and `queries/` (read-only) folders when:

**When to Use CQRS:**

- **High complexity** with distinct read/write models
- **Performance requirements** demand separate optimization paths
- **Multiple read models** or projections are needed
- **Event sourcing** or complex domain events are involved
- **Clear domain separation** between reads and writes exists
- **Scalability requirements** suggest independent scaling of reads/writes

```typescript
// Complex feature with CQRS structure
src/application/features/order/
├── commands/
│   ├── CreateOrder.ts
│   ├── UpdateOrderStatus.ts
│   ├── CancelOrder.ts
│   └── ApplyDiscount.ts
├── queries/
│   ├── GetOrderDetails.ts
│   ├── GetOrderHistory.ts
│   ├── GetPendingOrders.ts
│   └── GetOrderAnalytics.ts
├── dtos/
├── validators/
└── mappers/

// Command example (write operations)
export class CreateOrderCommand {
  constructor(
    private readonly orderRepository: OrderRepository,
    private readonly inventoryService: InventoryService,
    private readonly eventBus: EventBus
  ) {}

  async execute(dto: CreateOrderDto): Promise<OrderResponseDto> {
    // Complex business logic
    await this.inventoryService.reserveItems(dto.items);
    const order = OrderFactory.create(dto);
    await this.orderRepository.save(order);

    // Publish domain events
    await this.eventBus.publish(new OrderCreatedEvent(order));

    return OrderMapper.toResponseDto(order);
  }
}

// Query example (read operations)
export class GetOrderAnalyticsQuery {
  constructor(
    private readonly orderReadRepository: OrderReadRepository,
    private readonly analyticsService: AnalyticsService
  ) {}

  async execute(filters: OrderAnalyticsFilters): Promise<OrderAnalyticsDto> {
    // Optimized read operations
    const rawData = await this.orderReadRepository.getAnalyticsData(filters);
    return this.analyticsService.processAnalytics(rawData);
  }
}
```

**Example - Complex Feature with CQRS (Invoice):**

```bash
src/application/features/invoice/
├── commands/
│   ├── generate-invoice.command.ts
│   ├── pay-invoice.command.ts
│   └── void-invoice.command.ts
├── queries/
│   ├── get-invoice-history.query.ts
│   ├── get-unpaid-invoices.query.ts
│   └── get-invoice-analytics.query.ts
├── dtos/
├── mappers/
└── validators/
```

### Migration Path: Simple to Complex

Features can evolve naturally:

1. **Start Simple**: Begin with `use-cases/` folder
2. **Monitor Complexity**: Track performance and maintainability needs
3. **When threshold is reached**, refactor to `commands/` and `queries/`
4. **Update tests and documentation** accordingly

```typescript
// Before: Simple use case
export class OrderService {
  async createOrder(dto: CreateOrderDto): Promise<OrderDto> {
    // Simple implementation
  }

  async getOrderDetails(id: ID): Promise<OrderDto> {
    // Simple read
  }
}

// After: Evolved to CQRS due to complexity
export class CreateOrderCommand {
  // Complex write operations with events, validations, etc.
}

export class GetOrderDetailsQuery {
  // Optimized read with projections
}
```

## Domain-Driven Design Integration

### Entities vs Value Objects

```typescript
// ✅ Entity - Has identity, mutable
export class User {
  constructor(
    private readonly id: UserId,
    private email: Email,
    private name: string,
  ) {}

  changeEmail(newEmail: Email): void {
    // Business rules for email change
    this.email = newEmail;
  }

  equals(other: User): boolean {
    return this.id.equals(other.id);
  }
}

// ✅ Value Object - No identity, immutable
export class Email {
  constructor(private readonly value: string) {
    if (!this.isValid(value)) {
      throw new InvalidEmailError(value);
    }
  }

  toString(): string {
    return this.value;
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }

  private isValid(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}
```

### Domain Services

```typescript
// ✅ Domain Service - Pure domain logic that doesn't belong to any entity
export class PricingService {
  calculateOrderTotal(items: OrderItem[], customer: Customer): Money {
    const subtotal = items.reduce((sum, item) => sum.add(item.getPrice()), Money.zero());
    const discount = this.calculateDiscount(subtotal, customer);
    const tax = this.calculateTax(subtotal.subtract(discount));

    return subtotal.subtract(discount).add(tax);
  }

  private calculateDiscount(subtotal: Money, customer: Customer): Money {
    if (customer.isPremium()) {
      return subtotal.multiply(0.1); // 10% discount
    }
    return Money.zero();
  }

  private calculateTax(amount: Money): Money {
    return subtotal.multiply(0.08); // 8% tax
  }
}
```

### Domain Events

```typescript
// ✅ Domain Event
export class OrderCreatedEvent {
  constructor(
    public readonly orderId: OrderId,
    public readonly customerId: CustomerId,
    public readonly total: Money,
    public readonly occurredAt: Date = new Date(),
  ) {}
}

// ✅ Domain Event Publisher
export interface EventBus {
  publish(event: DomainEvent): Promise<void>;
}

// Usage in domain
export class Order {
  private events: DomainEvent[] = [];

  static create(customerId: CustomerId, items: OrderItem[]): Order {
    const order = new Order(OrderId.generate(), customerId, items);
    order.addEvent(new OrderCreatedEvent(order.id, customerId, order.total));
    return order;
  }

  private addEvent(event: DomainEvent): void {
    this.events.push(event);
  }

  getUncommittedEvents(): DomainEvent[] {
    return [...this.events];
  }

  markEventsAsCommitted(): void {
    this.events = [];
  }
}
```

## Layer Responsibilities

### Domain Layer (`/src/domain`)

- Pure business **rules** and **logic**
- **Knows nothing** about the **outside world**
- Contains:
  - **Entities**: Core business objects with identity
  - **Value Objects**: Immutable objects without identity
  - **Domain Services**: Business logic that doesn't fit in entities
  - **Domain Events**: Important business events
  - **Domain Errors**: Domain-specific errors
  - **Factories**: Create complex domain objects and aggregates
  - **Interfaces**: Ports for repositories and external services

### Application Layer (`/src/application`)

- Application-specific **orchestration**, not framework-bound
- Organized by feature/module (vertical slicing)
- Contains per-feature folders with:
  - **Use Cases** (simple features): Combined read/write operations
  - **Commands** (complex features): Write/mutation operations
  - **Queries** (complex features): Read-only operations
  - **DTOs**: Data Transfer Objects for input/output
  - **Validators**: Business rule validation
  - **Mappers**: DTO ⇄ Domain model translation

### Infrastructure Layer (`/src/infrastructure`)

- **Controllers**: Handle HTTP requests/responses
- **Repositories**: Data persistence implementations
- **Services**: Implementations of external service interfaces
- **Database**: Database connection management
- **ORM**: Object-relational mapping configuration
- **Queue**: Message broker implementations
- **Gateway**: External API integrations
- **Handlers**: Process queue messages and events
- **DI**: Wire up dependencies and configure IoC container
- **HTTP**: Server setup and middleware

### Presentation Layer (`/src/presentation`)

- **HTTP**: Request/response handling (e.g., Hono, Express)
- **Middlewares**: Cross-cutting concerns (auth, logging, etc.)
- **Validators**: Request validation (e.g., Zod schemas)
- **Presenters**: Response formatting and transformation

## File Naming Conventions

Use **kebab-case** for all file names with appropriate suffixes:

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

- `postgres-user-repository.ts` - Repository implementations
- `redis-cache.service.ts` - Services
- `jwt-token.service.ts` - External service adapters

**Base/Abstract Classes:**

- `aggregate-root.base.ts`
- `entity.base.ts`
- `value-object.base.ts`
- `use-case.base.ts`

## Decision Guidelines

### When to Keep It Simple (use-cases/)

✅ CRUD operations without complex business logic  
✅ Features with straightforward read/write patterns  
✅ Limited performance requirements  
✅ Single, unified data model  
✅ No need for independent scaling

### When to Apply CQRS (commands/ + queries/)

✅ Complex domain logic with distinct read/write models  
✅ High-performance requirements with different optimization needs  
✅ Multiple read projections or reporting needs  
✅ Event-driven architecture or event sourcing  
✅ Need for independent scaling of reads and writes  
✅ Complex aggregations or analytics separate from transactional model

## Anti-Patterns to Avoid

### Anemic Domain Model

```typescript
// ❌ Bad: Anemic domain model (just data containers)
export class User {
  public id: string;
  public email: string;
  public name: string;
  public isActive: boolean;
}

export class UserService {
  validateEmail(user: User): boolean {
    // Business logic outside the domain model
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(user.email);
  }

  activateUser(user: User): void {
    user.isActive = true;
  }
}

// ✅ Good: Rich domain model
export class User {
  constructor(
    private readonly id: UserId,
    private email: Email,
    private readonly name: string,
    private isActive: boolean = false,
  ) {}

  activate(): void {
    if (this.isActive) {
      throw new UserAlreadyActiveError(this.id);
    }
    this.isActive = true;
  }

  changeEmail(newEmail: Email): void {
    if (this.email.equals(newEmail)) {
      return; // No change needed
    }
    this.email = newEmail;
  }

  isActiveUser(): boolean {
    return this.isActive;
  }
}
```

### God Objects

```typescript
// ❌ Bad: God object with too many responsibilities
class OrderService {
  // Too many dependencies and responsibilities
  constructor(
    private db: Database,
    private cache: Cache,
    private logger: Logger,
    private emailService: EmailService,
    private paymentService: PaymentService,
    private inventoryService: InventoryService,
    private shippingService: ShippingService,
    private auditService: AuditService,
  ) {}

  async processOrder(order: Order): Promise<void> {
    // Handles payment, inventory, shipping, email, logging, auditing...
  }
}

// ✅ Good: Single responsibility with orchestration
class ProcessOrderUseCase {
  constructor(
    private readonly orderRepository: OrderRepository,
    private readonly paymentService: PaymentService,
    private readonly inventoryService: InventoryService,
    private readonly eventBus: EventBus,
  ) {}

  async execute(orderId: OrderId): Promise<void> {
    const order = await this.orderRepository.findById(orderId);

    await this.paymentService.processPayment(order.getPayment());
    await this.inventoryService.reserveItems(order.getItems());

    order.markAsProcessed();
    await this.orderRepository.save(order);

    await this.eventBus.publish(new OrderProcessedEvent(order));
  }
}
```

### Tight Coupling

```typescript
// ❌ Bad: Direct dependency on concrete types
class UserService {
  private db = new PostgreSQLDatabase(); // Should be injected interface
  private emailer = new SMTPEmailService(); // Should be injected interface

  async createUser(userData: CreateUserData): Promise<void> {
    // Implementation tightly coupled to specific implementations
  }
}

// ✅ Good: Depend on abstractions
class CreateUserUseCase {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly emailService: EmailService,
  ) {}

  async execute(userData: CreateUserData): Promise<void> {
    // Implementation depends on abstractions
  }
}
```

## Quality Metrics

### Architecture Health Indicators

- **Dependency Direction**: Always inward toward domain
- **Interface Usage**: High ratio of interfaces to concrete types in domain
- **Package Cohesion**: Related functionality grouped together
- **Separation of Concerns**: Clear boundaries between layers
- **Domain Logic Location**: Business rules in domain entities/services, not use cases

### Code Quality Metrics

- **Cyclomatic Complexity**: Keep methods simple
- **Coupling**: Minimize dependencies between features
- **Cohesion**: High cohesion within features
- **Test Coverage**: High coverage on domain logic

## Benefits of This Approach

1. **Reduced Complexity**: Simple features remain simple without unnecessary abstraction
2. **Scalability**: Complex features can leverage CQRS benefits when needed
3. **Maintainability**: Clear guidelines reduce decision fatigue
4. **Flexibility**: Teams can evolve from simple to complex as requirements grow
5. **Performance**: Optimize only where necessary, avoiding premature optimization

## Best Practices Summary

1. **Start Simple**: Use unified use cases, evolve to CQRS when needed
2. **Rich Domain Model**: Put business logic in domain entities
3. **Clear Boundaries**: Respect layer responsibilities
4. **Dependency Inversion**: Depend on abstractions, not concretions
5. **Domain Events**: Use events for loose coupling between bounded contexts
6. **Value Objects**: Use for concepts without identity
7. **Single Responsibility**: Each class/module should have one reason to change
8. **Test the Domain**: Focus testing efforts on domain logic
9. **Feature-Driven Organization**: Organize by business features, not technical layers
10. **Selective Complexity**: Apply CQRS only when complexity demands it
