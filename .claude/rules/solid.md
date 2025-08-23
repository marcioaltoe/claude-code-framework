# SOLID Principles

## Single Responsibility Principle (SRP)

**One reason to change per class/module**

- Each class should have only one job
- Separate concerns into different classes

## Open/Closed Principle (OCP)

**Open for extension, closed for modification**

- Add new features without changing existing code
- Use interfaces and abstractions

## Liskov Substitution Principle (LSP)

**Subtypes must be substitutable for base types**

- Child classes shouldn't break parent class contracts
- Avoid throwing exceptions in overridden methods

## Interface Segregation Principle (ISP)

**Small, focused interfaces over large ones**

- Clients shouldn't depend on methods they don't use
- Split large interfaces into smaller, specific ones

## Dependency Inversion Principle (DIP)

**Depend on abstractions, not concretions**

- High-level modules shouldn't depend on low-level modules
- Both should depend on abstractions (interfaces)

## When to Apply

✅ **Apply SOLID when:**

- Complex business logic that will evolve
- Multiple implementations of the same concept
- Need for testability with mocks
- Team projects requiring clear boundaries

❌ **Don't over-apply when:**

- Simple CRUD operations
- Small scripts or utilities
- Prototypes or proof of concepts
- When it adds complexity without clear benefit

For detailed examples and patterns, consult @agent-typescript-expert or @agent-software-architect
