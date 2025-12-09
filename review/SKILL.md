---
name: review
description: Structured code review workflow. Use when user asks to review code, check changes, or analyze code quality. Supports reviewing staged changes, branch diffs, or specific files/functions via semantic search.
---

# Review

Structured code review with checklist-driven analysis and actionable findings.

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Scope - Determine what to review
- **Staged changes**: `git diff --cached`
- **Branch diff**: `git diff main...HEAD`
- **Specific files**: Use semantic search to find relevant code
- If scope > 400 lines, suggest splitting into smaller reviews
- ⏸️ **STOP**: Confirm scope with user. Wait for user input before continuing.

### Step 2: Context - Understand the codebase
- Use Explore agent to understand existing patterns
- Note project conventions and standards
- Identify areas user should be aware of for their own learning

### Step 3: Analyze - Review against checklist
For each file/change, evaluate with ✓ (pass) or ✗ (fail):

- **Correctness**: Does it do what it claims?
- **Edge cases**: Boundary conditions and empty states handled?
- **Error handling**: Failures caught and return meaningful messages?
- **Security**: Input validated, no secrets, no injection risks?
- **Simplicity**: Clear, readable, follows code rules?
- **Coupling**: Easy to delete, no tentacles across files?
- **Tests**: New code and error paths covered?
- **Performance**: No N+1 queries, unbounded loops, or memory leaks?

### Step 4: Report - Output findings
Use Review Report format below. Group by severity.
- ⏸️ **STOP**: Present findings to user. Wait for user input before continuing.

### Step 5: Iterate - Address findings
- Suggest specific fixes with code examples
- User applies fixes or asks Claude to fix
- Re-review changed areas
- ⟳ Repeat until all issues resolved or accepted

## Output Format

### Review Report

```markdown
## Review Summary

**Scope**: [What was reviewed]
**Lines reviewed**: [Count]
**Result**: X/8 passed

## Checklist

- ✓ Correctness: [brief explanation]
- ✓ Edge cases: [brief explanation]
- ✗ Error handling: [issue found]
- ✓ Security: [brief explanation]
- ✓ Simplicity: [brief explanation]
- ✓ Coupling: [brief explanation]
- ✗ Tests: [issue found]
- ✓ Performance: [brief explanation]

## Findings

| Severity | Location | Category | Issue | Fix |
|----------|----------|----------|-------|-----|
| High | `file.ts:45` | Error handling | [Issue] | [Suggestion] |
| Medium | `file.ts:78` | Tests | [Issue] | [Suggestion] |

## Worth Knowing

[Areas of the codebase the user should be aware of for their own learning]
```

## Severity Guide

- **Critical**: Security vulnerability, data loss, system failure
- **High**: Functionality broken, major bug
- **Medium**: Edge case missed, inconsistent behavior
- **Low**: Style, minor improvement, nitpick

## Code Rules

- Make it as simple as possible, but not simpler
- Write code that is easy to delete - loose coupling, no tentacles
- Keep functions small enough to fit in your head
- Do not abstract until you see the pattern three times
- Prefer explicit over implicit - no magic
- Always read file before editing - never propose changes to code you haven't read
- Use pure functions, immutability, no side effects
- Flow data through parameters, not global state
- Use explicit types for data flowing between functions
- Use 2-3 params direct; 4+ use options object
- Use const by default for parameters
- Minimize control flow complexity - favor consistent execution paths
