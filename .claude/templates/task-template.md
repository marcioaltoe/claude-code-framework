---
task-id: [task-number]
feature-slug: [feature-name]
status: pending # Options: pending, in-progress, completed, excluded
priority: [high|medium|low]
complexity: [low|medium|high]
estimated-hours: [number]
dependencies: []
assignee: [team-member]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
prd-reference: docs/features/[feature-slug]/02-requirements/prd.md
techspec-reference: docs/features/[feature-slug]/03-technical/techspec.md
---

<task_context>
<domain>engine/infra/[subdomain]</domain>
<type>implementation|integration|testing|documentation</type>
<scope>core_feature|middleware|configuration|performance</scope>
<complexity>low|medium|high</complexity>
<dependencies>external_apis|database|temporal|http_server</dependencies>
</task_context>

# Task X.0: [Parent Task Title]

## Overview

[Brief description of task]

<import>**MUST READ BEFORE STARTING** @.cursor/rules/critical-validation.mdc</import>

<requirements>
[List of mandatory requirements]
</requirements>

## Subtasks

- [ ] X.1 [Subtask description]
- [ ] X.2 [Subtask description]

## Implementation Details

[Relevant sections from tech spec]

### Relevant Files

- `path/to/file.go`

### Dependent Files

- `path/to/dependency.go`

## Success Criteria

- [Measurable outcomes]
- [Quality requirements]
