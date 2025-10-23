---
task-id: [task-number]
feature-slug: [feature-name]
status: pending # Options: pending, in-progress, completed, excluded
priority: [high|medium|low]
complexity: [low|medium|high]
estimated-hours: [number]
dependencies: []
assignee: [team-member]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
prd-reference: docs/features/[feature-slug]/prd.md
techspec-reference: docs/features/[feature-slug]/techspec.md
---

<task_context>
<domain>engine/infra/[subdomain]</domain>
<type>implementation|integration|testing|documentation</type>
<scope>core_feature|middleware|configuration|performance</scope>
<complexity>low|medium|high</complexity>
<dependencies>external_apis|database|temporal|http_server</dependencies>
</task_context>

# Task X.0: [Parent Task Title]

## Overview

[Brief description of task]

<import>**MUST READ BEFORE STARTING** @.cursor/rules/critical-validation.mdc</import>

<requirements>
[List of mandatory requirements]
</requirements>

## Test-First Development (TDD)

### Test Strategy

#### 📊 Test Pyramid

- **Unit Tests (70%)**: [Core logic, calculations, validators]
- **Integration Tests (20%)**: [API endpoints, database operations, service interactions]
- **E2E Tests (10%)**: [Critical user journeys, happy paths]

#### 🎭 Mock Strategy

- **To Mock**: [External APIs, database connections, file system, time/date]
- **Use Real**: [Domain logic, pure functions, value objects, in-memory operations]

#### 🎯 Coverage Targets

- **New Code**: 100% (TDD enforced)
- **Critical Paths**: 95%
- **Overall**: 80% minimum

#### ⚡ Performance Benchmarks

- **Unit Test**: < 100ms per test
- **Integration Test**: < 500ms per test
- **Test Suite**: < 5 minutes total

### 1. Write Tests FIRST

```typescript
// Test file: src/__tests__/[component].test.ts
describe('[Component/Feature]', () => {
  // RED: Write failing test first
  it('should [core behavior]', () => {
    // Given
    const input = [test data]

    // When
    const result = component.method(input)

    // Then
    expect(result).toBe(expected)
  })

  it('should handle [edge case]', () => {
    // Test edge cases and errors
  })
})
```

### 2. Implementation Checklist

- [ ] ❌ RED: Write failing tests
- [ ] ✅ GREEN: Write minimal code to pass
- [ ] ♻️ REFACTOR: Improve code quality
- [ ] ✅ All tests passing
- [ ] 📊 Coverage ≥ 80% for new code

## Subtasks

- [ ] X.1 Write unit tests for [component]
- [ ] X.2 Implement [component] to pass tests
- [ ] X.3 Refactor and optimize

## Implementation Details

[Relevant sections from tech spec]

### Relevant Files

- `path/to/file.go`

### Dependent Files

- `path/to/dependency.go`

## Success Criteria

- [Measurable outcomes]
- [Quality requirements]
