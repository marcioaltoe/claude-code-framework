# API over Hono (Bun)

## Routing and Middleware

- Use **Hono** for HTTP routing and middleware
- Configure CORS via `hono/cors` and keep allowed origins explicit

## Request/Response

- Prefer JSON payloads; validate and coerce inputs
- Return typed response bodies

## Pagination

- Use `limit` and `offset` query parameters
- Return total count in response metadata

```json
{
  "data": [],
  "pagination": { "limit": 20, "offset": 40, "total": 150 }
}
```

## Field Selection (Partial Response)

- Optional `fields` query parameter: `/users?fields=id,name,email`

# External API Communication

## HTTP Client

- Use the runtime-native `fetch` (Bun/Node/Browser)
- Implement timeouts with `AbortController`
- Add lightweight retry for transient failures when necessary
- Log requests and responses at appropriate levels (see logging rules)

## Example (fetch with timeout)

```typescript
const controller = new AbortController();
const timeoutId = setTimeout(() => controller.abort(), 5000);
try {
  const res = await fetch('https://api.external.com/data', {
    method: 'GET',
    headers: { Authorization: `Bearer ${token}` },
    signal: controller.signal,
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  const data = await res.json();
  // ... use data
} finally {
  clearTimeout(timeoutId);
}
```

# Best Practices

## Versioning

- Consider `/v1` style versioning or vendor headers
- Maintain backward compatibility

## Error Responses

- Provide consistent error response format:

```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with specified ID does not exist",
    "details": {}
  }
}
```

## Rate Limiting

- Add rate limiting at the edge or middleware layer if exposed publicly
- Return standard headers (`X-RateLimit-*`) when applicable

## CORS

- Configure CORS explicitly per environment
- Avoid wildcard origins in production