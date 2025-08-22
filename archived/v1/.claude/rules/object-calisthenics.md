# Object Calisthenics

## Core Rules for Better Code

### 1. Only One Level of Indentation per Method

**Avoid deep nesting - use early returns and extraction**

```typescript
// ✅ Good - Single level of indentation
function processOrder(order: Order): void {
  if (!order) {
    throw new Error("Order is required");
  }

  if (!order.items.length) {
    throw new Error("Order must have items");
  }

  if (!order.customer) {
    throw new Error("Customer is required");
  }

  // Process order
  calculateTotal(order);
  sendConfirmation(order);
}

// ❌ Bad - Deep nesting
function processOrder(order: Order): void {
  if (order) {
    if (order.items.length) {
      if (order.customer) {
        // Process order - nested too deep
        if (order.total > 0) {
          if (order.customer.email) {
            // Even deeper...
          }
        }
      } else {
        throw new Error("Customer is required");
      }
    } else {
      throw new Error("Order must have items");
    }
  } else {
    throw new Error("Order is required");
  }
}
```

### 2. Don't Use the ELSE Keyword

**Use early returns and guard clauses**

```typescript
// ✅ Good - No else keyword
function calculateDiscount(user: User): number {
  if (user.isPremium) {
    return 0.2;
  }

  if (user.yearsActive > 5) {
    return 0.15;
  }

  if (user.totalOrders > 100) {
    return 0.1;
  }

  return 0.05;
}

// ❌ Bad - Using else
function calculateDiscount(user: User): number {
  if (user.isPremium) {
    return 0.2;
  } else {
    if (user.yearsActive > 5) {
      return 0.15;
    } else {
      if (user.totalOrders > 100) {
        return 0.1;
      } else {
        return 0.05;
      }
    }
  }
}
```

### 3. Wrap All Primitives and Strings

**Use value objects instead of primitive types**

```typescript
// ✅ Good - Value objects
class Email {
  constructor(private readonly value: string) {
    if (!value.includes("@")) {
      throw new Error("Invalid email format");
    }
  }

  toString(): string {
    return this.value;
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }
}

class UserId {
  constructor(private readonly value: string) {
    if (!value || value.length < 3) {
      throw new Error("Invalid user ID");
    }
  }

  toString(): string {
    return this.value;
  }
}

class User {
  constructor(
    private readonly id: UserId,
    private readonly email: Email,
    private readonly name: string,
  ) {}
}

// ❌ Bad - Primitive obsession
class User {
  constructor(
    private readonly id: string, // What kind of string?
    private readonly email: string, // Is it validated?
    private readonly name: string,
  ) {}
}
```

### 4. First Class Collections

**Wrap collections in their own classes**

```typescript
// ✅ Good - First class collection
class OrderItems {
  private readonly items: OrderItem[] = [];

  add(item: OrderItem): void {
    if (this.items.length >= 10) {
      throw new Error("Maximum 10 items per order");
    }
    this.items.push(item);
  }

  remove(itemId: string): void {
    const index = this.items.findIndex((item) => item.id === itemId);
    if (index === -1) {
      throw new Error("Item not found");
    }
    this.items.splice(index, 1);
  }

  calculateTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price, 0);
  }

  count(): number {
    return this.items.length;
  }

  isEmpty(): boolean {
    return this.items.length === 0;
  }

  toArray(): readonly OrderItem[] {
    return [...this.items];
  }
}

class Order {
  constructor(
    private readonly id: OrderId,
    private readonly items: OrderItems,
  ) {}
}

// ❌ Bad - Exposed collection
class Order {
  constructor(
    private readonly id: string,
    public items: OrderItem[], // Exposed array
  ) {}

  addItem(item: OrderItem): void {
    this.items.push(item); // No validation
  }
}
```

### 5. One Dot Per Line

**Avoid method chaining - use intermediate variables**

```typescript
// ✅ Good - One dot per line
function processUserOrder(userId: string): void {
  const user = userRepository.findById(userId);
  const activeOrders = user.getActiveOrders();
  const pendingOrder = activeOrders.getPendingOrder();
  const total = pendingOrder.calculateTotal();

  if (total > 1000) {
    applyDiscount(pendingOrder);
  }
}

// ❌ Bad - Method chaining
function processUserOrder(userId: string): void {
  const total = userRepository
    .findById(userId)
    .getActiveOrders()
    .getPendingOrder()
    .calculateTotal();

  if (total > 1000) {
    // Which object do we apply discount to?
  }
}
```

### 6. Don't Abbreviate

**Use full, descriptive names**

```typescript
// ✅ Good - Full names
class UserAccountManager {
  private readonly userRepository: UserRepository;
  private readonly emailNotificationService: EmailNotificationService;

  async createUserAccount(userData: CreateUserAccountData): Promise<UserAccount> {
    const userAccount = new UserAccount(userData);
    await this.userRepository.save(userAccount);
    await this.emailNotificationService.sendWelcomeMessage(userAccount.email);
    return userAccount;
  }
}

// ❌ Bad - Abbreviations
class UsrAccMgr {
  private readonly usrRepo: UsrRepo;
  private readonly emailSvc: EmailSvc;

  async createUsrAcc(data: CreateUsrAccData): Promise<UsrAcc> {
    const usrAcc = new UsrAcc(data);
    await this.usrRepo.save(usrAcc);
    await this.emailSvc.sendWelcomeMsg(usrAcc.email);
    return usrAcc;
  }
}
```

### 7. Keep All Entities Small

**Classes should be focused and concise**

```typescript
// ✅ Good - Small, focused classes
class User {
  constructor(
    private readonly id: UserId,
    private readonly email: Email,
    private readonly profile: UserProfile,
  ) {}

  changeEmail(newEmail: Email): void {
    // Simple email change logic
  }
}

class UserProfile {
  constructor(
    private readonly firstName: string,
    private readonly lastName: string,
    private readonly birthDate: Date,
  ) {}

  getFullName(): string {
    return `${this.firstName} ${this.lastName}`;
  }

  getAge(): number {
    const today = new Date();
    return today.getFullYear() - this.birthDate.getFullYear();
  }
}

class UserPreferences {
  constructor(
    private readonly theme: Theme,
    private readonly language: Language,
    private readonly notifications: NotificationSettings,
  ) {}
}

// ❌ Bad - Large, unfocused class
class User {
  // Too many responsibilities
  private id: string;
  private email: string;
  private firstName: string;
  private lastName: string;
  private birthDate: Date;
  private theme: string;
  private language: string;
  private notificationSettings: any;
  private orders: Order[];
  private paymentMethods: PaymentMethod[];

  // Too many methods
  changeEmail(): void {}
  updateProfile(): void {}
  addOrder(): void {}
  calculateTotalSpent(): number {}
  getRecommendations(): Product[] {}
  updatePreferences(): void {}
  // ... 20+ more methods
}
```

### 8. No Classes with More Than Two Instance Variables

**Favor composition over large constructors**

```typescript
// ✅ Good - Two instance variables max
class Order {
  constructor(
    private readonly header: OrderHeader,
    private readonly items: OrderItems,
  ) {}
}

class OrderHeader {
  constructor(
    private readonly id: OrderId,
    private readonly customer: Customer,
  ) {}
}

class OrderItems {
  constructor(
    private readonly items: OrderItem[],
    private readonly pricing: PricingCalculator,
  ) {}
}

// ❌ Bad - Too many instance variables
class Order {
  constructor(
    private readonly id: string,
    private readonly customerId: string,
    private readonly customerName: string,
    private readonly items: OrderItem[],
    private readonly shippingAddress: Address,
    private readonly billingAddress: Address,
    private readonly paymentMethod: PaymentMethod,
    private readonly discount: number,
    private readonly tax: number,
    private readonly total: number,
  ) {}
}
```

### 9. No Getters/Setters/Properties

**Tell objects what to do, don't ask for their data**

```typescript
// ✅ Good - Tell, don't ask
class BankAccount {
  private balance: number = 0;

  deposit(amount: Money): void {
    if (amount.isNegative()) {
      throw new Error("Cannot deposit negative amount");
    }
    this.balance += amount.value;
  }

  withdraw(amount: Money): void {
    if (amount.isGreaterThan(this.balance)) {
      throw new Error("Insufficient funds");
    }
    this.balance -= amount.value;
  }

  canWithdraw(amount: Money): boolean {
    return amount.isLessThanOrEqual(this.balance);
  }
}

// Usage
account.withdraw(new Money(100));

// ❌ Bad - Ask, then tell
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

## Benefits of Object Calisthenics

### Code Quality

- **Readability** - Simpler, more linear code
- **Maintainability** - Smaller, focused components
- **Testability** - Easier to test isolated behavior

### Design Improvements

- **Encapsulation** - Better data hiding
- **Cohesion** - Related functionality grouped together
- **Loose Coupling** - Reduced dependencies between classes

### Practical Impact

- **Fewer Bugs** - Less complex code paths
- **Easier Refactoring** - Small, focused changes
- **Better Abstractions** - Clear separation of concerns

## When to Apply

### Start Gradually

- Apply one rule at a time
- Focus on new code first
- Refactor existing code incrementally

### Team Adoption

- Discuss rules with team
- Use in code reviews
- Create coding standards document

### Balance with Pragmatism

- Some rules may not fit every situation
- Focus on the spirit, not just the letter
- Adapt rules to your domain and context
