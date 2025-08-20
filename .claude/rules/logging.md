# Logging Standards

## Logging Library

- Use **Winston** for all logging operations
- Configure appropriate transports for different environments

## Log Levels

### DEBUG

- Use for detailed diagnostic information
- Helpful for debugging issues
- Not enabled in production by default
- Examples:
  - Function entry/exit points
  - Variable values during execution
  - Detailed request/response data

### INFO

- Use for general informational messages
- Track normal application flow
- Examples:
  - Server startup messages
  - Configuration loaded
  - Successful operations

### WARN

- Use for potentially harmful situations
- Issues that don't prevent operation
- Examples:
  - Deprecated API usage
  - Missing optional configuration
  - Retry attempts

### ERROR

- Use for error events that need investigation
- Application can continue running
- Examples:
  - Caught exceptions
  - Failed API calls
  - Database connection errors

## Logging Best Practices

### Output Configuration

- **Never** store logs in files directly
- Always redirect output through the process (stdout/stderr)
- Let the deployment environment handle log aggregation

### Sensitive Data Protection

- **Never log sensitive information:**
  - Personal names
  - Addresses
  - Credit card numbers
  - Passwords
  - API keys
  - Social Security numbers
  - Email addresses (consider masking)

### Message Clarity

- Write clear, concise log messages
- Include relevant context
- Avoid excessively long messages
- Use structured logging when appropriate

### Structured Logging Example

```typescript
logger.info("User action completed", {
  userId: user.id,
  action: "UPDATE_PROFILE",
  duration: 234,
  timestamp: new Date().toISOString(),
});
```

## Implementation Guidelines

### Console Usage

- **Never use** `console.log()` or `console.error()` in production code
- Always use Winston logger instead

### Exception Handling

- **Never silence exceptions**
- Always log errors before handling them
- Include stack traces for debugging

### Example Configuration

```typescript
import winston from "winston";

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json(),
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(winston.format.colorize(), winston.format.simple()),
    }),
  ],
});

export default logger;
```

## Usage Examples

### Basic Logging

```typescript
logger.debug("Processing user request", { requestId });
logger.info("Server started on port 3000");
logger.warn("API rate limit approaching", { remaining: 10 });
logger.error("Database connection failed", { error: err.message });
```

### Error Logging with Context

```typescript
try {
  await processPayment(order);
} catch (error) {
  logger.error("Payment processing failed", {
    orderId: order.id,
    amount: order.total,
    error: error.message,
    stack: error.stack,
  });
  throw error;
}
```

## Performance Considerations

### Log Level Management

- Use appropriate log levels to reduce noise
- Configure different levels for different environments:
  - Development: `debug`
  - Staging: `info`
  - Production: `warn` or `error`

### Asynchronous Logging

- Winston handles async logging by default
- Don't block application flow for logging

## Monitoring Integration

### Log Aggregation

- Structure logs for easy parsing by monitoring tools
- Use consistent field names across the application
- Include correlation IDs for request tracing

### Metrics and Alerting

- Log events that should trigger alerts
- Include measurable data for metrics
- Use consistent event names for tracking
