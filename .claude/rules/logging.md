# Logging Standards

## Setup

Use **Winston** for all logging:

```typescript
import winston from "winston";

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});
```

## Log Levels

- **DEBUG**: Detailed diagnostic info (dev only)
- **INFO**: Normal application flow
- **WARN**: Potential issues
- **ERROR**: Errors needing investigation

## Usage

```typescript
logger.info("Server started", { port: 3000 });
logger.error("Payment failed", { 
  orderId: order.id, 
  error: error.message 
});
```

## Best Practices

- **Never use** `console.log()` in production
- **Never log** passwords, API keys, personal data
- Use structured logging with context
- Output to stdout/stderr (not files)
- Include stack traces for errors
