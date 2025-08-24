# Style Guide

## Design Token System

### Color Tokens (OKLCH)

```css
/* Light Theme */
--background: oklch(1 0 0)                        /* #FFFFFF */
--foreground: oklch(0.1708 0.0429 260.535)        /* #050F22 - Primary Dark */
--primary: oklch(0.6417 0.1596 255.5095)          /* #428DEB - Brand Blue */
--secondary: oklch(0.6903 0.1187 181.3207)        /* #1FB3A0 - Brand Teal */
--muted: oklch(0.85 0.005 260)                    /* #D6D5D6 - Light Gray */
--card: oklch(0.98 0.004 17)                      /* #F8F6F6 - Off White */
--border: oklch(0.85 0.005 260)                   /* #D6D5D6 */
--destructive: oklch(0.5771 0.2152 27.325)        /* Error red */

/* Dark Theme */
--background: oklch(0.1708 0.0429 260.535)        /* #050F22 - Primary Dark */
--foreground: oklch(0.98 0.004 17)                /* #F8F6F6 - Light text */
--card: oklch(0.2927 0.0503 260.2288)             /* #0D1E35 - Secondary Dark */
--sidebar: oklch(0.1708 0.0429 260.535)           /* Primary Dark for sidebar */
```

### Typography System

```css
--font-sans: "Geist", -apple-system, "Segoe UI", "Roboto", sans-serif
--font-mono: "Geist Mono", "SF Mono", Monaco, "Cascadia Code", monospace
--font-serif: "Lora", ui-serif, serif  /* Limited use */
```

**Font Classes:**

- `.font-brand` - Geist Regular for all UI text
- `.font-brand-mono` - Geist Mono for numbers and data (tabular-nums)

**Text Hierarchy:**

- `.text-display` - 32px (2rem) - Page titles
- `.text-title` - 24px (1.5rem) - Section headers
- `.text-heading` - 20px (1.25rem) - Subsections
- `.text-body` - 16px (1rem) - Default text
- `.text-caption` - 12px (0.75rem) - Helper text

### Component Classes

**Buttons:**

```css
.btn-primary    /* bg-primary text-primary-foreground hover:bg-primary/90 */
.btn-secondary  /* bg-secondary text-secondary-foreground hover:bg-secondary/90 */
.btn-outline    /* border-primary text-primary hover:bg-primary */
.btn-ghost /* hover:bg-accent hover:text-accent-foreground */
```

**Status:**

```css
.badge-success       /* bg-secondary text-secondary-foreground */
.badge-error         /* bg-destructive text-destructive-foreground */
.badge-neutral       /* bg-muted text-muted-foreground */
```

## Core Principles

### Semantic Token Usage

✅ **ALWAYS use semantic tokens**: `bg-primary`, `text-foreground`, `border-border`
❌ **NEVER hardcode colors**: `bg-[#428DEB]`, `text-white`, `border-gray-300`

### Dark Mode

- All components automatically adapt using semantic tokens
- No need for `dark:` variants when using semantic classes
- Sidebar maintains dark theme in both modes

### Shadows & Effects

```css
--shadow-sm: 0px 2px 4px 0px hsl(0 0% 0% / 0.1)
--shadow-md: 0px 2px 4px 0px hsl(0 0% 0% / 0.1), 0px 2px 4px -1px hsl(0 0% 0% / 0.1)
--shadow-lg: 0px 2px 4px 0px hsl(0 0% 0% / 0.1), 0px 4px 6px -1px hsl(0 0% 0% / 0.1)
--radius: 0.5rem  /* Default border radius */
```

### Chart Colors

```css
--chart-1: Brand Blue   /* Primary data */
--chart-2: Brand Teal   /* Secondary data */
--chart-3: Blue variant /* Additional series */
--chart-4: Teal variant /* Additional series */
--chart-5: Gray variant /* Additional series */
```

## Implementation Checklist

- [ ] Use semantic color tokens exclusively
- [ ] Test in both light and dark modes
- [ ] Verify WCAG AA+ contrast (4.5:1 minimum)

---

_For component examples, see @agent-react-coder_
_For architecture patterns, see @agent-react-architect_
_For design validation, use @agent-ux-ui-designer and @agent-react-design-review_
