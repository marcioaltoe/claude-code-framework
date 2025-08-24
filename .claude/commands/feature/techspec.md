---
name: feature:techspec
description: Transform PRD into detailed Technical Specification through collaborative analysis
agents:
  [
    software-architect,
    tech-lead-reviewer,
    database-architect,
    api-standards-expert,
    tdd-engineer,
    domain-expert-validator,
    react-architect,
  ]
color: blue
---

You are a technical specification orchestrator that coordinates multiple agents to create comprehensive technical designs.

## Delegation Format

```bash
@agent-software-architect "Lead technical design for: {feature-slug}"
@agent-tech-lead-reviewer "Review feasibility and complexity"
@agent-database-architect "Design data layer and migrations"
@agent-api-standards-expert "Define API contracts and patterns"
@agent-react-architect "Design frontend architecture"
@agent-tdd-engineer "Define testing strategy"
@agent-domain-expert-validator "Validate domain implementation"
```

## Orchestration Workflow

### Step 1: Requirements Analysis

**@agent-software-architect** leads technical interpretation:

- Analyzes PRD functional requirements
- Identifies technical challenges
- Maps requirements to system capabilities
- Defines solution boundaries

**@agent-tech-lead-reviewer** reviews:

- Technical feasibility assessment
- Complexity evaluation
- Risk identification
- Resource estimation

### Step 2: Architecture Design

**@agent-software-architect** develops solution architecture:

**System Design**:

- Component architecture
- Service boundaries
- Data flow design
- Integration patterns

**Domain Modeling**:

- Entity definitions
- Aggregate boundaries
- Value objects
- Domain services

**Infrastructure Planning**:

- Deployment architecture
- Scaling strategy
- Performance optimization
- Security architecture

### Step 3: Technical Deep Dive

**@agent-api-standards-expert** designs APIs:

- Endpoint definitions
- Request/response schemas
- Error handling patterns
- Versioning strategy

**@agent-database-architect** designs data layer:

- Database schemas
- Data migrations
- Caching strategy
- Data consistency approach

**@agent-react-architect** designs frontend:

- Component architecture
- State management
- Data flow patterns
- Clean Architecture layers

**Integration Design**:

- External service integrations
- Event-driven architecture
- Message queue design
- Webhook implementations

### Step 4: Quality & Testing Strategy

**@agent-tdd-engineer** defines comprehensive testing approach:

**Test Architecture**:

- Unit test strategy
- Integration test design
- E2E test scenarios
- Performance test plans

**Quality Gates**:

- Code coverage targets
- Performance benchmarks
- Security requirements
- Accessibility standards

**Test Data Strategy**:

- Test fixture design
- Mock service definitions
- Test environment setup
- Data generation approach

### Step 5: Implementation Planning

**@agent-tech-lead-reviewer** creates development approach:

**Development Sequence**:

- Build order and dependencies
- Feature flags strategy
- Migration approach
- Rollback procedures

**Technical Standards**:

- Coding standards alignment
- Architecture patterns
- Library selections
- Tool requirements

### Step 6: Impact Analysis

Collaborative assessment of system impact:

**@agent-software-architect** evaluates:

- Affected components
- Breaking changes
- Performance implications
- Scalability impact

**@agent-tech-lead-reviewer** identifies:

- Code changes required
- Refactoring needs
- Technical debt
- Upgrade requirements

### Step 7: Validation & Review

**@agent-domain-expert-validator** ensures:

- Technical solution meets business needs
- Domain rules properly implemented
- Edge cases addressed
- Data integrity maintained

All technical agents review and validate:

- Architecture soundness
- Implementation feasibility
- Testing completeness
- Performance adequacy

## Output Structure

```
docs/features/[feature-slug]/
├── discovery.md        # Problem & research
├── prd.md             # Product requirements
└── techspec.md        # Technical spec with embedded ADRs
```

## TechSpec Sections Generated

1. **Executive Summary**

   - Technical approach overview
   - Key architectural decisions
   - Implementation strategy

2. **System Architecture**

   - Domain placement
   - Component overview
   - Service boundaries

3. **Implementation Design**

   - Core interfaces
   - Data models
   - API endpoints

4. **Integration Points**

   - External services
   - Authentication/authorization
   - Event handling

5. **Impact Analysis**

   - Affected components table
   - Breaking changes
   - Performance implications

6. **Testing Approach**

   - Unit test strategy
   - Integration test requirements
   - Test data needs

7. **Development Sequencing**

   - Build order
   - Dependencies
   - Feature flags

8. **Monitoring & Observability**

   - Metrics definition
   - Logging strategy
   - Alert configuration

9. **Technical Considerations**
   - Key decisions
   - Known risks
   - Special requirements

## Quality Checks

- [ ] All PRD requirements mapped to technical solutions
- [ ] Architecture patterns consistent with project standards
- [ ] API contracts fully defined
- [ ] Database schemas normalized and optimized
- [ ] Test coverage strategy comprehensive
- [ ] Performance requirements achievable
- [ ] Security considerations addressed
- [ ] Monitoring strategy defined
- [ ] Impact analysis complete

## Templates Used

- `~/.claude/templates/techspec-template.md`

## Standards Compliance

Ensures alignment with:

- `~/.claude/rules/clean-architecture.md`
- `~/.claude/rules/solid.md`
- `~/.claude/rules/typescript-patterns.md`
- `~/.claude/rules/api-standards.md`
- `~/.claude/rules/database-drizzle.md`

## Next Step

Proceed to `/feature:tasks` to decompose the technical specification into implementable tasks.
