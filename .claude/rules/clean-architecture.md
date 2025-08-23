# Clean Architecture

## Core Principle: The Dependency Rule

**Dependencies always point inward: Infrastructure → Application → Domain**

## Architecture Layers

```
src/
├── domain/            # Pure business logic (zero dependencies)
├── application/       # Use cases and orchestration
├── infrastructure/    # External world implementations
└── presentation/      # User interface adapters
```

## Layer Responsibilities

**Domain Layer** (`/src/domain`)

- Pure business rules and logic - knows nothing about outside world
- Entities, Value Objects, Domain Services, Events, Errors, Factories, Ports

**Application Layer** (`/src/application`)

- Application-specific orchestration, not framework-bound
- Use Cases (simple features) or Commands/Queries (complex features with CQRS)
- DTOs, Validators, Mappers

**Infrastructure Layer** (`/src/infrastructure`)

- Controllers, Repositories, External Services, Database, ORM, Queues, Gateways

**Presentation Layer** (`/src/presentation`)

- HTTP handlers, Middlewares, Request/Response formatting

## Pragmatic Approach

**Start Simple** - Use unified `use-cases/` folder by default
**Apply CQRS Only When**:

- Significantly different read/write models
- High performance requirements with different scaling needs
- Complex reporting that doesn't fit the write model

## Key Principles

1. **Dependency Inversion** - Depend on abstractions, not implementations
2. **Rich Domain Model** - Business logic belongs in domain entities
3. **YAGNI** - Don't add complexity until actually needed
4. **Single Responsibility** - Each class has one reason to change

For detailed patterns and examples, consult @agent-software-architect
