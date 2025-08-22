# React + Vite + Tailwind v4 + ShadcnUI + TanStack Router Standards

## Component Architecture

### Component Type

- Use **functional components** only
- Leverage React Hooks for state and lifecycle
- Never use class components

### File Structure

- TypeScript with `.tsx` extension for all React components
- One component per file (preferred)
- Group related components by feature folders

### Component Organization

```
src/
├── components/
│   ├── ui/                    # Base UI components (Button, Input, Modal)
│   ├── layout/                # Layout components (Header, Sidebar, Footer)
│   └── common/                # Shared business components
├── features/
│   ├── auth/
│   │   ├── components/        # Feature-specific components
│   │   ├── hooks/             # Feature-specific hooks
│   │   └── types/             # Feature-specific types
│   └── dashboard/
│       ├── components/
│       ├── hooks/
│       └── types/
└── pages/                     # Page-level components
```

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

### Component Hierarchy Patterns

#### 1. Atomic Design Approach

```tsx
// Atoms - Basic building blocks
export function Button({ children, ...props }: ButtonProps) {
  return (
    <button className="btn" {...props}>
      {children}
    </button>
  );
}

// Molecules - Groups of atoms
export function SearchInput({ onSearch }: SearchInputProps) {
  return (
    <div className="flex gap-2">
      <Input placeholder="Search..." />
      <Button onClick={onSearch}>Search</Button>
    </div>
  );
}

// Organisms - Groups of molecules
export function UserCard({ user }: UserCardProps) {
  return (
    <Card>
      <Avatar src={user.avatar} />
      <UserInfo user={user} />
      <ActionButtons userId={user.id} />
    </Card>
  );
}
```

#### 2. Container/Presentational Pattern

```tsx
// Container - Logic and state
export function UserListContainer() {
  const { data: users, isLoading } = useUsers();

  const handleUserSelect = (userId: string) => {
    // Handle selection logic
  };

  return (
    <UserListPresentation
      users={users}
      isLoading={isLoading}
      onUserSelect={handleUserSelect}
    />
  );
}

// Presentation - Pure UI
export function UserListPresentation({
  users,
  isLoading,
  onUserSelect,
}: Props) {
  if (isLoading) return <LoadingSpinner />;

  return (
    <div className="grid gap-4">
      {users?.map((user) => (
        <UserCard key={user.id} user={user} onSelect={onUserSelect} />
      ))}
    </div>
  );
}
```

## Styling

### Tailwind CSS v4

- Use **Tailwind CSS v4** exclusively
- Use utility classes only - avoid CSS-in-JS and styled-components
- Configure using `@theme` directive directly in CSS (no more `tailwind.config.ts`)
- Use CSS variables for dynamic theming
- Co-locate minor component-specific styles if needed

```css
/* styles/globals.css */
@import "tailwindcss";

@theme {
  --font-display: "Satoshi", "sans-serif";
  --breakpoint-3xl: 1920px;
  --color-primary-100: oklch(0.99 0 0);
  --color-primary-500: oklch(0.84 0.18 117.33);
  --color-primary-900: oklch(0.53 0.12 118.34);
  --ease-fluid: cubic-bezier(0.3, 0, 0, 1);
}
```

### ShadcnUI Integration

- Use **ShadcnUI** components as base building blocks
- Install components via CLI: `npx shadcn@latest add button`
- Customize theme through `components.json` configuration
- Extend base components when needed

```tsx
// Example: Extending ShadcnUI Button
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export function CustomButton({
  className,
  variant = "default",
  ...props
}: CustomButtonProps) {
  return (
    <Button
      className={cn("custom-styles", className)}
      variant={variant}
      {...props}
    />
  );
}
```

```tsx
function Button({ label, onClick, variant = "primary" }: ButtonProps) {
  const baseStyles = "px-4 py-2 rounded font-medium transition-colors";
  const variantStyles = {
    primary: "bg-blue-500 text-white hover:bg-blue-600",
    secondary: "bg-gray-200 text-gray-800 hover:bg-gray-300",
  };

  return (
    <button
      className={`${baseStyles} ${variantStyles[variant]}`}
      onClick={onClick}
    >
      {label}
    </button>
  );
}
```

## Routing

### TanStack Router

- Use **TanStack Router** for all routing needs
- Define routes with file-based routing structure
- Use type-safe navigation and params
- Implement route-level data loading

```tsx
// routes/index.tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  component: HomePage,
});

function HomePage() {
  return <div>Welcome to Home Page</div>;
}
```

### Route Structure

```
src/routes/
├── __root.tsx          # Root route with layout
├── index.tsx           # Home page (/)
├── about.tsx           # About page (/about)
├── users/
│   ├── index.tsx       # Users list (/users)
│   └── $userId.tsx     # User detail (/users/$userId)
└── _layout.tsx         # Shared layout route
```

### Navigation and Links

```tsx
import { Link, useNavigate } from "@tanstack/react-router";

// Declarative navigation
<Link to="/users/$userId" params={{ userId: "123" }}>
  View User
</Link>;

// Programmatic navigation
const navigate = useNavigate();
const handleClick = () => {
  navigate({ to: "/users/$userId", params: { userId: "123" } });
};
```

### Route Parameters and Search

```tsx
// Route definition with params
export const Route = createFileRoute("/users/$userId")({
  component: UserDetail,
  loader: ({ params }) => fetchUser(params.userId),
});

// Using params in component
function UserDetail() {
  const { userId } = Route.useParams();
  const user = Route.useLoaderData();

  return <div>User: {user.name}</div>;
}
```

## Data Fetching

### API Communication

- Always use **React Query** (TanStack Query) for API calls and caching
- Use native `fetch` inside `queryFn`
- Throw on non-2xx responses for proper error handling
- Integrate with TanStack Router for route-level data loading

### Provider Setup

```tsx
// src/providers.tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      retry: 1,
    },
  },
});

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
}
```

### Usage in Components/Hooks

```tsx
import { useQuery } from "@tanstack/react-query";

function useUsers() {
  return useQuery({
    queryKey: ["users"],
    queryFn: async () => {
      const res = await fetch("/api/users");
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return (await res.json()) as User[];
    },
    staleTime: 5 * 60 * 1000,
  });
}

function UserList() {
  const { data: users, isLoading, error } = useUsers();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      {users?.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
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
    }));
  }, [data]);

  const handleClick = useCallback((id: string) => {
    // Handle click logic
  }, []);

  return <DataDisplay data={processedData} onClick={handleClick} />;
}
```

### React.memo

- Use for components that re-render frequently with same props
- Combine with `useMemo` and `useCallback` for effectiveness

## Composition Patterns

### Component Composition

#### 1. Children Pattern

```tsx
// Flexible container component
export function Card({ children, className = "" }: CardProps) {
  return (
    <div className={`bg-white rounded-lg shadow-md p-4 ${className}`}>
      {children}
    </div>
  );
}

// Usage
<Card>
  <h2>User Profile</h2>
  <UserAvatar user={user} />
  <UserDetails user={user} />
</Card>;
```

#### 2. Render Props Pattern

```tsx
export function DataFetcher<T>({
  url,
  children,
}: {
  url: string;
  children: (
    data: T | null,
    loading: boolean,
    error: string | null
  ) => React.ReactNode;
}) {
  const { data, isLoading, error } = useQuery({
    queryKey: [url],
    queryFn: () => fetch(url).then((res) => res.json()),
  });

  return <>{children(data, isLoading, error?.message || null)}</>;
}

// Usage
<DataFetcher<User[]> url="/api/users">
  {(users, loading, error) => {
    if (loading) return <LoadingSpinner />;
    if (error) return <ErrorMessage error={error} />;
    return <UserList users={users} />;
  }}
</DataFetcher>;
```

#### 3. Compound Components Pattern

```tsx
// Main component
export function Tabs({ children, defaultTab }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultTab)

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  )
}

// Sub-components
Tabs.List = function TabsList({ children }: { children: React.ReactNode }) {
  return <div className="flex border-b">{children}</div>
}

Tabs.Tab = function Tab({ id, children }: TabProps) {
  const { activeTab, setActiveTab } = useTabsContext()
  return (
    <button
      className={`px-4 py-2 ${activeTab === id ? 'border-b-2' : ''}`}
      onClick={() => setActiveTab(id)}
    >
      {children}
    </button>
  )
}

Tabs.Panel = function TabPanel({ id, children }: TabPanelProps) {
  const { activeTab } = useTabsContext()
  if (activeTab !== id) return null
  return <div className="p-4">{children}</div>
}

// Usage
<Tabs defaultTab="profile">
  <Tabs.List>
    <Tabs.Tab id="profile">Profile</Tabs.Tab>
    <Tabs.Tab id="settings">Settings</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel id="profile">
    <UserProfile />
  </Tabs.Panel>
  <Tabs.Panel id="settings">
    <UserSettings />
  </Tabs.Panel>
</Tabs>
```

#### 4. Higher-Order Components (HOCs) - Use Sparingly

```tsx
// Prefer custom hooks, but HOCs for cross-cutting concerns
export function withAuth<P extends object>(Component: React.ComponentType<P>) {
  return function AuthenticatedComponent(props: P) {
    const { user, isLoading } = useAuth();

    if (isLoading) return <LoadingSpinner />;
    if (!user) return <LoginPrompt />;

    return <Component {...props} />;
  };
}

// Usage
const ProtectedDashboard = withAuth(Dashboard);
```

## Custom Hooks

### Naming Convention

- Always prefix custom hooks with "use"
- Examples: `useAuth`, `useLocalStorage`, `useDebounce`

### Example

```tsx
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      return initialValue;
    }
  });

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore =
        value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(`Error saving to localStorage: ${error}`);
    }
  };

  return [storedValue, setValue] as const;
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

### Vite Configuration

- Use **Vite** as the build tool and dev server
- Configuration in `vite.config.ts` with TypeScript
- Include essential plugins: React, TanStack Router, Tailwind CSS
- Configure path aliases and environment variables

```typescript
// vite.config.ts
import { resolve } from "node:path";

import tailwindcss from "@tailwindcss/vite";
import { tanstackRouter } from "@tanstack/router-plugin/vite";
import viteReact from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    tanstackRouter({ autoCodeSplitting: true }),
    viteReact(),
    tailwindcss(),
  ],
  test: {
    globals: true,
    environment: "jsdom",
  },
  resolve: {
    alias: {
      "@": resolve(__dirname, "./src"),
    },
  },
});
```

### Development Experience

- Hot Module Replacement (HMR) enabled by default
- Fast refresh for React components
- TypeScript type checking in development
- Source maps for debugging

### Build Optimization

- Tree shaking for smaller bundles
- Code splitting by routes (TanStack Router)
- Asset optimization and compression
- Environment-specific builds

### Linting and Formatting

- Biome configured via `biome.json`
- Keep rules aligned with TypeScript and React 19
- Integrate with Prettier for consistent formatting
- Pre-commit hooks with Husky and lint-staged

```json
// package.json scripts
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "biome lint .",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "tailwindcss": "^4.0.0",
    "@tailwindcss/vite": "^4.0.0"
  }
}
```

## TypeScript Integration

### Type Safety

- Define interfaces for all props
- Use proper TypeScript types throughout
- Avoid `any` type; use `unknown` when necessary

```tsx
interface UserCardProps {
  user: {
    id: string;
    name: string;
    email: string;
    avatar?: string;
  };
  onSelect?: (userId: string) => void;
  isSelected?: boolean;
}

function UserCard({ user, onSelect, isSelected = false }: UserCardProps) {
  return (
    <div
      className={`p-4 border rounded ${
        isSelected ? "border-blue-500" : "border-gray-200"
      }`}
      onClick={() => onSelect?.(user.id)}
    >
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  );
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
import { render, screen, fireEvent } from "@testing-library/react";

describe("Button", () => {
  it("should call onClick when clicked", () => {
    const handleClick = jest.fn();
    render(<Button label="Click me" onClick={handleClick} />);

    const button = screen.getByText("Click me");
    fireEvent.click(button);

    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

## Component Design Principles

### 1. Single Responsibility Principle

```tsx
// ❌ Bad: Component doing too much
function UserDashboard() {
  // User data fetching
  // Analytics calculation
  // Notification handling
  // UI rendering
}

// ✅ Good: Separated concerns
function UserDashboard() {
  return (
    <div>
      <UserProfile />
      <UserAnalytics />
      <NotificationCenter />
    </div>
  );
}
```

### 2. Prop Interface Design

```tsx
// ✅ Good: Clear, focused props
interface ButtonProps {
  variant: "primary" | "secondary" | "danger";
  size: "sm" | "md" | "lg";
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}

// ❌ Avoid: Generic, unclear props
interface ButtonProps {
  style?: any;
  config?: any;
  data?: any;
}
```

### 3. Barrel Exports for Clean Imports

```tsx
// components/ui/index.ts
export { Button } from "./Button";
export { Input } from "./Input";
export { Modal } from "./Modal";
export type { ButtonProps, InputProps, ModalProps } from "./types";

// Usage
import { Button, Input, Modal } from "@/components/ui";
```

### 4. Component Variants Pattern

```tsx
// Base component with variants
const buttonVariants = {
  variant: {
    primary: "bg-blue-500 text-white hover:bg-blue-600",
    secondary: "bg-gray-200 text-gray-800 hover:bg-gray-300",
    danger: "bg-red-500 text-white hover:bg-red-600",
  },
  size: {
    sm: "px-2 py-1 text-sm",
    md: "px-4 py-2 text-base",
    lg: "px-6 py-3 text-lg",
  },
};

export function Button({
  variant = "primary",
  size = "md",
  className = "",
  children,
  ...props
}: ButtonProps) {
  const variantClass = buttonVariants.variant[variant];
  const sizeClass = buttonVariants.size[size];

  return (
    <button
      className={`${variantClass} ${sizeClass} ${className} rounded transition-colors`}
      {...props}
    >
      {children}
    </button>
  );
}
```

## Best Practices Summary

1. **Functional components** with TypeScript
2. **TanStack Router** for type-safe routing and navigation
3. **Tailwind CSS v4** with `@config` directive for styling
4. **ShadcnUI** components as building blocks
5. **React Query** (TanStack Query) for data fetching and caching
6. **Vite** for fast development and optimized builds
7. **Performance optimization** with useMemo/useCallback when needed
8. **Custom hooks** for reusable logic
9. **Composition patterns** for flexible components
10. **Single responsibility** components
11. **Strong type safety** throughout
12. **Comprehensive testing** for reliability
13. **Modern tooling** with Biome and Prettier
14. **Atomic design** approach for component hierarchy

## Technology Stack

- **Frontend Framework**: React 19 with TypeScript
- **Build Tool**: Vite with HMR and fast refresh
- **Routing**: TanStack Router (file-based, type-safe)
- **Styling**: Tailwind CSS v4 with CSS variables
- **UI Components**: ShadcnUI with customizable themes
- **Data Fetching**: TanStack Query (React Query)
- **State Management**: React Context + local state
- **Testing**: React Testing Library + Vitest
- **Linting**: Biome + Prettier with pre-commit hooks
