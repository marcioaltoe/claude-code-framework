# React + Vite + Tailwind (v4) Standards

## Component Architecture

### Component Type

- Use **functional components** only
- Leverage React Hooks for state and lifecycle
- Never use class components

### File Structure

- TypeScript with `.tsx` extension for all React components
- One component per file (preferred)
- Group related components by feature folders

## State Management

### Principles

- Keep state as close as possible to where it's used
- Lift state up only when necessary
- Prefer local component state; use Context sparingly for cross-cutting concerns

### Props Passing

- Pass props explicitly; avoid spread operator for props

```tsx
// ✅ Good
<UserProfile 
  name={user.name} 
  email={user.email} 
  avatar={user.avatar} 
/>

// ❌ Avoid
<UserProfile {...user} />
```

### Global State

- Use **Context API** for cross-component communication
- Keep contexts focused and small
- Consider state management libraries only for complex applications

## Code Organization

### Component Size

- Keep components under 300 lines
- Extract logic into custom hooks
- Split large components into smaller, focused ones

### Component Granularity

- Avoid excessive component fragmentation
- Balance between reusability and simplicity
- Create components with clear, single responsibilities

## Styling

### Tailwind CSS v4

- Use utility classes exclusively
- Avoid CSS-in-JS and styled-components
- Co-locate minor component-specific styles if needed

```tsx
function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded font-medium transition-colors'
  const variantStyles = {
    primary: 'bg-blue-500 text-white hover:bg-blue-600',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
  }

  return (
    <button 
      className={`${baseStyles} ${variantStyles[variant]}`} 
      onClick={onClick}
    >
      {label}
    </button>
  )
}
```

## Data Fetching

### API Communication

- Always use **React Query** (TanStack Query) for API calls and caching
- Use native `fetch` inside `queryFn`
- Throw on non-2xx responses for proper error handling

### Provider Setup

```tsx
// src/providers.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { 
      staleTime: 5 * 60 * 1000, // 5 minutes
      retry: 1 
    },
  },
})

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}
```

### Usage in Components/Hooks

```tsx
import { useQuery } from '@tanstack/react-query'

function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const res = await fetch('/api/users')
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      return (await res.json()) as User[]
    },
    staleTime: 5 * 60 * 1000,
  })
}

function UserList() {
  const { data: users, isLoading, error } = useUsers()

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  return (
    <div>
      {users?.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  )
}
```

## Performance Optimization

### Memoization

- Use `useMemo` for expensive calculations
- Use `useCallback` for stable callback references
- Don't overuse - profile first

```tsx
function ExpensiveComponent({ data }: { data: DataItem[] }) {
  const processedData = useMemo(() => {
    return data.map((item) => ({
      ...item,
      computed: expensiveCalculation(item),
    }))
  }, [data])

  const handleClick = useCallback((id: string) => {
    // Handle click logic
  }, [])

  return <DataDisplay data={processedData} onClick={handleClick} />
}
```

### React.memo

- Use for components that re-render frequently with same props
- Combine with `useMemo` and `useCallback` for effectiveness

## Custom Hooks

### Naming Convention

- Always prefix custom hooks with "use"
- Examples: `useAuth`, `useLocalStorage`, `useDebounce`

### Example

```tsx
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key)
      return item ? JSON.parse(item) : initialValue
    } catch (error) {
      return initialValue
    }
  })

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value
      setStoredValue(valueToStore)
      window.localStorage.setItem(key, JSON.stringify(valueToStore))
    } catch (error) {
      console.error(`Error saving to localStorage: ${error}`)
    }
  }

  return [storedValue, setValue] as const
}
```

## UI Components

### Component Library

- Prefer existing components in `src/components/ui` and related folders
- Follow existing design tokens and patterns
- Use **Shadcn UI** components when available
- Customize themes through Tailwind configuration

### Third-Party Libraries

- Research existing solutions before creating from scratch
- Prefer well-maintained, popular libraries
- Always validate library choice with team

## Tooling

### Build Configuration

- Vite configuration lives in `vite.config.ts`
- Include React and Tailwind plugins
- Follow project-specific build optimizations

### Linting

- ESLint configured via `eslint.config.js`
- Keep rules aligned with TypeScript and React 19
- Follow team conventions for rule overrides

## TypeScript Integration

### Type Safety

- Define interfaces for all props
- Use proper TypeScript types throughout
- Avoid `any` type; use `unknown` when necessary

```tsx
interface UserCardProps {
  user: {
    id: string
    name: string
    email: string
    avatar?: string
  }
  onSelect?: (userId: string) => void
  isSelected?: boolean
}

function UserCard({ user, onSelect, isSelected = false }: UserCardProps) {
  return (
    <div
      className={`p-4 border rounded ${
        isSelected ? 'border-blue-500' : 'border-gray-200'
      }`}
      onClick={() => onSelect?.(user.id)}
    >
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  )
}
```

### Utility Types

- Reuse utility types where available
- Create shared type definitions for common patterns
- Use proper generic constraints

## Testing

### Testing Requirements

- Create automated tests for all components
- Test user interactions and edge cases
- Use React Testing Library

```tsx
import { render, screen, fireEvent } from '@testing-library/react'

describe('Button', () => {
  it('should call onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<Button label="Click me" onClick={handleClick} />)

    const button = screen.getByText('Click me')
    fireEvent.click(button)

    expect(handleClick).toHaveBeenCalledTimes(1)
  })
})
```

## Best Practices Summary

1. **Functional components** with TypeScript
2. **State management** close to usage
3. **Tailwind CSS** for styling
4. **React Query** for data fetching and caching
5. **Performance optimization** with useMemo/useCallback when needed
6. **Custom hooks** for reusable logic
7. **UI consistency** with existing component patterns
8. **Strong type safety** throughout
9. **Comprehensive testing** for reliability
10. **Modern tooling** with Vite and ESLint