---
name: feature:prd
description: Generate comprehensive Product Requirements Document through multi-agent collaboration
agents:
  [
    product-manager-prd,
    business-analyst,
    ux-ui-designer,
    software-architect,
    tech-lead-reviewer,
    domain-expert-validator,
    tdd-test-engineer,
  ]
color: green
---

You are a PRD orchestrator that coordinates multiple agents to transform discovery insights into actionable requirements.

## Delegation Format

```bash
@agent-product-manager-prd "Lead PRD creation for: {feature-slug}"
@agent-business-analyst "Gather and structure requirements"
@agent-ux-ui-designer "Define UX requirements and user journeys"
@agent-software-architect "Evaluate technical feasibility"
@agent-tech-lead-reviewer "Assess implementation complexity"
@agent-domain-expert-validator "Validate business rules"
@agent-tdd-test-engineer "Identify testability requirements"
```

## Orchestration Workflow

### Step 1: Kickoff & Context Setting

**@agent-product-manager-prd** coordinates initial session:

- Reviews discovery outputs
- Sets collaboration objectives
- Defines scope boundaries
- Establishes timeline

All agents review context and prepare domain-specific questions.

### Step 2: Requirements Elicitation Workshop

Multi-agent deep dive into requirements:

**@agent-business-analyst** leads requirements gathering:

- Functional requirements mapping
- Process flow definition
- Use case scenarios
- Acceptance criteria

**@agent-ux-ui-designer** contributes:

- User journey mapping
- Interaction patterns
- Accessibility requirements
- Visual hierarchy needs

**@agent-product-manager-prd** captures:

- Business objectives
- Success metrics
- Market positioning
- Stakeholder priorities

### Step 3: Technical Feasibility Analysis

**@agent-software-architect** evaluates:

- System integration points
- Architecture implications
- Performance requirements
- Scalability considerations

**@agent-tech-lead-reviewer** assesses:

- Implementation complexity
- Risk factors
- Resource requirements
- Timeline feasibility

**@agent-tdd-test-engineer** identifies:

- Testability requirements
- Quality gates
- Edge cases
- Test data needs

### Step 4: Domain Validation

**@agent-domain-expert-validator** performs deep review:

- Business rule validation
- Compliance requirements
- Industry standards alignment
- Exception scenarios
- Data integrity rules

### Step 5: PRD Construction

**@agent-product-manager-prd** consolidates all inputs:

- Synthesizes multi-agent insights
- Structures requirements hierarchically
- Prioritizes features (MVP, Phase 2, Phase 3)
- Documents decisions and trade-offs

### Step 6: Collaborative Review

All agents review draft PRD:

- **@agent-business-analyst**: Validates completeness
- **@agent-ux-ui-designer**: Confirms UX requirements
- **@agent-software-architect**: Reviews technical constraints
- **@agent-tech-lead-reviewer**: Assesses feasibility
- **@agent-tdd-test-engineer**: Validates testability
- **@agent-domain-expert-validator**: Confirms business accuracy

### Step 7: Iteration & Refinement

Based on review feedback:

- Address identified gaps
- Resolve conflicts
- Clarify ambiguities
- Update priorities
- Finalize document

## Output Structure

```
docs/features/[feature-slug]/
├── discovery.md        # Problem & research (from discovery phase)
└── prd.md             # Product Requirements Document
```

## PRD Sections Generated

1. **Executive Summary**

   - Problem statement
   - Solution overview
   - Business value

2. **Goals & Success Metrics**

   - Measurable objectives
   - KPIs
   - Business outcomes

3. **User Stories**

   - Primary personas
   - User scenarios
   - Jobs to be done

4. **Core Features**

   - Functional requirements
   - Feature descriptions
   - Priority levels

5. **User Experience**

   - User flows
   - Interaction design
   - Accessibility needs

6. **Technical Constraints**

   - Integration requirements
   - Performance targets
   - Security requirements

7. **Non-Goals**

   - Out of scope items
   - Future considerations

8. **Phased Rollout**

   - MVP definition
   - Phase 2 enhancements
   - Phase 3 optimizations

9. **Risks & Mitigations**
   - Identified risks
   - Mitigation strategies
   - Contingency plans

## Quality Checks

- [ ] All user stories have acceptance criteria
- [ ] Success metrics are measurable
- [ ] Technical constraints are validated
- [ ] Domain rules are accurately represented
- [ ] UX requirements are comprehensive
- [ ] Testability is confirmed
- [ ] Stakeholder alignment achieved

## Templates Used

- `.claude/templates/prd-template.md`

## Next Step

Proceed to `/feature:techspec` to create technical specifications based on the PRD.
