# S-Tier SaaS Dashboard Design Principles

## Core Philosophy

- **Users First**: Prioritize user needs, workflows, and ease of use
- **Meticulous Craft**: Precision and polish in every UI element
- **Speed & Performance**: Fast load times and responsive interactions
- **Simplicity & Clarity**: Clean, uncluttered interfaces
- **Focus & Efficiency**: Help users achieve goals with minimal friction
- **Consistency**: Uniform design language across the dashboard
- **Accessibility**: WCAG AA+ compliance as minimum standard
- **Opinionated Defaults**: Clear, efficient workflows reducing decision fatigue

## Design System Foundation

### Colors

- Primary brand color (user-specified, used strategically)
- Neutral scale: 5-7 steps of gray for text, backgrounds, borders
- Semantic colors: Success (green), Error (red), Warning (yellow/amber), Info (blue)
- Dark mode palette with accessible contrast
- All combinations meet WCAG AA contrast ratios (4.5:1 minimum)

### Typography

- Primary font: Clean sans-serif (Geist, Inter, Manrope, system-ui)
- Modular scale:
  - H1: 32px
  - H2: 24px
  - H3: 20px
  - H4: 16px
  - Body Large: 18px
  - Body Medium: 14-16px (default)
  - Body Small/Caption: 12px
- Font weights: Regular (400), Medium (500), SemiBold (600), Bold (700)
- Line height: 1.5-1.7 for body text

### Spacing

- Base unit: 8px
- Scale: 4px, 8px, 12px, 16px, 24px, 32px, 48px
- Apply consistently for padding, margins, and layout

### Borders

- Small radius: 4-6px (inputs, buttons)
- Medium radius: 8-12px (cards, modals)

### Core Components

All with states: default, hover, active, focus, disabled

- Buttons: primary, secondary, tertiary/ghost, destructive, link-style (with/without icons)
- Inputs: text, textarea, select, date picker (with labels, placeholders, helper text, error messages)
- Form controls: checkboxes, radio buttons, toggles/switches
- Cards: content blocks, dashboard widgets
- Tables: clear headers, sorting, filtering support
- Modals/Dialogs: confirmations, forms, detailed views
- Navigation: sidebar, tabs
- Badges/Tags: status indicators, categorization
- Tooltips: contextual help
- Progress indicators: spinners, progress bars
- Icons: single, modern, clean SVG icon set
- Avatars

## Layout & Structure

- Responsive 12-column grid system
- Strategic white space for clarity and reduced cognitive load
- Clear visual hierarchy via typography, spacing, and positioning
- Consistent element alignment
- Standard layout:
  - Persistent left sidebar for primary navigation
  - Main content area for module-specific interfaces
  - Optional top bar for global search, profile, notifications
- Mobile-first responsive design

## Interaction Design

- Micro-interactions: subtle animations for user actions (150-300ms, ease-in-out)
- Immediate and clear feedback
- Loading states: skeleton screens for pages, spinners for components
- Smooth transitions for state changes
- Full keyboard navigation support with clear focus states

## CSS Architecture

- Utility-first approach (Tailwind CSS recommended)
- Design tokens integrated in configuration
- BEM with Sass as alternative
- CSS-in-JS for scoped styles when needed
- Maintainable, performant, and well-organized code

## Best Practices

- Iterative design with user testing
- Clear information architecture
- Fully responsive across all devices
- Comprehensive design system documentation

For module-specific guidelines and detailed implementation, consult @agent-design-review
