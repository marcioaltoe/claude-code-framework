---
feature-slug: [feature-name]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
priority: [high|medium|low]
---

# PRD: [Feature Name]

<guidelines>
**Focus**: Essential product decisions only. WHAT to build, not HOW.
**Research**: Use EXA Search → Perplexity → Ref MCP → Context7 pipeline for optimal cost/accuracy.
**Hierarchy**: This is PRD level - business value only. See `~/.claude/docs/hierarchy-guide.md` for Epic/Story/Task boundaries.
</guidelines>

<problem-solution>
**Problem**: [Specific pain point with quantified evidence]
**Users**: [Primary user type and key use case]
**Solution**: [What we're building - user value focus]
**Impact**: [Quantified business value - revenue/efficiency/satisfaction]
</problem-solution>

<success-metrics>
**Primary**: [Key metric] - [Baseline] → [Target] by [Date]
**Secondary**: [Supporting metric] - [Baseline → Target]
**Launch Criteria**: [Pass/fail threshold for MVP]
</success-metrics>

<user-stories>
<story priority="must-have">
**As a** [user type], **I want** [action] **so that** [outcome]
**Criteria**: Given [context], when [action], then [result]
</story>

<story priority="should-have">
**As a** [user type], **I want** [action] **so that** [outcome] 
**Criteria**: Given [context], when [action], then [result]
</story>
</user-stories>

<requirements>
**Must Have** (MVP - Unlocks Core Value):
- [ ] [Core feature 1]: [Measurable capability] - *Why MVP: [Enables core user value/No blocking dependencies]*
- [ ] [Core feature 2]: [Measurable capability] - *Why MVP: [Foundation for other features/User can achieve job-to-be-done]*

**Should Have** (Phase 2 - Value Add):
- [Feature A]: [Enhancement that builds on MVP] - *Why Later: [Depends on MVP learnings/Nice-to-have]*

**Out of Scope**:
- [Feature X]: [Why excluded - complexity exceeds value/not core to user journey]
- [Feature Y]: [Why deferred - requires significant technical foundation not in MVP]
</requirements>

<constraints-dependencies>
**Critical Dependencies**: [Blocking dependencies only]
**Key Constraints**: [Performance, compliance, technical, timeline - essential only]
</constraints-dependencies>

<high-impact-risks>
- **Risk**: [Major concern] → **Mitigation**: [Action plan]
- **Risk**: [Critical blocker] → **Mitigation**: [Fallback approach]
</high-impact-risks>

<timeline>
**MVP Target**: [X weeks] - [Key deliverable]
**Validation**: [Y weeks post-launch] - [Success evaluation]
</timeline>

<open-questions>
- [ ] [Critical question] - Owner: [Name] Deadline: [Date]
- [ ] [Blocking decision] - Owner: [Team] Deadline: [Date]
</open-questions>

<readiness-check>
- [ ] Problem defined with evidence
- [ ] Success metrics with baselines
- [ ] Must-have features scoped
- [ ] High-impact risks mitigated

**Ready for TechSpec**: [Yes/No - why?]
</readiness-check>
