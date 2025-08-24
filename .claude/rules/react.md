# React Standards

## Technology Stack

- **Frontend**: React 19 with TypeScript
- **Build**: Vite with HMR
- **Routing**: TanStack Router (file-based, type-safe)
- **Styling**: Tailwind CSS v4
- **UI Components**: ShadcnUI
- **Data Fetching**: TanStack Query
- **State**: Zustand
- **Testing**: Vitest + React Testing Library

## Key Principles

- Functional components only (no classes)
- TypeScript with `.tsx` for all React components
- One component per file
- Colocate tests in `__tests__` folders
- Keep components under 150 lines
- Extract logic into custom hooks when > 20 lines

## Folder Structure

```
src/
├── components/
│   ├── ui/         # Base UI components
│   ├── layout/     # Layout components
│   └── common/     # Shared business components
├── features/       # Feature modules
│   └── [feature]/
│       ├── components/
│       ├── hooks/
│       └── types/
└── routes/         # TanStack Router pages
```

## State Management

- Keep state as close as possible to where it's used
- Lift state only when necessary
- Server state: TanStack Query
- Client state: Local state or Context
- Form state: React Hook Form
- URL state: TanStack Router

## Performance

- Use React.memo only when measurable gains exist
- useMemo/useCallback judiciously - not by default
- Code splitting by routes
- Lazy load non-critical components

For implementation details, consult:

- @agent-react-coder for component development
- @agent-react-architect for architecture patterns
- @agent-ux-ui-designer for UI/UX decisions
