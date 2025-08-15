# SQL Database Standards

## Database Connection

- Use **pg-promise** for connecting to the database

## Naming Conventions

### Tables and Columns

- Use English names in **plural** form
- Apply **snake_case** formatting
- Examples: `users`, `customer_orders`, `payment_methods`

### Primary and Foreign Keys

- Use singular table name followed by `_id`
- Examples:
  - `users` table → `user_id`
  - `customers` table → `customer_id`
  - `orders` table → `order_id`
  - `payments` table → `payment_id`

## SQL Query Standards

### Keywords

- Always use **UPPERCASE** for SQL keywords
- Examples: `SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY`, `ORDER BY`

### Joins

- Always use explicit `JOIN` syntax instead of joining tables in the `WHERE` clause
- Prefer `USING` over `ON` when possible
- Example:

  ```sql
  -- Good
  SELECT * FROM users
  JOIN orders USING (user_id)

  -- Avoid
  SELECT * FROM users, orders
  WHERE users.user_id = orders.user_id
  ```

### Select Statements

- **Never use** `SELECT *` in production code
- Always explicitly specify column names
- Example:
  ```sql
  SELECT user_id, username, email, created_at
  FROM users
  ```

## Data Types

### String Types

- Always use `TEXT` for string fields
- Avoid `VARCHAR` unless there's a specific requirement

### Numeric Types

- Use `INT` for whole numbers
- Use `NUMERIC` for decimal/floating-point values

### Date/Time

- Use timezone-aware date/time fields (e.g., `TIMESTAMPTZ`)

## Performance Optimization

### Indexing

- Create indexes on columns used for searching/filtering
- Consider composite indexes for frequently used column combinations

### Query Optimization

- Resolve grouping and ordering in the query itself using `GROUP BY` and `ORDER BY`
- Always specify order direction: `ASC` or `DESC`
- Use `IN` and `BETWEEN` instead of complex `AND`/`OR` combinations when appropriate

## Query Formatting

Break lines after major clauses for readability:

```sql
SELECT user_id, username, email
FROM users
WHERE status = 'active'
GROUP BY user_id
ORDER BY created_at DESC
```

## Security

### Prepared Statements

- **Always use prepared statements**
- Never interpolate strings directly into queries
- Example:

  ```sql
  -- Good
  SELECT * FROM users WHERE user_id = $1

  -- Never do this
  SELECT * FROM users WHERE user_id = '${userId}'
  ```

## Table Design

### Required Columns

Every table must include:

- `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`
- `updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`

### Constraints

- Use `NOT NULL` constraints wherever appropriate
- Align constraints with application-level validations

## Database Changes

### Migrations

- Create a migration for every database modification
- Always include both:
  - **Up migration**: Apply changes
  - **Down migration**: Rollback changes if necessary
