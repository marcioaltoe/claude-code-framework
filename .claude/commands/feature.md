---
name: feature
description: 'Unified feature management and navigation commands'
type: utility
category: management
complexity: simple
scope: project

# Activation Configuration
activation:
  manual-commands: ['/feature', '/feat']
  flags: ['--feature', '--feat']
  auto-detect: []

# Integration Configuration
framework-integration:
  commands:
    - feature-discovery
    - feature-prd
    - feature-techspec
    - feature-tasks
  output-location: 'docs/features/'

# Performance Profile
performance-profile: lightweight
performance-targets:
  execution-time: '<1s'
---

# /feature - Feature Management Command

**Unified feature management, navigation, and status tracking** - Central command for managing the entire feature development lifecycle.

## Purpose

Provides centralized management for features, including navigation, status tracking, listing, and lifecycle orchestration. Acts as the hub for all feature-related operations.

## Usage

```bash
/feature list                         # List all features
/feature status [slug]                # Show feature status
/feature go [slug]                    # Navigate to feature folder
/feature tree [slug]                  # Show feature structure
/feature init "idea"                  # Start new feature (runs discovery)
/feature clean [slug]                 # Clean old drafts
/feature archive [slug]               # Archive completed feature
```

## Subcommands

### list - List All Features
```bash
/feature list [--status STATUS]       # List features, optionally filter by status
```
Shows all features in `docs/features/` with their current status:
- 🔵 Discovery - In discovery phase
- 🟡 Requirements - PRD being created/reviewed
- 🟠 Technical - Tech spec in progress
- 🟢 Implementation - Tasks being executed
- ✅ Complete - Feature completed
- 📦 Archived - Feature archived

### status - Feature Status
```bash
/feature status [feature-slug]        # Show detailed feature status
```
Displays:
- Current phase and progress
- Completed documents
- Pending actions
- Team assignments
- Timeline information
- Recent activity

### go - Navigate to Feature
```bash
/feature go [feature-slug]            # Navigate to feature directory
```
Changes working directory to feature folder and shows structure.

### tree - Show Structure
```bash
/feature tree [feature-slug]          # Display feature file structure
```
Shows hierarchical view of all feature documents and their status.

### init - Initialize New Feature
```bash
/feature init "Feature description"   # Start new feature workflow
/feature init --type [feat|fix|refactor] "Description"
```
Initializes new feature by:
1. Generating appropriate slug
2. Creating feature directory structure
3. Running `/feature:discovery` command
4. Creating initial README.md

### clean - Clean Drafts
```bash
/feature clean [feature-slug]         # Remove draft/temporary files
```
Removes:
- Backup files (*~, *.bak)
- Temporary files (*.tmp)
- Old versions in archive/
- Empty directories

### archive - Archive Feature
```bash
/feature archive [feature-slug]       # Move completed feature to archive
```
Archives completed features to `docs/features/_archive/[feature-slug]/`

### workflow - Show Workflow
```bash
/feature workflow                     # Display feature development workflow
```
Shows the complete workflow with current command aliases:
1. `/feature:discovery` or `/feature:disc` - Discovery & Brief
2. `/feature:prd` - Product Requirements
3. `/feature:techspec` or `/feature:spec` - Technical Specification
4. `/feature:tasks` - Task Breakdown

## Feature README.md Template

Each feature gets an auto-generated README.md:

```markdown
---
feature: [feature-slug]
type: [feat|fix|refactor|perf]
status: [discovery|requirements|technical|implementation|complete|archived]
created: [timestamp]
updated: [timestamp]
---

# Feature: [Feature Name]

## Status: 🟡 Requirements

### Progress Tracker
- ✅ Discovery completed (2024-01-15)
- 🔄 PRD in review (2024-01-16)
- ⏳ Tech Spec pending
- ⏳ Tasks pending

### Quick Links
- [Brief](01-discovery/brief.md)
- [Research](01-discovery/research.md)
- [PRD](02-requirements/prd.md)
- [Tech Spec](03-technical/techspec.md)
- [Tasks](04-implementation/task-summary.md)

### Team
- Product Owner: @[user]
- Tech Lead: @[user]
- Developers: @[users]

### Timeline
- Start Date: [date]
- Target Date: [date]
- Current Sprint: [number]

### Recent Activity
- [timestamp]: Discovery completed
- [timestamp]: PRD draft created
- [timestamp]: Review requested

### Notes
[Any additional context or notes]
```

## Integration with Other Commands

The feature command integrates with the entire workflow:

```mermaid
graph TD
    A[feature init] --> B[/feature:discovery]
    B --> C[/feature:prd]
    C --> D[/feature:techspec]
    D --> E[/feature:tasks]
    E --> F[feature archive]
```

Each phase updates the feature README.md automatically.

## File Structure Management

### Standard Feature Structure
```
docs/features/
├── [feature-slug]/
│   ├── README.md                 # Auto-maintained status
│   ├── 01-discovery/
│   │   ├── brief.md
│   │   ├── research.md
│   │   └── qa-transcript.md
│   ├── 02-requirements/
│   │   ├── prd.md
│   │   └── decisions.md
│   ├── 03-technical/
│   │   ├── techspec.md
│   │   ├── architecture.md
│   │   └── diagrams/
│   └── 04-implementation/
│       ├── task-summary.md
│       ├── dependencies.md
│       └── tasks/
│           └── T*.md
└── _archive/                     # Archived features
```

## Status Tracking

### Automatic Status Updates
The following commands automatically update feature status:
- `/feature:discovery` → Status: Discovery
- `/feature:prd` → Status: Requirements
- `/feature:techspec` → Status: Technical
- `/feature:tasks` → Status: Implementation

### Manual Status Update
```bash
/feature status [slug] --set [status]
```

## Best Practices

1. **Always use init**: Start features with `/feature init` for proper setup
2. **Check status regularly**: Use `/feature status` to track progress
3. **Clean periodically**: Run `/feature clean` to remove drafts
4. **Archive when complete**: Use `/feature archive` for completed features
5. **Use consistent slugs**: Follow naming convention throughout

## Examples

### Starting a New Feature
```bash
/feature init "Add two-factor authentication"
# Creates: feat-auth-2fa
# Runs: /feature:discovery automatically
```

### Checking Progress
```bash
/feature list --status implementation
# Shows all features currently being implemented

/feature status feat-auth-2fa
# Shows detailed status of specific feature
```

### Navigation
```bash
/feature go feat-auth-2fa
# Navigates to: docs/features/feat-auth-2fa/

/feature tree feat-auth-2fa
# Shows complete file structure
```

### Cleanup
```bash
/feature clean feat-auth-2fa
# Removes temporary files

/feature archive feat-auth-2fa
# Moves to _archive/ when complete
```

## Error Handling

### Feature Not Found
- Suggests similar feature slugs
- Offers to list all features
- Provides init command hint

### Incomplete Prerequisites
- Shows what's missing
- Provides next command to run
- Updates status appropriately

### Conflicts
- Detects duplicate slugs
- Warns about existing features
- Suggests alternative names

## Related Documentation

- Workflow commands: `/feature:discovery`, `/feature:prd`, `/feature:techspec`, `/feature:tasks`
- Templates: `templates/`
- Archives: `docs/features/_archive/`