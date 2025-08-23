---
feature-slug: [feature-name]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
facilitator: business-analyst
participants:
  - product-manager
  - ux-designer
  - tech-lead
  - domain-expert
---

# [Feature] - Implementation Task Summary

## Task Overview

**Total Tasks**: [X]
**Critical Path**: T001 → T003 → T005

## Parallelization Opportunities

```
After T001 completes:
├── Claude 1: T002 → T003
├── Claude 2: T004
└── Claude 3: T005

After T003 completes:
├── Claude 1: T006
├── Claude 2: T007
└── Claude 3: T008
```

## Task List

| ID   | Category | Task                        | Dependencies | Parallel With | Status  |
| ---- | -------- | --------------------------- | ------------ | ------------- | ------- |
| T001 | INFRA    | Setup database schemas      | -            | -             | Pending |
| T002 | DOMAIN   | Create core entities        | T001         | T004          | Pending |
| T003 | DOMAIN   | Implement business logic    | T002         | -             | Pending |
| T004 | DOMAIN   | Create value objects        | T001         | T002          | Pending |
| T005 | API      | Create REST endpoints       | T003         | -             | Pending |
| T006 | TEST     | Write unit tests for domain | T002         | T003, T004    | Pending |
| T007 | UI       | Build user interface        | T005         | T008, T009    | Pending |
| T008 | TEST     | Write integration tests     | T005         | T007, T009    | Pending |
| T009 | DOC      | Update API documentation    | T005         | T007, T008    | Pending |

### TDD Checklist

- [ ] ✅ Each implementation task has a corresponding test task that comes FIRST
- [ ] ✅ Test tasks have no dependencies on their implementation tasks
- [ ] ✅ Tests define expected behavior before code exists

### Categories

- **INFRA**: Infrastructure, database, configuration
- **DOMAIN**: Business logic, entities, services
- **API**: Controllers, DTOs, middleware
- **UI**: Frontend components, forms
- **TEST**: Unit and integration tests
- **DOC**: Documentation updates

### Status Legend

- **Pending**: Not started
- **In Progress**: Currently being worked on
- **Blocked**: Waiting on dependency or external factor
- **Review**: Code complete, awaiting review
- **Done**: Completed and tested
- **Deferred**: Postponed to future iteration
