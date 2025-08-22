# Folder Structure & Organization

## Complete Project Structure

```
├── src/
│   ├── domain/                    # Core enterprise logic (singular folders)
│   │   ├── aggregate/             # Aggregate roots
│   │   ├── entity/                # Business objects with identity
│   │   ├── value-object/          # Immutable, identity-less objects
│   │   ├── event/                 # Domain events
│   │   ├── error/                 # Custom domain-level exceptions
│   │   ├── factory/               # Builders for complex aggregates
│   │   ├── service/               # Pure domain logic operations
│   │   ├── specification/         # Business rule specifications
│   │   ├── repository/            # Repository interfaces
│   │   └── building-blocks/       # DDD base classes and patterns
│   │
│   ├── application/               # Application business rules (use cases)
│   │   ├── core/                  # Base classes for application layer
│   │   │   ├── use-case.base.ts   # Base use case class
│   │   │   ├── repository.ts      # Repository interfaces
│   │   │   └── mapper.base.ts     # Base mapper class
│   │   └── features/              # Feature-driven modules
│   │       ├── auth/              # Authentication feature
│   │       │   ├── use-case/      # Combined read/write use cases
│   │       │   ├── dto/            # Input/output interface models
│   │       │   ├── validator/     # Input validation logic
│   │       │   └── mapper/        # DTO ⇄ Domain translation
│   │       │
│   │       ├── user/              # User management feature
│   │       │   ├── use-case/
│   │       │   ├── dto/
│   │       │   ├── validator/
│   │       │   └── mapper/
│   │       │
│   │       └── organization/      # Complex feature with CQRS
│   │           ├── command/       # Mutation use case handlers
│   │           ├── query/         # Read-only logic
│   │           ├── dto/
│   │           ├── validator/
│   │           └── mapper/
│   │
│   ├── infrastructure/            # External integrations (adapters/drivers)
│   │   ├── controller/            # HTTP API route controllers
│   │   ├── service/               # Implementations of external service interfaces
│   │   ├── repository/            # Implementation of domain repositories
│   │   ├── persistence/           # ORM and database configuration
│   │   │   ├── drizzle/           # Drizzle ORM setup
│   │   │   ├── migration/         # Database migrations
│   │   │   └── seed/              # Database seeders
│   │   ├── cache/                 # Redis and caching layer
│   │   ├── queue/                 # Message broker setup (BullMQ/Kafka)
│   │   ├── handler/               # Queue/job workers or subscribers
│   │   ├── security/              # Security utilities and sanitizers
│   │   ├── di/                    # Dependency Injection setup
│   │   ├── http/                  # Server setup and global middlewares
│   │   └── gateway/               # External APIs clients (ERP/third-party)
│   │
│   ├── presentation/              # Request/response layer
│   │   ├── http/                  # HTTP request handling (e.g., Hono)
│   │   ├── middleware/            # Custom middleware
│   │   ├── validator/             # Request validation (e.g., TypeBox)
│   │   └── presenter/             # Response formatting
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
// Example domain structure with singular folders and proper suffixes
src/domain/
├── aggregate/
│   ├── user-identity.aggregate.ts
│   └── organization-membership.aggregate.ts
├── entity/
│   ├── company.entity.ts
│   └── api-key.entity.ts
├── value-object/
│   ├── email.value-object.ts
│   ├── password.value-object.ts
│   ├── cnpj.value-object.ts
│   └── address.value-object.ts
├── event/
│   ├── user-created.event.ts
│   └── organization-created.event.ts
├── error/
│   ├── user-not-found.error.ts
│   └── invalid-credentials.error.ts
├── factory/
│   ├── user-factory.ts
│   └── organization-factory.ts
├── service/
│   ├── password-hasher.service.ts
│   └── token-generator.service.ts
├── specification/
│   ├── user-can-login.specification.ts
│   └── organization-has-capacity.specification.ts
├── repository/
│   ├── user-repository.ts
│   └── organization-repository.ts
└── building-blocks/
    ├── entity.base.ts
    ├── aggregate-root.base.ts
    ├── value-object.base.ts
    ├── domain-event.base.ts
    ├── specification.base.ts
    └── result.ts
```

### Application Layer (`src/application/features/`)

**Application business rules organized by feature**

#### Simple Features

Use `use-cases/` folder for combined read/write operations

```typescript
src/application/features/user/
├── use-case/
│   ├── create-user.use-case.ts
│   ├── get-user-details.use-case.ts
│   ├── update-user.use-case.ts
│   └── delete-user.use-case.ts
├── dto/
│   ├── create-user.dto.ts
│   ├── user-response.dto.ts
│   └── update-user.dto.ts
├── validator/
│   └── user-validator.ts
└── mapper/
    └── user-mapper.ts
```

#### Complex Features

Use `commands/` (writes) and `queries/` (reads) with CQRS

```typescript
src/application/features/organization/
├── command/
│   ├── create-organization.command.ts
│   ├── add-member.command.ts
│   ├── remove-member.command.ts
│   └── update-settings.command.ts
├── query/
│   ├── get-organization-details.query.ts
│   ├── get-member-list.query.ts
│   ├── get-organization-stats.query.ts
│   └── get-activity-log.query.ts
├── dto/
│   ├── create-organization.dto.ts
│   ├── organization-response.dto.ts
│   └── organization-stats.dto.ts
├── validator/
│   └── organization-validator.ts
└── mapper/
    └── organization-mapper.ts
```

### Infrastructure Layer (`src/infrastructure/`)

**External integrations (adapters/drivers)**

```typescript
src/infrastructure/
├── controller/
│   ├── auth-controller.ts
│   ├── user-controller.ts
│   └── organization-controller.ts
├── service/
│   ├── jwt-token.service.ts
│   ├── argon2-password.service.ts
│   └── redis-session.service.ts
├── repository/
│   ├── postgres-user-repository.ts
│   └── postgres-organization-repository.ts
├── persistence/
│   ├── drizzle/
│   │   ├── schema.ts
│   │   └── client.ts
│   ├── migration/
│   └── seed/
├── cache/
│   ├── redis-client.ts
│   └── cache-manager.ts
├── queue/
│   ├── bullmq-setup.ts
│   └── producer/
├── handler/
│   ├── email-handler.ts
│   └── event-handler.ts
├── security/
│   ├── input-sanitizer.ts
│   └── data-masker.ts
├── di/
│   ├── container.ts
│   └── bindings.ts
├── http/
│   ├── server.ts
│   └── routes.ts
└── gateway/
    ├── email-gateway.ts
    └── sms-gateway.ts
```

### Presentation Layer (`src/presentation/`)

**Request/response handling**

```typescript
src/presentation/
├── http/
│   ├── route/
│   │   ├── auth-routes.ts
│   │   ├── user-routes.ts
│   │   └── organization-routes.ts
│   └── server.ts
├── middleware/
│   ├── auth-middleware.ts
│   ├── validation-middleware.ts
│   ├── rate-limit-middleware.ts
│   └── error-handler-middleware.ts
├── validator/
│   ├── auth-request-validator.ts
│   └── organization-request-validator.ts
└── presenter/
    ├── user-presenter.ts
    └── organization-presenter.ts
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
// src/domain/aggregate/index.ts
export { UserIdentity } from "./user-identity.aggregate";
export { OrganizationMembership } from "./organization-membership.aggregate";

// src/domain/value-object/index.ts
export { Email } from "./email.value-object";
export { Password } from "./password.value-object";
export { CNPJ } from "./cnpj.value-object";

// src/application/features/user/index.ts
export { CreateUserUseCase } from "./use-case/create-user.use-case";
export { GetUserDetailsUseCase } from "./use-case/get-user-details.use-case";
export { CreateUserDto } from "./dto/create-user.dto";
export { UserResponseDto } from "./dto/user-response.dto";

// Usage
import { UserIdentity } from "@/domain/aggregate";
import { Email, Password } from "@/domain/value-object";
import { CreateUserUseCase, CreateUserDto } from "@/application/features/user";
```

## Dependency Direction

Dependencies always point inward: **Infrastructure → Application → Domain**

```typescript
// ✅ Good: Dependencies flow inward
// Domain Layer - No external dependencies
// src/domain/aggregate/user-identity.aggregate.ts
export class UserIdentity extends AggregateRoot<UserIdentityProps> {
  // Pure domain logic
}

// Application Layer - Depends only on Domain
// src/application/features/auth/use-case/login-user.use-case.ts
import { UserIdentity } from "@/domain/aggregate";
import { UserRepository } from "@/domain/repository";

export class LoginUserUseCase {
  constructor(private readonly userRepository: UserRepository) {}
}

// Infrastructure Layer - Depends on Domain and Application
// src/infrastructure/repository/postgres-user-repository.ts
import { UserRepository } from "@/domain/repository";
import { UserIdentity } from "@/domain/aggregate";

export class PostgresUserRepository implements UserRepository {
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
│   │   ├── aggregate/
│   │   ├── entity/
│   │   ├── value-object/
│   │   └── service/
│   ├── application/
│   │   └── features/
│   │       ├── auth/
│   │       ├── user/
│   │       └── organization/
│   └── infrastructure/
│       ├── repository/
│       └── service/
├── integration/
│   ├── api/
│   └── database/
└── e2e/
    ├── auth-flow/
    ├── user-flow/
    └── organization-flow/
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
