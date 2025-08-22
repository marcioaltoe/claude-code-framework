# SQL Standards

## Naming Conventions

- **Tables**: Plural, snake_case (`users`, `customer_orders`)
- **Columns**: snake_case
- **Primary key**: `{singular_table}_id` (e.g., `user_id`)
- **Foreign key**: Same as primary key reference

## Query Standards

```sql
-- UPPERCASE keywords, explicit columns
SELECT user_id, email, created_at
FROM users
JOIN orders USING (user_id)
WHERE status = 'active'
ORDER BY created_at DESC

-- Never use SELECT * in production
-- Always use prepared statements ($1, $2)
-- Never interpolate strings into queries
```

## Data Types

- **Strings**: Use `TEXT` (avoid `VARCHAR`)
- **Numbers**: `INT` or `NUMERIC`
- **Dates**: `TIMESTAMPTZ` (timezone-aware)

## Required Columns

```sql
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
```

## Best Practices

- Index columns used for searching/filtering
- Use `NOT NULL` constraints appropriately
- Create migrations for all schema changes
- Use prepared statements for security
