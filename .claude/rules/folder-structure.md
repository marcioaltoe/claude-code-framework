# Folder Structure & Organization

## Core Philosophy

**Clean Architecture + Clean Code + SOLID Principles**
- Focus on maintainability and testability over complex patterns
- Dependency Rule: Dependencies point inward (Infrastructure → Application → Domain)
- SOLID principles guide all design decisions
- Pragmatic approach: Use advanced patterns (CQRS, Event Sourcing) only when complexity demands

## Quick Reference Structure

```
src/
├── domain/                        # Core business logic (pure, no dependencies)
│   ├── entities/                  # Business entities
│   ├── value-objects/             # Immutable value objects
│   ├── services/                  # Domain services (business logic)
│   ├── ports/                     # Interfaces for external dependencies
│   └── errors/                    # Domain-specific errors
│
├── application/                   # Application services & use cases
│   ├── use-cases/                 # Business operations
│   ├── dtos/                      # Data transfer objects
│   ├── mappers/                   # DTO/Entity mappers
│   └── validators/                # Input validation
│
├── infrastructure/                # Technical implementations
│   ├── database/                  # Data persistence
│   │   ├── repositories/          # Repository implementations
│   │   ├── migrations/            # Database migrations
│   │   └── schemas/               # Database schemas
│   │
│   ├── external/                  # External services
│   │   ├── apis/                  # Third-party API clients
│   │   ├── messaging/             # Message brokers
│   │   └── storage/               # File storage
│   │
│   └── services/                  # Infrastructure services
│
├── presentation/                  # User interfaces
│   └── api/                       # REST API
│       ├── controllers/           # Request handlers
│       ├── middlewares/           # Cross-cutting concerns
│       ├── routes/                # Route definitions
│       └── validators/            # Request validation
│
├── config/                        # Configuration
│   ├── database.config.ts
│   ├── app.config.ts
│   └── environments/
│
└── main.ts                        # Application entry
```

## File Naming Conventions

**All files and folders use kebab-case:**

```typescript
// Domain Layer
user.entity.ts                    // Entity
email.value-object.ts              // Value Object
user-created.event.ts              // Domain Event
user-not-found.error.ts            // Domain Error
user.repository.ts                 // Repository interface (port)

// Application Layer
create-user.use-case.ts            // Use Case
create-user.dto.ts                 // DTO
user.mapper.ts                     // Mapper
user.validator.ts                  // Validator

// Infrastructure Layer
postgres-user.repository.ts        // Repository implementation
redis-cache.service.ts             // Service implementation
stripe-payment.gateway.ts          // External gateway

// Tests
create-user.use-case.test.ts       // Test file
user.entity.spec.ts                // Specification test
```

## Layer Examples

### Domain Layer
**Pure business logic - NO external dependencies**

```typescript
// src/domain/entities/product.entity.ts
export class Product {
  constructor(
    private readonly id: string,
    private name: string,
    private price: number,
  ) {}

  changePrice(newPrice: number): void {
    if (newPrice < 0) {
      throw new InvalidPriceError('Price cannot be negative');
    }
    this.price = newPrice;
  }
}

// src/domain/ports/product.repository.ts
export interface ProductRepository {
  save(product: Product): Promise<void>;
  findById(id: string): Promise<Product | null>;
}
```

### Application Layer
**Use cases orchestrating business logic**

```typescript
// src/application/use-cases/update-product-price.use-case.ts
export class UpdateProductPriceUseCase {
  constructor(
    private readonly productRepository: ProductRepository,
  ) {}

  async execute(productId: string, newPrice: number): Promise<void> {
    const product = await this.productRepository.findById(productId);
    if (!product) {
      throw new ProductNotFoundError(productId);
    }

    product.changePrice(newPrice);
    await this.productRepository.save(product);
  }
}
```

### Infrastructure Layer
**Technical implementations**

```typescript
// src/infrastructure/database/repositories/postgres-product.repository.ts
export class PostgresProductRepository implements ProductRepository {
  constructor(private readonly db: Database) {}

  async save(product: Product): Promise<void> {
    await this.db.query(
      'UPDATE products SET name = $1, price = $2 WHERE id = $3',
      [product.name, product.price, product.id]
    );
  }

  async findById(id: string): Promise<Product | null> {
    const row = await this.db.query('SELECT * FROM products WHERE id = $1', [id]);
    return row ? this.toDomain(row) : null;
  }
}
```

### Presentation Layer
**User interface adapters**

```typescript
// src/presentation/api/controllers/product.controller.ts
export class ProductController {
  constructor(
    private readonly updatePriceUseCase: UpdateProductPriceUseCase,
  ) {}

  async updatePrice(req: Request, res: Response): Promise<void> {
    try {
      await this.updatePriceUseCase.execute(
        req.params.id,
        req.body.price
      );
      res.status(200).json({ message: 'Price updated' });
    } catch (error) {
      if (error instanceof ProductNotFoundError) {
        res.status(404).json({ error: error.message });
      } else {
        res.status(400).json({ error: 'Invalid request' });
      }
    }
  }
}
```

## Best Practices

### ✅ DO

1. **Keep domain layer pure** - No external dependencies
2. **Use dependency injection** - Depend on abstractions (interfaces)
3. **Follow SOLID principles** - Single responsibility, open/closed, etc.
4. **Write testable code** - Design for testing from the start
5. **Use meaningful names** - Code should be self-documenting
6. **Keep it simple** - Don't over-engineer, YAGNI principle

### ❌ DON'T

1. **Don't leak infrastructure into domain** - Keep business logic pure
2. **Don't create unnecessary abstractions** - Abstract only when needed
3. **Don't use CQRS/Event Sourcing prematurely** - Only for complex domains
4. **Don't violate dependency rule** - Dependencies flow inward only
5. **Don't create anemic domain models** - Entities should have behavior

## Testing Structure

Mirror the source structure:

```
tests/
├── unit/
│   ├── domain/
│   │   └── [context]/
│   │       ├── entities/
│   │       └── value-objects/
│   └── application/
│       └── [context]/
│           └── use-cases/
├── integration/
│   └── infrastructure/
│       ├── repositories/
│       └── external/
└── e2e/
    └── api/
        └── [feature]/
```

## When to Use Advanced Patterns

### CQRS (Command Query Responsibility Segregation)
**Only use when you have:**
- Complex read models that differ significantly from write models
- High performance requirements with different scaling needs
- Need for event sourcing
- Clear business justification for the added complexity

```typescript
// Start simple (default approach)
src/application/use-cases/
├── create-product.use-case.ts
├── update-product.use-case.ts
└── get-product.use-case.ts

// Only evolve to CQRS when complexity demands it
src/application/
├── commands/
│   ├── create-product.command.ts
│   └── update-product.command.ts
└── queries/
    ├── get-product.query.ts
    └── search-products.query.ts
```

### Domain Events
**Only use when explicitly needed:**
- Integration between bounded contexts
- Audit logging requirements
- Asynchronous workflows
- External system notifications

**Avoid using for:**
- Simple CRUD operations
- Internal method calls
- Synchronous workflows

## Migration Guide

From MVC/Traditional Architecture to Clean Architecture:

1. **Start with Use Cases** - Identify your main business operations
2. **Extract Domain Logic** - Move business rules from controllers/services to domain
3. **Define Ports** - Create interfaces for external dependencies
4. **Implement Adapters** - Move infrastructure code to proper layer
5. **Refactor Controllers** - Make them thin, only handling HTTP concerns
6. **Add Tests** - Unit tests for domain/application, integration for infrastructure

## Key Principles Summary

1. **Clean Architecture**: Separation of concerns through layers
2. **Clean Code**: Readable, maintainable, self-documenting code
3. **SOLID Principles**: Guide all design decisions
4. **KISS**: Keep It Simple, Stupid - avoid unnecessary complexity
5. **YAGNI**: You Aren't Gonna Need It - build only what's needed
6. **DRY**: Don't Repeat Yourself - but don't abstract prematurely
7. **Pragmatism**: Use advanced patterns only when justified by complexity