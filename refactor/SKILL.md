---
name: refactor
description: |
  Use this skill when restructuring existing code without changing behavior. Guides safe refactoring with tests before/after, incremental changes, and behavior preservation. Invoke when user asks to: refactor code, clean up code, restructure, reduce complexity, or improve code quality.
---

# Refactor Workflow

Safe code restructuring that preserves behavior.

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Branch - Create branch from main
```bash
git checkout main && git pull
git push origin main
git checkout -b refactor/<description>
```

### Step 2: Understand - Explore and verify baseline
- Use Explore agent to understand the code to refactor
- Run existing tests to establish baseline
  ```bash
  npm run test:run
  ```
- ⏸️ **STOP**: If tests fail, fix them first or confirm with user before proceeding. Wait for user input before continuing.
- Note current behavior and dependencies

### Step 3: Plan - Define scope and approach
- Define what's IN scope (specific files, patterns, goals)
- Define what's OUT of scope (no new features, no bug fixes)
- Choose refactoring approach:
  - Extract method/function
  - Rename for clarity
  - Simplify conditionals
  - Remove duplication
  - Reduce coupling
- ⏸️ **STOP**: Confirm scope with user. Wait for user input before continuing.

### Step 4: Push and create PR
```bash
git push -u origin refactor/<description>
gh pr create --draft --title "refactor: <description>" --body "<scope and approach>"
```
Use the scope/approach from Step 3 as the PR body. Draft PR indicates work-in-progress.

### Step 5: Implement
- Iteratively implement each change in the plan
  - Concise, clear, imperative commit message (the "what")
  - Comprehensive, concise, commit message (the "how" and "why")
  - Do NOT reference claude code.
  - Run tests after each change - if tests fail, revert and try smaller change
  - ⏸️ **STOP**: Wait for user approval after each commit unless instructed otherwise.
- Keep bug fixes separate - create issues for bugs found

### Step 6: Review - Verify behavior preserved
- Run full test suite
- Compare before/after behavior
- Evaluate each goal with ✓ (pass) or ✗ (fail):
  - Behavior unchanged
  - Tests still pass
  - Code is simpler/clearer
  - Coupling reduced
  - No new features added
- ⏸️ **STOP**: Present changes to user. Wait for user input before continuing.

### Step 7: Code Review
- Use `review` skill to analyze changes
- Fix any issues found before proceeding

### Step 8: Merge and cleanup
```bash
gh pr merge --squash --delete-branch
git checkout main && git pull
```
⏸️ **STOP**: Wait for user to approve merge before continuing.

## Output Format

### Refactoring Summary

```markdown
## Refactoring Summary

**Scope**: [What was refactored]
**Goal**: [Why - reduce complexity, improve clarity, etc.]
**Result**: X/5 passed

## Review

- ✓ Behavior unchanged: [brief explanation]
- ✓ Tests still pass: All 42 tests passing
- ✓ Code is simpler/clearer: [brief explanation]
- ✗ Coupling reduced: [issue found]
- ✓ No new features added: [brief explanation]

## Changes Made

| File | Change | Reason |
|------|--------|--------|
| `file.ts` | Extracted method X | Reduce duplication |
| `file.ts` | Renamed Y to Z | Improve clarity |
```

## Principles

- **Tests first** - Must pass before refactoring begins
- **Behavior preserved** - External behavior must not change
- **Incremental** - Small changes, test after each
- **Separate concerns** - Refactoring is not bug fixing
- **Easy to delete** - Reduce coupling, no tentacles

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
