# Architecture & Design Principles (TypeScript)

<goal>
Establish comprehensive architectural standards and design principles for building maintainable, scalable, and robust TypeScript applications following industry best practices adapted to the project's domain-driven structure.
</goal>

## Core Architectural Principles

### SOLID Principles

<principle type="solid_srp">
**Single Responsibility Principle (SRP):**
- Each module, class, or function should have only one reason to change
- Separate business logic, data access, and presentation concerns
- Use domain-specific packages: `src/engine/{agent,task,tool,workflow,runtime,infra}/`
- *Implementation examples: see @.cursor/rules/typescript-patterns.md*
</principle>

<principle type="solid_ocp">
**Open/Closed Principle (OCP):**
- Open for extension, closed for modification
- Use interfaces, abstract classes, and composition over inheritance
- Leverage factory patterns and dependency injection for extensible behavior
- *Factory pattern implementation: see @.cursor/rules/typescript-patterns.md*
</principle>

<principle type="solid_lsp">
**Liskov Substitution Principle (LSP):**
- Subtypes must be substitutable for their base types
- Interface implementations must honor contracts
- Ensure polymorphic behavior is consistent
- *Interface design patterns: see @.cursor/rules/typescript-patterns.md*
</principle>

<principle type="solid_isp">
**Interface Segregation Principle (ISP):**
- Clients should not depend on interfaces they don't use
- Create small, focused interfaces
- Use interface composition for complex behavior
- *Interface composition examples: see @.cursor/rules/typescript-patterns.md*
</principle>

<principle type="solid_dip">
**Dependency Inversion Principle (DIP):**
- Depend on abstractions (interfaces), not concretions
- Use dependency injection through constructors or IoC containers
- High-level modules should not depend on low-level modules
- *Constructor patterns: see @.cursor/rules/typescript-patterns.md*
</principle>

### DRY Principle (Don't Repeat Yourself)

<dry_strategies type="code_reuse">
**Code Reuse Strategies:**

- Extract common functionality into shared modules
- Use generic types and functions for similar operations
- Create utility packages for cross-cutting concerns

```typescript
// ✅ Good: Reusable validation utility
export const validateRequired = (value: string, fieldName: string): void => {
    if (!value?.trim()) {
        throw new ValidationError(`${fieldName} is required`);
    }
};

// Usage across multiple validators
export class UserValidator {
    validateName(name: string): void {
        validateRequired(name, 'name');
    }
}

export class TaskValidator {
    validateTitle(title: string): void {
        validateRequired(title, 'title');
    }
}
```
</dry_strategies>

<dry_strategies type="configuration_patterns">
**Configuration Patterns:**

- Centralize configuration with type safety and defaults
- Use template literals and configuration objects
- Avoid duplicating configuration logic
- *Configuration implementation: see @.cursor/rules/typescript-patterns.md*
</dry_strategies>

### Clean Architecture

<architecture_structure type="clean_architecture">
**Clean Architecture Structure with Selective CQRS:**

```
src/
├── domain/            # Core enterprise logic
│   ├── entities/      # Business objects with identity
│   ├── value-objects/ # Immutable, identity-less objects
│   ├── events/        # Domain events
│   ├── errors/        # Custom domain-level exceptions
│   ├── factories/     # Builders for complex aggregates
│   ├── services/      # Pure domain logic operations
│   └── interfaces/    # Abstract contracts (ports)
│       ├── repositories/  # Repository abstractions
│       └── services/      # External service contracts
├── application/       # Application business rules (use cases)
│   └── features/      # Feature-driven modules
│       ├── user/      # Simple feature example
│       │   ├── use-cases/     # Combined read/write use cases
│       │   ├── dtos/          # Input/output interface models
│       │   ├── validators/    # Input validation logic
│       │   └── mappers/       # DTO ⇄ Domain translation
│       └── order/     # Complex feature with CQRS
│           ├── commands/      # Mutation use case handlers
│           ├── queries/       # Read-only logic
│           ├── dtos/
│           ├── validators/
│           └── mappers/
├── infrastructure/    # External integrations (adapters/drivers)
│   ├── controllers/   # HTTP API route controllers
│   ├── services/      # Implementations of external service interfaces
│   ├── repositories/  # Implementation of domain repositories
│   ├── orm/          # ORM configuration (e.g., Drizzle)
│   ├── database/     # DB connection and pooling
│   ├── queue/        # Message broker setup
│   ├── handlers/     # Queue/job workers or subscribers
│   ├── di/           # Dependency Injection setup
│   ├── http/         # Server setup and global middlewares
│   └── gateway/      # External APIs clients
├── presentation/      # Request/response layer
│   ├── http/         # HTTP request handling
│   ├── middlewares/  # Custom middleware
│   ├── validators/   # Request validation
│   └── presenters/   # Response formatting
└── main.ts           # Application entry point
```
</architecture_structure>

<layer_separation>
**Clean Architecture Layer Responsibilities:**

- **Domain Layer** (`src/domain/`): Core enterprise business rules
  - Entities: Business objects with identity
  - Value Objects: Immutable objects without identity
  - Domain Services: Pure domain logic operations
  - Domain Events: Important business events
  - Domain Errors: Domain-specific exceptions
  - Factories: Create complex domain objects and aggregates
  - Interfaces: Ports for repositories and external services

- **Application Layer** (`src/application/features/`): Application business rules organized by feature
  - **Simple Features**: Use `use-cases/` folder for combined read/write operations
  - **Complex Features**: Use `commands/` (writes) and `queries/` (reads) with CQRS
  - DTOs: Data transfer objects for input/output
  - Validators: Business rule validation
  - Mappers: DTO ⇄ Domain model translation

- **Infrastructure Layer** (`src/infrastructure/`): External integrations (adapters/drivers)
  - Controllers: HTTP API route controllers
  - Repositories: Data persistence implementations
  - Services: External service implementations
  - Database: DB connection and management
  - Queue: Message broker implementations
  - Gateway: External API integrations

- **Presentation Layer** (`src/presentation/`): Request/response handling
  - HTTP: Request handling frameworks
  - Middlewares: Cross-cutting concerns
  - Validators: Request validation
  - Presenters: Response formatting

**Dependency Direction:**
Dependencies always point inward: Infrastructure → Application → Domain
</layer_separation>

<dependency_flow>

```typescript
// ✅ Good: Dependencies flow inward (Infrastructure → Application → Domain)

// Domain Layer - Core business logic
// src/domain/entities/Task.ts
export class Task {
    constructor(
        public readonly id: ID,
        public readonly title: string,
        public readonly status: TaskStatus
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
// src/application/features/task/use-cases/CompleteTask.ts
import { Task } from '../../../domain/entities/Task';
import { TaskRepository } from '../../../domain/interfaces/repositories/TaskRepository';

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
// src/infrastructure/repositories/PostgreSQLTaskRepository.ts
import { TaskRepository } from '../../domain/interfaces/repositories/TaskRepository';
import { Task } from '../../domain/entities/Task';

export class PostgreSQLTaskRepository implements TaskRepository {
    constructor(private readonly db: DatabaseConnection) {}

    async save(task: Task): Promise<void> {
        // Implementation details
    }

    async findById(id: ID): Promise<Task | null> {
        // Implementation details
    }
}

// Presentation Layer - Controllers
// src/infrastructure/controllers/TaskController.ts
import { CompleteTaskUseCase } from '../../application/features/task/use-cases/CompleteTask';

export class TaskController {
    constructor(private readonly completeTaskUseCase: CompleteTaskUseCase) {}

    async completeTask(request: Request): Promise<Response> {
        const { taskId } = request.params;
        await this.completeTaskUseCase.execute(taskId);
        return { success: true };
    }
}
```

</dependency_flow>

### Clean Code Practices

**Naming Conventions:**

- Use intention-revealing names
- Avoid mental mapping and abbreviations
- Use searchable names for important concepts
- Follow TypeScript naming conventions (PascalCase for types/classes, camelCase for variables/functions)

<example type="naming_conventions">

```typescript
// ✅ Good: Clear, intention-revealing names
export interface WorkflowExecutionResult {
    taskResults: TaskResult[];
    executionTime: number;
    status: ExecutionStatus;
}

export class WorkflowService {
    async executeWorkflowWithRetry(
        workflowId: ID,
        maxRetries: number
    ): Promise<WorkflowExecutionResult> {
        // Implementation
    }
}

// ❌ Bad: Unclear, abbreviated names
interface WfExecRes {
    tr: TskRes[];
    et: number;
    s: number;
}

class WfSvc {
    async execWf(id: string, mr: number): Promise<WfExecRes> {
        // Implementation
    }
}
```
</example>

<function_design>
**Function Design:**
- Follow function length limits defined in typescript-coding-standards.md
- Single level of abstraction per function
- Minimize function parameters (max 3-4, use options object for more)
- Use proper TypeScript typing for all parameters and return values
</function_design>

<example type="function_design">

```typescript
// ✅ Good: Small, focused function with proper typing
export class TaskService {
    async validateTaskInput(task: Task): Promise<void> {
        await this.validateRequiredFields(task);
        await this.validateBusinessRules(task);
    }

    private validateRequiredFields(task: Task): void {
        if (!task.title) {
            throw new ValidationError('Title is required');
        }
        if (!task.type) {
            throw new ValidationError('Type is required');
        }
    }

    private async validateBusinessRules(task: Task): Promise<void> {
        // Business rule validation
    }
}

// ✅ Good: Using options object for many parameters
interface ExecuteWorkflowOptions {
    workflowId: ID;
    maxRetries?: number;
    timeout?: number;
    context?: ExecutionContext;
}

async executeWorkflow(options: ExecuteWorkflowOptions): Promise<WorkflowResult> {
    // Implementation
}
```

</example>

<error_handling_architecture>
**Error Handling Architecture:**
- Use custom error classes with proper inheritance
- Leverage TypeScript's union types for expected errors
- Follow unified error handling strategy from @.cursor/rules/typescript-coding-standards.md
</error_handling_architecture>

<example type="error_handling">

```typescript
// ✅ Good: Structured error handling with custom errors
export class WorkflowValidationError extends Error {
    constructor(
        message: string,
        public readonly workflowId: ID,
        public readonly validationErrors: string[]
    ) {
        super(message);
        this.name = 'WorkflowValidationError';
    }
}

export class WorkflowService {
    async executeWorkflow(id: ID): Promise<WorkflowResult> {
        try {
            const workflow = await this.repository.findWorkflow(id);
            if (!workflow) {
                throw new WorkflowNotFoundError(`Workflow ${id} not found`);
            }

            this.validateWorkflow(workflow);
            return await this.executeWorkflowTasks(workflow);
        } catch (error) {
            if (error instanceof WorkflowValidationError) {
                throw error; // Re-throw domain errors
            }
            throw new WorkflowExecutionError(`Failed to execute workflow ${id}`, error);
        }
    }

    private validateWorkflow(workflow: Workflow): void {
        const errors: string[] = [];
        
        if (!workflow.tasks.length) {
            errors.push('Workflow must have at least one task');
        }

        if (errors.length > 0) {
            throw new WorkflowValidationError(
                'Workflow validation failed',
                workflow.id,
                errors
            );
        }
    }
}
```
</example>

## Project-Specific Patterns

### Feature-Driven Organization

<package_structure>
**Clean Architecture Package Structure:**
- Each feature in `src/application/features/` has clear boundaries
- Domain entities and interfaces in `src/domain/`
- Infrastructure adapters in `src/infrastructure/`
- Presentation layer in `src/presentation/`
- **AVOID** shared/, utils/, or common/ folders - colocate by responsibility and context
- Use barrel exports (`index.ts`) for clean imports
</package_structure>

### File Naming Conventions

<naming_conventions>
**Consistent kebab-case naming:**
- `create-user.use-case.ts` (simple feature)
- `create-order.command.ts` (complex feature with CQRS)
- `get-order-analytics.query.ts` (complex feature with CQRS)
- `user.repository.ts`
- `order.entity.ts`
- `email.service.ts`
</naming_conventions>

### Service Construction

<constructor_pattern type="mandatory">
**MANDATORY constructor pattern for all services**
- Use dependency injection through constructors
- Always provide type-safe configuration handling
- Use readonly properties for injected dependencies
- *Implementation examples: see @.cursor/rules/typescript-patterns.md*
</constructor_pattern>

### Async/Await Patterns

<async_requirements type="mandatory">
**Proper async/await usage:**
- Always handle Promise rejections
- Use proper error handling in async functions
- Propagate cancellation through AbortController
- *Async patterns: see @.cursor/rules/typescript-patterns.md*
</async_requirements>

### Resource Management

<cleanup_patterns>
**Resource cleanup requirements:**
- Implement proper cleanup in async functions
- Use try/finally blocks for cleanup operations
- Handle cleanup errors appropriately
- Implement timeout handling for long-running operations
- *Resource management patterns: see @.cursor/rules/typescript-patterns.md*
</cleanup_patterns>

## TypeScript-Specific Patterns

### Type Safety

<type_safety>
**Strict TypeScript Configuration:**
- Enable strict mode in tsconfig.json
- Use `noImplicitAny`, `strictNullChecks`, `strictFunctionTypes`
- Avoid `any` type, use `unknown` when necessary
- Use type guards for runtime type checking
</type_safety>

<example type="type_safety">

```typescript
// ✅ Good: Proper type safety
interface User {
    id: ID;
    name: string;
    email?: string;
}

// Type guard for runtime checking
function isUser(obj: unknown): obj is User {
    return (
        typeof obj === 'object' &&
        obj !== null &&
        'id' in obj &&
        'name' in obj &&
        typeof (obj as User).name === 'string'
    );
}

// Using union types for expected variations
type TaskStatus = 'pending' | 'running' | 'completed' | 'failed';

interface TaskResult {
    status: TaskStatus;
    data?: unknown;
    error?: Error;
}
```

</example>

## Selective CQRS Implementation

### Core Principle: Complexity-Driven Architecture

Use **unified use cases** by default, apply **CQRS** only when complexity demands it.

### Default Approach: Simple Features (Unified Use Cases)

For straightforward features, use a single `use-cases/` folder containing both read and write operations:

<example type="simple_feature">

```typescript
// Simple feature structure
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

</example>

### Complex Features: CQRS Implementation

Apply CQRS when features meet complexity thresholds:

**When to Use CQRS:**
- High complexity with distinct read/write models
- Performance requirements demand separate optimization
- Multiple read projections needed
- Event sourcing or complex domain events
- Independent scaling requirements for reads/writes

<example type="complex_feature_cqrs">

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

</example>

### Migration Path: Simple to Complex

Features can evolve naturally:

1. **Start Simple**: Begin with `use-cases/` folder
2. **Monitor Complexity**: Track performance and maintainability
3. **Refactor When Needed**: Split into `commands/` and `queries/` when thresholds are reached
4. **Update Dependencies**: Adjust tests and documentation

<example type="migration_example">

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

</example>

## Anti-Patterns to Avoid

### God Objects
```typescript
// ❌ Avoid: Too many responsibilities
class MegaService {
    // Too many dependencies and responsibilities
    constructor(
        private db: Database,
        private cache: Cache,
        private logger: Logger,
        private emailService: EmailService,
        private fileStorage: FileStorage,
        // ... too many dependencies
    ) {}
}
```

### Tight Coupling

```typescript
// ❌ Avoid: Direct dependency on concrete types
class UserService {
    private db = new PostgreSQLDatabase(); // Should be injected interface
}

// ✅ Good: Depend on abstractions
class UserService {
    constructor(private readonly db: Database) {}
}
```

### Any Type Abuse

```typescript
// ❌ Avoid: Overuse of any
function processData(data: any): any {
    return data.someProperty;
}

// ✅ Good: Proper typing
interface InputData {
    someProperty: string;
}

function processData(data: InputData): string {
    return data.someProperty;
}
```

### Circular Dependencies

```typescript
// ❌ Avoid: Module A imports B, B imports A
// Use dependency injection or event patterns instead
```

### Magic Numbers/Strings

```typescript
// ❌ Avoid: Magic values
if (status === 'active') { /* unclear what active means */ }

// ✅ Use: Enums or const assertions
enum UserStatus {
    ACTIVE = 'active',
    INACTIVE = 'inactive',
    SUSPENDED = 'suspended'
}

const USER_STATUS = {
    ACTIVE: 'active',
    INACTIVE: 'inactive',
    SUSPENDED: 'suspended'
} as const;

type UserStatusType = typeof USER_STATUS[keyof typeof USER_STATUS];
```

## Quality Metrics

### Code Quality Indicators

- **Function complexity and length:** Follow limits defined in typescript-coding-standards.md
- **Type Coverage:** Aim for 100% TypeScript coverage (no implicit any)
- **Package Coupling:** Minimize cross-package dependencies
- **Test Coverage:** Aim for 80%+ on business logic

### Architecture Health

- **Dependency Direction:** Always inward toward domain
- **Interface Usage:** High ratio of interfaces to concrete types
- **Package Cohesion:** Related functionality grouped together
- **Separation of Concerns:** Clear boundaries between layers
- **Type Safety:** No `any` types in production code

### TypeScript-Specific Metrics

- **Strict Mode Compliance:** All strict TypeScript options enabled
- **Generic Usage:** Appropriate use of generics for reusability
- **Error Handling:** Proper Promise error handling
- **Import Structure:** Clean barrel exports and dependency flow

## Final Guidelines

1. **Design for Change:** Assume requirements will evolve
2. **Favor Composition:** Over inheritance and complex hierarchies
3. **Explicit Dependencies:** Make all dependencies visible through types
4. **Fail Fast:** Validate inputs early with TypeScript types and runtime checks
5. **Document Decisions:** Capture architectural decisions and trade-offs
6. **Measure and Monitor:** Track architecture health metrics
7. **Refactor Continuously:** Improve design as understanding grows
8. **Test Architecture:** Verify architectural constraints in tests
9. **Leverage TypeScript:** Use the type system to prevent errors at compile time
10. **Async Best Practices:** Proper Promise handling and error propagation
11. **Performance Considerations:** Use proper bundling and tree-shaking
12. **IDE Integration:** Leverage TypeScript's tooling for better developer experience