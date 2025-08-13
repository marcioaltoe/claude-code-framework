# Clean Architecture with Selective CQRS - Project Structure Guide

This project follows the **Clean Architecture** model with **selective CQRS** for complex use cases, **feature-driven modules**, and modern dependency separation. **ALWAYS** avoid the use of shared/ or utils/ folders — code is colocated by responsibility and context.

## Core Principles

1. **Dependency Direction**: Dependencies point inward (Infrastructure → Application → Domain)
2. **Domain Independence**: Domain layer has no external dependencies
3. **Framework Isolation**: Business logic is independent of frameworks
4. **Testability**: Each layer can be tested independently
5. **Separation of Concerns**: Each directory has a single, well-defined purpose
6. **Selective Complexity**: Use CQRS only where complexity demands it

## Clean Architecture Layers

```bash
src/
├── domain/            # Core enterprise logic
├── application/       # Use cases per feature (with selective CQRS)
├── infrastructure/    # Adapters to external systems (DB, cache, messaging)
├── presentation/      # HTTP routes, controllers, middlewares, presenters
└── main.ts            # Application entry point
```

## Complete Project Structure

```bash
├── src/
│   ├── domain/                    # Enterprise Business Rules
│   │   ├── value-objects/         # Immutable, identity-less objects
│   │   ├── events/                # Domain events
│   │   ├── errors/                # Custom domain-level exceptions
│   │   ├── factories/             # Builders for complex aggregates
│   │   ├── services/              # Pure domain logic operations
│   │   └── interfaces/            # Abstract contracts (ports)
│   │       ├── repositories/      # Repository abstractions
│   │       └── services/          # External service contracts
│   │
│   ├── application/               # Application Business Rules (Use Cases)
│   │   └── features/
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
│   ├── infrastructure/            # External Integrations (Adapters/Drivers)
│   │   ├── controllers/           # HTTP API route controllers
│   │   ├── services/              # Implementations of external service interfaces
│   │   ├── repositories/          # Implementation of domain repositories
│   │   ├── orm/                   # ORM configuration (e.g., Drizzle)
│   │   ├── database/              # DB connection and pooling
│   │   ├── queue/                 # BullMQ / Kafka setup
│   │   ├── handlers/              # Queue/job workers or subscribers
│   │   ├── di/                    # Dependency Injection setup (e.g., tsyringe)
│   │   ├── http/                  # Server setup and global middlewares
│   │   └── gateway/               # ERP / external APIs clients
│   │
│   ├── presentation/
│   │   ├── http/                  # HTTP request layer (e.g., Hono)
│   │   ├── middlewares/           # Custom middleware
│   │   ├── validators/            # Request validation (e.g., Zod)
│   │   └── presenters/            # Response formatting
│   │
│   └── main.ts                    # Entry point (DI container + http server bootstrap)
│
├── test/                          # Automated tests
│   ├── unit/                      # Business logic and use cases
│   ├── integration/               # DB, service APIs, etc.
│   ├── e2e/                       # End-to-end route testing
│   ├── fixtures/                  # Mocks and test data
│   └── setup.ts
│
├── docs/
│   ├── features/                       # Product requirement docs
│   │   ├── templates/
│   │   │   ├── discovery-template.md
│   │   │   ├── task-template.md
│   │   │   ├── techspec-template.md
│   │   │   ├── tasks-summary-template.md
│   │   │   └── prd-template.md
│   │   └── [feature-slug]/
│   │       ├── 01-discovery
│   │       │   └── discovery.md
│   │       ├── 02-prd
│   │       │   └── prd.md
│   │       ├── 03-technical
│   │       │   └── techspec.md
│   │       └── 04-implementation
│   │              ├── task-summary.md
│   │              └── tasks/
│   │                  ├── 01_task.md
│   │                  ├── 02_task.md
│   │                  ├── 03_task.md
│   │                  ├── ...
│   │                  └── xx_task.md
│   │
│   ├── api/                       # Generated or manual API docs
│   └── architecture/              # Design and architecture decisions
│
├── scripts/                       # CI/CD, DB seeding, maintenance tooling
│
├── docker/                        # Dockerized environments and compose files
│   ├── config/                    # Config files for docker containers
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── .github/
│   └── workflows/
│
├── .env.example                   # Default envs
├── .gitignore
├── biome.json
├── vitest.config.ts
├── tsconfig.json
├── package.json
└── README.md
```

## CQRS Usage Policy

### Default Approach: Simple Use Cases
Use a unified `use-cases/` folder per feature, containing both read and write logic. This reduces boilerplate and cognitive overhead for straightforward features.

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

**Example - Simple Feature (Notification):**
```bash
src/application/features/notification/
├── use-cases/
│   ├── create-notification.use-case.ts
│   ├── read-notifications.use-case.ts
│   ├── mark-as-read.use-case.ts
│   └── delete-notification.use-case.ts
├── dtos/
├── validators/
└── mappers/
```

### When to Use CQRS: Complex Use Cases
Split into `commands/` (writes/modifications) and `queries/` (read-only) folders when:
- **High complexity** with distinct read/write models
- **Performance requirements** demand separate optimization paths
- **Multiple read models** or projections are needed
- **Event sourcing** or complex domain events are involved
- **Clear domain separation** between reads and writes exists
- **Scalability requirements** suggest independent scaling of reads/writes

**Example - Complex Feature with CQRS (Order):**
```bash
src/application/features/order/
├── commands/
│   ├── create-order.command.ts
│   ├── update-order-status.command.ts
│   ├── cancel-order.command.ts
│   └── apply-discount.command.ts
├── queries/
│   ├── get-order-details.query.ts
│   ├── get-order-history.query.ts
│   └── get-pending-orders.query.ts
├── dtos/
├── mappers/
└── validators/
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

### Test Layer (`/test`)
- **Unit Tests**: Fast, isolated tests for business logic
- **Integration Tests**: Tests with real external dependencies
- **E2E Tests**: Full end-to-end scenario testing
- **Fixtures**: Test data and mocks

## File Naming Conventions

Use **kebab-case** for all file names:
- `user-service.ts`
- `create-order.use-case.ts` (simple feature)
- `create-order.command.ts` (complex feature with CQRS)
- `get-order-details.query.ts` (complex feature with CQRS)
- `payment-repository.ts`

## Module Organization

- One class/interface per file (preferred)
- Group related types in single file only when cohesion is high
- Export from index files for clean imports
- Feature modules are self-contained with all necessary components

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

## Benefits of This Approach

1. **Reduced Complexity**: Simple features remain simple without unnecessary abstraction
2. **Scalability**: Complex features can leverage CQRS benefits when needed
3. **Maintainability**: Clear guidelines reduce decision fatigue
4. **Flexibility**: Teams can evolve from simple to complex as requirements grow
5. **Performance**: Optimize only where necessary, avoiding premature optimization

## Migration Path

Features can naturally evolve from simple to complex:
1. Start with `use-cases/` folder
2. Monitor complexity and performance needs
3. When threshold is reached, refactor to `commands/` and `queries/`
4. Update tests and documentation accordingly

This approach ensures that complexity is introduced only when justified by actual requirements, maintaining a pragmatic balance between simplicity and scalability.