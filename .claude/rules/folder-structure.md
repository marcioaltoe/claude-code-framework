# Folder Structure & Organization

## Complete Project Structure

```
├── src/
│   ├── domain/                    # Core enterprise logic
│   │   ├── entities/              # Business objects with identity
│   │   ├── value-objects/         # Immutable, identity-less objects
│   │   ├── events/                # Domain events
│   │   ├── errors/                # Custom domain-level exceptions
│   │   ├── factories/             # Builders for complex aggregates
│   │   ├── services/              # Pure domain logic operations
│   │   └── interfaces/            # Abstract contracts (ports)
│   │       ├── repositories/      # Repository abstractions
│   │       └── services/          # External service contracts
│   │
│   ├── application/               # Application business rules (use cases)
│   │   └── features/              # Feature-driven modules
│   │       ├── user/              # Simple feature example
│   │       │   ├── use-cases/     # Combined read/write use cases
│   │       │   ├── dtos/          # Input/output interface models
│   │       │   ├── validators/    # Input validation logic
│   │       │   └── mappers/       # DTO ⇄ Domain translation
│   │       │
│   │       ├── notification/      # Another simple feature
│   │       │   ├── use-cases/
│   │       │   ├── dtos/
│   │       │   ├── validators/
│   │       │   └── mappers/
│   │       │
│   │       └── order/             # Complex feature with CQRS
│   │           ├── commands/      # Mutation use case handlers
│   │           ├── queries/       # Read-only logic
│   │           ├── dtos/
│   │           ├── validators/
│   │           └── mappers/
│   │
│   ├── infrastructure/            # External integrations (adapters/drivers)
│   │   ├── controllers/           # HTTP API route controllers
│   │   ├── services/              # Implementations of external service interfaces
│   │   ├── repositories/          # Implementation of domain repositories
│   │   ├── orm/                   # ORM configuration (e.g., Drizzle)
│   │   ├── database/              # DB connection and pooling
│   │   ├── queue/                 # Message broker setup (BullMQ/Kafka)
│   │   ├── handlers/              # Queue/job workers or subscribers
│   │   ├── di/                    # Dependency Injection setup
│   │   ├── http/                  # Server setup and global middlewares
│   │   └── gateway/               # External APIs clients (ERP/third-party)
│   │
│   ├── presentation/              # Request/response layer
│   │   ├── http/                  # HTTP request handling (e.g., Hono)
│   │   ├── middlewares/           # Custom middleware
│   │   ├── validators/            # Request validation (e.g., Zod)
│   │   └── presenters/            # Response formatting
│   │
│   └── main.ts                    # Application entry point (DI + server bootstrap)
│
├── test/                          # Automated tests
│   ├── unit/                      # Business logic and use cases
│   ├── integration/               # DB, service APIs, etc.
│   ├── e2e/                       # End-to-end route testing
│   ├── fixtures/                  # Mocks and test data
│   └── setup.ts
│
├── docs/
│   ├── features/                  # Product requirement docs
│   │   ├── templates/
│   │   │   ├── discovery-template.md
│   │   │   ├── task-template.md
│   │   │   ├── techspec-template.md
│   │   │   ├── tasks-summary-template.md
│   │   │   └── prd-template.md
│   │   └── [feature-slug]/        # Feature documentation workflow
│   │       ├── 01-discovery
│   │       │   └── discovery.md
│   │       ├── 02-prd
│   │       │   └── prd.md
│   │       ├── 03-technical
│   │       │   └── techspec.md
│   │       └── 04-implementation
│   │           ├── task-summary.md
│   │           └── tasks/
│   │               ├── 01_task.md
│   │               ├── 02_task.md
│   │               ├── 03_task.md
│   │               ├── ...
│   │               └── xx_task.md
│   │
│   ├── api/                       # Generated or manual API docs
│   │   ├── endpoints/
│   │   └── schemas/
│   └── architecture/              # Design and architecture decisions
│       ├── decisions/
│       └── diagrams/
│
├── scripts/                       # CI/CD, DB seeding, maintenance tooling
│   ├── build.sh
│   ├── deploy.sh
│   ├── seed-db.ts
│   └── migrate.ts
│
├── docker/                        # Dockerized environments and compose files
│   ├── config/                    # Config files for docker containers
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── .github/
│   └── workflows/                 # GitHub Actions CI/CD
│       ├── ci.yml
│       ├── deploy.yml
│       └── tests.yml
│
├── config/                        # Application configuration
│   ├── database.ts
│   ├── server.ts
│   ├── queue.ts
│   ├── email.ts
│   ├── environments/
│   │   ├── development.ts
│   │   ├── production.ts
│   │   └── test.ts
│   ├── base.ts
│   └── index.ts                   # Barrel export
│
├── public/                        # Static assets
│   ├── images/
│   ├── styles/
│   └── scripts/
│
├── assets/                        # Application assets
│   ├── fonts/
│   ├── icons/
│   └── templates/
│       ├── email/
│       └── pdf/
│
├── .env.example                   # Environment variables template
├── .gitignore
├── biome.json                     # Biome configuration (linting/formatting)
├── vitest.config.ts               # Vitest test configuration
├── tsconfig.json                  # TypeScript configuration
├── package.json                   # Dependencies and scripts
└── README.md                      # Project documentation
```

## Layer Responsibilities

### Domain Layer (`src/domain/`)

**Core enterprise business rules**

- **Entities**: Business objects with identity
- **Value Objects**: Immutable objects without identity
- **Domain Services**: Pure domain logic operations
- **Domain Events**: Important business events
- **Domain Errors**: Domain-specific exceptions
- **Factories**: Create complex domain objects and aggregates
- **Interfaces**: Ports for repositories and external services

```typescript
// Example domain structure
src/domain/
├── entities/
│   ├── User.ts
│   ├── Order.ts
│   └── Product.ts
├── value-objects/
│   ├── Email.ts
│   ├── Money.ts
│   └── Address.ts
├── events/
│   ├── UserCreatedEvent.ts
│   └── OrderCompletedEvent.ts
├── errors/
│   ├── UserNotFoundError.ts
│   └── InsufficientInventoryError.ts
├── factories/
│   ├── UserFactory.ts
│   └── OrderFactory.ts
├── services/
│   ├── PricingService.ts
│   └── InventoryService.ts
└── interfaces/
    ├── repositories/
    │   ├── UserRepository.ts
    │   └── OrderRepository.ts
    └── services/
        ├── EmailService.ts
        └── PaymentService.ts
```

### Application Layer (`src/application/features/`)

**Application business rules organized by feature**

#### Simple Features

Use `use-cases/` folder for combined read/write operations

```typescript
src/application/features/user/
├── use-cases/
│   ├── CreateUser.ts
│   ├── GetUserDetails.ts
│   ├── UpdateUser.ts
│   └── DeleteUser.ts
├── dtos/
│   ├── CreateUserDto.ts
│   ├── UserResponseDto.ts
│   └── UpdateUserDto.ts
├── validators/
│   └── UserValidator.ts
└── mappers/
    └── UserMapper.ts
```

#### Complex Features

Use `commands/` (writes) and `queries/` (reads) with CQRS

```typescript
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
│   ├── CreateOrderDto.ts
│   ├── OrderResponseDto.ts
│   └── OrderAnalyticsDto.ts
├── validators/
│   └── OrderValidator.ts
└── mappers/
    └── OrderMapper.ts
```

### Infrastructure Layer (`src/infrastructure/`)

**External integrations (adapters/drivers)**

```typescript
src/infrastructure/
├── controllers/
│   ├── UserController.ts
│   └── OrderController.ts
├── services/
│   ├── EmailServiceImpl.ts
│   └── PaymentServiceImpl.ts
├── repositories/
│   ├── PostgreSQLUserRepository.ts
│   └── PostgreSQLOrderRepository.ts
├── orm/
│   ├── schema.ts
│   └── migrations/
├── database/
│   ├── connection.ts
│   └── pool.ts
├── queue/
│   ├── setup.ts
│   └── producers/
├── handlers/
│   ├── EmailHandler.ts
│   └── OrderEventHandler.ts
├── di/
│   ├── container.ts
│   └── bindings.ts
├── http/
│   ├── server.ts
│   └── routes.ts
└── gateway/
    ├── PaymentGateway.ts
    └── ShippingGateway.ts
```

### Presentation Layer (`src/presentation/`)

**Request/response handling**

```typescript
src/presentation/
├── http/
│   ├── routes/
│   └── middleware/
├── middlewares/
│   ├── AuthMiddleware.ts
│   ├── ValidationMiddleware.ts
│   └── ErrorHandlerMiddleware.ts
├── validators/
│   ├── RequestValidator.ts
│   └── SchemaValidator.ts
└── presenters/
    ├── UserPresenter.ts
    └── OrderPresenter.ts
```

## Package Organization Principles

### Feature-Driven Organization

- Each feature in `src/application/features/` has clear boundaries
- Domain entities and interfaces in `src/domain/`
- Infrastructure adapters in `src/infrastructure/`
- Presentation layer in `src/presentation/`

### Anti-Patterns to Avoid

- **AVOID** shared/, utils/, or common/ folders
- **AVOID** organizing by technical concerns (controllers/, services/, models/)
- **AVOID** circular dependencies between features

### Colocate by Context

```typescript
// ✅ Good: Related functionality grouped together
src/application/features/user/
├── use-cases/
├── dtos/
├── validators/
└── mappers/

// ❌ Bad: Organized by technical layer
src/
├── controllers/
├── services/
├── dtos/
└── validators/
```

## Barrel Exports

Use `index.ts` files for clean imports:

```typescript
// src/domain/entities/index.ts
export { User } from "./User";
export { Order } from "./Order";
export { Product } from "./Product";

// src/application/features/user/index.ts
export { CreateUserUseCase } from "./use-cases/CreateUser";
export { GetUserDetailsUseCase } from "./use-cases/GetUserDetails";
export { CreateUserDto } from "./dtos/CreateUserDto";
export { UserResponseDto } from "./dtos/UserResponseDto";

// Usage
import { User, Order } from "@/domain/entities";
import { CreateUserUseCase, CreateUserDto } from "@/application/features/user";
```

## Dependency Direction

Dependencies always point inward: **Infrastructure → Application → Domain**

```typescript
// ✅ Good: Dependencies flow inward
// Domain Layer - No external dependencies
export class User {
  // Pure domain logic
}

// Application Layer - Depends only on Domain
import { User } from "../../domain/entities/User";
import { UserRepository } from "../../domain/interfaces/repositories/UserRepository";

export class CreateUserUseCase {
  constructor(private readonly userRepository: UserRepository) {}
}

// Infrastructure Layer - Depends on Domain and Application
import { UserRepository } from "../../domain/interfaces/repositories/UserRepository";
import { User } from "../../domain/entities/User";

export class PostgreSQLUserRepository implements UserRepository {
  // Implementation
}
```

## When to Use CQRS Structure

### Default: Simple Features (Unified Use Cases)

Use `use-cases/` folder for straightforward features:

- Basic CRUD operations
- Simple business logic
- No complex read projections needed
- Performance is adequate with unified approach

### Complex Features: CQRS Implementation

Use `commands/` and `queries/` when:

- High complexity with distinct read/write models
- Performance requirements demand separate optimization
- Multiple read projections needed
- Event sourcing or complex domain events
- Independent scaling requirements for reads/writes

### Migration Path

Features can evolve naturally:

1. **Start Simple**: Begin with `use-cases/` folder
2. **Monitor Complexity**: Track performance and maintainability
3. **Refactor When Needed**: Split into `commands/` and `queries/`
4. **Update Dependencies**: Adjust tests and documentation

## Test Organization

Mirror the source structure in tests:

```typescript
test/
├── unit/
│   ├── domain/
│   │   ├── entities/
│   │   └── services/
│   ├── application/
│   │   └── features/
│   │       ├── user/
│   │       └── order/
│   └── infrastructure/
│       ├── repositories/
│       └── services/
├── integration/
│   ├── api/
│   └── database/
└── e2e/
    ├── user-flows/
    └── order-flows/
```

## Best Practices Summary

1. **Feature-Driven**: Organize by business features, not technical layers
2. **Clean Dependencies**: Always point inward toward domain
3. **Selective CQRS**: Start simple, evolve to CQRS when complexity demands it
4. **Clear Boundaries**: Each layer has distinct responsibilities
5. **Barrel Exports**: Use index.ts for clean import statements
6. **No Shared Folders**: Colocate related functionality
7. **Mirror in Tests**: Test structure should mirror source structure
8. **Environment Separation**: Clear separation of configuration by environment
