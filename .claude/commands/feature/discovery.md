---
name: feature-discovery
description: 'Interactive discovery and brief generation for feature development'
type: feature-component
category: documentation
complexity: standard
scope: project

# Activation Configuration
activation:
  manual-commands: ['/feature:discovery']
  flags: ['--discovery', '--disc']
  auto-detect: ['idea.md', 'demand.md', 'bug-report.md']

# Integration Configuration
framework-integration:
  agents:
    - domain-architect
    - ux-architect
    - business-strategist
  output-location: 'docs/features/'
  template: 'templates/discovery-template.md'

# Performance Profile
performance-profile: standard
performance-targets:
  discovery-time: '<3min'
  quality-score: '>0.80'
---

# /feature:discovery - Feature Discovery & Brief Generator

**Interactive discovery process for ideas, demands, and bugs** - Creates comprehensive brief through Q&A dialogue.

## Purpose

Transforms vague ideas, feature requests, or bug reports into structured briefs ready for PRD generation. Uses interactive Q&A with specialized agents to clarify requirements and discover hidden needs.

## Usage

```bash
/feature:discovery "Your idea or feature request"
/feature:discovery --file idea.md     # From file
/feature:discovery --bug "Bug description"  # Bug report mode
```

## Parameters

### Required (one of)
- **idea**: Direct text description of idea/demand/bug
- **--file [path]**: Path to file containing the initial description
- **--bug [description/link]**: Bug report or issue link

### Optional
- **--feature-slug [name]**: Custom folder name (default: auto-generated)
- **--depth [quick|standard|deep]**: Discovery depth (default: standard)
- **--max-questions [n]**: Maximum Q&A rounds (default: 10)

## Workflow

### 1. Initialization
```yaml
action: Parse input and prepare discovery session
steps:
  - Parse initial idea/demand/bug
  - Generate feature-slug if not provided
  - Determine feature type prefix (feat/fix/refactor/perf)
  - Create folder: docs/features/[feature-slug]/01-discovery/
  - Initialize Q&A session
  - Create initial README.md with status
```

### 2. Initial Analysis
```yaml
action: Analyze input to identify gaps and ambiguities
outputs:
  - Key concepts identified
  - Ambiguous areas flagged
  - Question priorities set
```

### 3. Domain Discovery
```yaml
agent: domain-architect
action: Explore domain concepts and boundaries
questions:
  - What are the core entities involved?
  - What business rules apply?
  - What are the system boundaries?
  - What integrations are needed?
outputs:
  - Domain model sketch
  - Bounded contexts identification
```

### 4. User Experience Discovery
```yaml
agent: ux-architect
action: Understand user needs and journeys
questions:
  - Who are the users?
  - What are their goals?
  - What's the current pain point?
  - What would success look like?
outputs:
  - User personas
  - User journey outline
  - Success criteria
```

### 5. Business Context Discovery
```yaml
agent: business-strategist
action: Understand business value and constraints
questions:
  - What's the business goal?
  - What's the expected ROI?
  - What are the constraints?
  - What's the timeline?
outputs:
  - Business objectives
  - Constraints and limitations
  - Success metrics
```

### 6. Synthesis & Brief Generation
```yaml
action: Compile discoveries into structured brief
outputs:
  - brief.md: Executive summary
  - research.md: Complete discovery document
  - qa-transcript.md: Full Q&A log
  - Update README.md with discovery completion
metadata:
  - Add YAML frontmatter to all documents
  - Include version, status, timestamps
```

## Output Structure

```
docs/features/[feature-slug]/
├── README.md                 # Feature status and index
└── 01-discovery/
    ├── brief.md             # Executive summary
    ├── research.md          # Complete discovery document  
    └── qa-transcript.md     # Full Q&A transcript
```

## Document Structures

### brief.md (Executive Summary)
```markdown
---
feature: [feature-slug]
document: brief
version: 1.0
status: draft
created: [timestamp]
author: /discover
tags: [relevant, tags]
---

# Brief: [Feature Name]

## Problem Statement
[Concise problem definition]

## Proposed Solution
[High-level solution approach]

## Success Criteria
[Key success metrics]

## Constraints
[Major limitations]

## Next Steps
[Immediate actions required]
```

### research.md (Complete Discovery)
```markdown
---
feature: [feature-slug]
document: research
version: 1.0
status: complete
created: [timestamp]
author: /discover
---

# Discovery Research: [Feature Name]

## Executive Summary
[Brief overview from discovery]

## Problem Statement
[Clear problem definition]

## Proposed Solution
[High-level solution approach]

## Domain Model
[Key entities and relationships]

## User Context
- **Personas**: [User types]
- **Goals**: [User objectives]
- **Pain Points**: [Current problems]

## Business Context
- **Objectives**: [Business goals]
- **Constraints**: [Limitations]
- **Success Metrics**: [KPIs]

## Technical Considerations
[High-level technical notes]

## Open Questions
[Remaining uncertainties]

## Next Steps
[Recommended actions]
```

## Interactive Q&A Process

### Question Types

1. **Clarifying Questions**: Resolve ambiguities
2. **Exploratory Questions**: Discover hidden requirements  
3. **Validation Questions**: Confirm understanding
4. **Scoping Questions**: Define boundaries

### Response Handling

- Accept text responses
- Support "I don't know" with follow-ups
- Allow skipping non-critical questions
- Provide examples when needed

## Quality Gates

### Discovery Completeness
- ✅ Problem clearly defined
- ✅ Users identified
- ✅ Success criteria established
- ✅ Scope boundaries set
- ✅ Key risks identified

### Brief Readiness
- Sufficient detail for PRD generation
- No critical ambiguities remaining
- Business value articulated
- Technical feasibility assessed

## Error Handling

### Insufficient Input
- Guide user with example questions
- Provide templates for common scenarios
- Suggest minimum viable information

### Q&A Timeout
- Save partial discovery
- Highlight gaps for later completion
- Provide actionable next steps

## Examples

### Basic Discovery
```bash
/discover "Need a way to track customer feedback"
```

### From Bug Report
```bash
/discover --bug "Users can't export data in CSV format"
```

### Deep Discovery
```bash
/discover --depth deep --max-questions 20 "Enterprise integration platform"
```

## Best Practices

1. **Be Specific**: More detail in answers leads to better briefs
2. **Think Broadly**: Consider edge cases and future needs
3. **Stay Focused**: Keep scope manageable
4. **Document Unknowns**: It's OK to have open questions

## Feature Slug Convention

Slugs follow pattern: `[type]-[domain]-[description]`

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code refactoring
- `perf` - Performance improvement
- `docs` - Documentation
- `test` - Testing improvement

**Examples**:
- `feat-auth-2fa-implementation`
- `fix-payments-stripe-webhook`
- `refactor-user-repository-pattern`
- `perf-search-elasticsearch`

## Integration with Next Steps

After discovery completion:
1. Review `01-discovery/brief.md` and `research.md`
2. Run `/feature:prd --from-discovery [feature-slug]` to generate PRD
3. PRD generation will use discovery outputs as foundation

## Related Documentation

- Next step: `/feature:prd` - Generate PRD from discovery
- Management: `/feature` - Feature orchestration commands
- Templates: `templates/discovery-template.md`
- Agents: Domain, UX, and Business architects