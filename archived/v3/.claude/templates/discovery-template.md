---
feature-slug: [feature-name]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
facilitator: business-analyst
participants:
  - product-manager
  - ux-designer
  - tech-lead
  - domain-expert
---

# Feature Discovery: [Feature Name]

<guidelines>
**Focus**: Transform user demands into validated problem statements. WHY before WHAT.
**Research**: Use Perplexity → Exa Search → MCP Ref → Context7 for domain validation.
**Outcome**: Clear demand ready for PRD transformation.
**Hierarchy**: Discovery level - problem validation only. See `~/.claude/docs/hierarchy-guide.md` for boundaries.
</guidelines>

<demand-context>
**Original Request**: [Raw user/stakeholder demand - feat/fix/refactor/mvp]
**Demand Type**: [Feature/Fix/Refactor/MVP]
**Requestor**: [Who requested this and their role/context]
**Business Context**: [Why now? What triggered this request?]
</demand-context>

<discovery-qa>
**Q**: What specific problem are users experiencing?
**A**: [Direct response from discovery interview]

**Q**: Who exactly has this problem and in what context?
**A**: [Target user details and usage scenarios]

**Q**: What job are users trying to accomplish?
**A**: [Jobs to be Done - desired outcome, not features]

**Q**: What evidence shows this is a real problem worth solving?
**A**: [Data, feedback, metrics, user quotes]

**Q**: What happens if we don't solve this?
**A**: [Cost of inaction - business/user impact]

**Q**: How will we know if we've solved it successfully?
**A**: [Success indicators and measurement approach]
</discovery-qa>

<problem-validation>
**Core Problem**: [Single sentence problem statement]
**Target Users**: [Primary user type experiencing this problem]
**Evidence**: [Quantified proof this problem exists and matters]
**Impact**: [Business/user value of solving this problem]
</problem-validation>

<scope-boundaries>
**In Scope** (Core Problem):
- [Essential capability 1]
- [Essential capability 2]

**Out of Scope** (Future/Not Now):
- [Feature X]: [Why excluded - complexity/priority/timing]
- [Feature Y]: [Planned for later phase]
</scope-boundaries>

<critical-assumptions>
- [Key assumption about user behavior/needs]
- [Technical/business assumption requiring validation]
- [Market/regulatory assumption affecting solution]
</critical-assumptions>

<validation-plan>
- [ ] **User Assumption**: [What to validate] → [Method/Who/When]
- [ ] **Technical Assumption**: [What to validate] → [Spike/Research needed]
- [ ] **Business Assumption**: [What to validate] → [Data/Stakeholder to confirm]
</validation-plan>

<readiness-check>
- [ ] Problem clearly defined with evidence
- [ ] Target users identified and accessible
- [ ] Success criteria established
- [ ] Critical assumptions documented
- [ ] Next validation steps planned

**Ready for PRD**: [Yes/No - why?]
**Confidence Level**: [High/Medium/Low]
</readiness-check>
