# API Standards

## Core Stack

- **Hono** - HTTP routing and middleware
- **Zod** - Schema validation
- **@hono/zod-validator** - Request/response validation

## Validation

```typescript
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";

// Query parameters (with coercion)
const QuerySchema = z.object({
  page: z.coerce.number().default(1),
  limit: z.coerce.number().max(100).default(10),
});

app.get("/api/items", zValidator("query", QuerySchema), (c) => {
  const { page, limit } = c.req.valid("query");
});

// JSON body
const CreateSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

app.post("/api/items", zValidator("json", CreateSchema), (c) => {
  const data = c.req.valid("json");
});
```

## Response Format

```typescript
// Paginated response
{
  "data": [],
  "pagination": { "limit": 20, "offset": 40, "total": 150 }
}

// Error response
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User not found"
  }
}
```

## Best Practices

- Use native `fetch` with `AbortController` for timeouts
- Consistent error responses with proper HTTP status codes
- Explicit CORS configuration (no wildcards in production)
- Version APIs with `/v1` prefix when needed
