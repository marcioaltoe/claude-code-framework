# Drizzle ORM Standards

## Core Principles

1. **ULID for IDs** - Never UUID or auto-increment
2. **Snake_case** - For all database names
3. **Soft deletes** - Use deleted_at timestamp
4. **Always include** - created_at, updated_at
5. **Transactions** - For multi-step operations

## Schema Definition

```typescript
import { ulid } from 'ulid';
import { pgTable, varchar, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable("users", {
  id: varchar("id", { length: 26 }).primaryKey(),
  email: varchar("email", { length: 255 }).notNull().unique(),
  name: varchar("name", { length: 255 }).notNull(),
  created_at: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updated_at: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
  deleted_at: timestamp("deleted_at", { withTimezone: true }), // Soft delete
});
```

## Column Types

| Type        | Drizzle                             | Usage                         |
| ----------- | ----------------------------------- | ----------------------------- |
| ID          | `varchar(26)`                       | ULID - always 26 chars        |
| String      | `text()` or `varchar(n)`            | text unless limit needed      |
| Boolean     | `boolean()`                         | true/false values             |
| Number      | `integer()` or `numeric(p,s)`      | integers or decimals          |
| Date/Time   | `timestamp({ withTimezone: true })` | timezone-aware timestamps     |
| JSON        | `jsonb()`                           | structured data               |

## Repository Pattern

```typescript
import { eq, and, isNull } from "drizzle-orm";

export class UserRepository {
  async findById(id: string): Promise<User | null> {
    const [result] = await db
      .select()
      .from(users)
      .where(and(eq(users.id, id), isNull(users.deleted_at)))
      .limit(1);

    return result ? this.toDomain(result) : null;
  }

  async save(user: User): Promise<void> {
    await db
      .insert(users)
      .values(this.toPersistence(user))
      .onConflictDoUpdate({
        target: users.id,
        set: { ...this.toPersistence(user), updated_at: new Date() },
      });
  }

  private toDomain(row: any): User {
    return User.restore({ id: row.id, email: row.email, name: row.name });
  }

  private toPersistence(entity: User): any {
    return { id: entity.id, email: entity.email, name: entity.name };
  }
}
```

## Query Patterns

```typescript
// Select with soft delete filter
const activeUsers = await db
  .select()
  .from(users)
  .where(isNull(users.deleted_at))
  .limit(10);

// Transactions for multi-step operations
await db.transaction(async (tx) => {
  await tx.insert(users).values(userData);
  await tx.insert(profiles).values(profileData);
});

// Soft delete implementation
await db
  .update(users)
  .set({ deleted_at: new Date(), updated_at: new Date() })
  .where(eq(users.id, userId));
```

## Migrations

```bash
# Generate migration from schema changes
bun run db:generate

# Apply migrations
bun run db:migrate

# Open Drizzle Studio (development)
bun run db:studio
```

**Rules:**
- Never manually edit migration files
- Test migrations on development first
- Review generated SQL before applying

## Best Practices

**DO:**
- ✅ Use ULID for all IDs
- ✅ Include created_at and updated_at
- ✅ Use soft deletes (deleted_at)
- ✅ Use transactions for multi-step operations
- ✅ Use parameterized queries

**DON'T:**
- ❌ Use auto-increment or UUID
- ❌ Edit migration files manually
- ❌ Skip soft delete checks
- ❌ Create tables without timestamps
