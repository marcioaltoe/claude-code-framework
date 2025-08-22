# Fundamental Design Principles

## DRY - Don't Repeat Yourself

**Every piece of knowledge must have a single, unambiguous representation**

- Extract common logic into utilities
- Use configuration objects for shared settings
- Create abstractions for repeated patterns

## YAGNI - You Aren't Gonna Need It

**Don't build features until they're actually needed**

- No speculative generality
- No unused code
- No premature optimization
- Start simple, refactor when needed

## KISS - Keep It Simple, Stupid

**Simplest solution that works is the best solution**

- Avoid clever code
- Prefer clarity over brevity
- Reduce cognitive load
- Easy to understand > easy to write

## TDA - Tell, Don't Ask

**Objects should tell each other what to do, not ask for data**

```typescript
// ✅ Tell
order.applyDiscount(discount);

// ❌ Ask
if (order.getTotal() > 100) {
  order.setTotal(order.getTotal() * 0.9);
}
```

## Application

1. **Write code once** - Extract repeated logic
2. **Build only what's needed** - No future features
3. **Choose simple solutions** - Avoid complexity
4. **Encapsulate behavior** - Objects handle their own state

## Red Flags

- Copied code blocks
- "We might need this later"
- Complex abstractions for simple problems
- Methods asking for object internals
- Speculative design patterns