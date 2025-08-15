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

## Implementation Notes

- See `typescript-patterns.md` for detailed fetch timeout examples
- Use structured error handling with proper HTTP status codes

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
