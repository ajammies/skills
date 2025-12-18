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

### Step 2: Research - Explore and verify baseline
- Use Explore agent to understand the code to refactor
- Run existing tests to establish baseline
  ```bash
  npm run test:run
  ```
- If tests fail, fix them first or confirm with user before proceeding
- Note current behavior and dependencies
- ⏸️ **STOP**: Present research findings before planning. Wait for user input before continuing.

### Step 3: Propose a Technical Design Document
- Enter planning mode
- Create the TDD that has the following sections:
  - Refactoring Approach - choose and justify the strategy:
    - Extract method/function
    - Rename for clarity
    - Simplify conditionals
    - Remove duplication
    - Reduce coupling
  - Overview - concise, plain-english describe the delta between current state and intended state, and key considerations
  - Scope - what's IN scope (specific files, patterns, goals) and what's OUT of scope (no new features, no bug fixes)
  - Relevant specific coding best practices
  - List of Planned Changes
  - List of small, atomic, commits (each is deletable, testable, single purpose)
- Testing plan (verify behavior preserved, edge cases)
- ⏸️ **STOP**: Wait for user approval of TDD before continuing.

### Step 4: Push and create PR
```bash
git push -u origin <branch>
gh pr create --draft --title "refactor: <description>" --body "<TDD>"
```
Use the TDD from Step 3 as the PR body. Draft PR indicates work-in-progress.

### Step 5: Implement
- Iteratively implement each change in the plan
  - Concise, clear, imperative commit message (the "what")
  - Comprehensive, concise, commit message (the "how" and "why")
  - Do NOT reference claude code.
  - Run tests after each change - if tests fail, revert and try smaller change
  - ⏸️ **STOP**: Wait for user approval after each commit unless instructed otherwise.
- Keep bug fixes separate - create issues for bugs found

### Step 6: Test - Verify behavior preserved
- Run full test suite
- Compare before/after behavior
- Evaluate each goal with ✓ (pass) or ✗ (fail):
  - Behavior unchanged
  - Tests still pass
  - Code is simpler/clearer
  - Coupling reduced
  - No new features added

### Step 7: Code Review
- Use `review` skill to analyze changes
- Fix any issues found before proceeding
- ⏸️ **STOP**: Wait for user approval before continuing.

### Step 8: Merge and cleanup
```bash
gh pr merge --squash --delete-branch
git checkout main && git pull
```
⏸️ **STOP**: Wait for user to approve merge before continuing.

### Step 9: Reflect
- Review what worked, what caused friction
- Output recommendations table:
  | Type | Priority | Change | Why |
  |------|----------|--------|-----|
  | `claude.md` | high/medium/low | Specific change | Reason |
  | `skill` | high/medium/low | Specific change | Reason |
- ⏸️ **STOP**: Ask user if they want to implement any recommendations. Wait for user input before continuing.

## Error Handling
- Clearly describe the error
- Recommend the best path to proceed
- ⏸️ **STOP**: Wait for user approval before continuing.

## Examples

### Example TDD

```markdown
# TDD: Simplify Authentication Logic

## Refactoring Approach
**Strategy**: Extract method + Simplify conditionals

The current auth logic has deeply nested conditionals and duplicated validation.
We'll extract common validation into helper functions and flatten the control flow.

## Overview
Currently `auth.ts` has 3 functions with duplicated token validation logic and
nested if/else blocks 4 levels deep. After refactoring, validation is centralized
in `validateToken()` and conditionals are flattened using early returns.

Key considerations:
- No behavior changes - same inputs produce same outputs
- All 15 existing tests must continue to pass
- No new features (defer rate limiting to separate PR)

## Scope
**IN scope**:
- `src/auth/auth.ts` - extract validateToken(), flatten conditionals
- `src/auth/session.ts` - use shared validateToken()

**OUT of scope**:
- Bug fixes (found edge case - created issue #42)
- New features (rate limiting deferred)
- Other files

## Planned Changes

| File | Change | Reason |
|------|--------|--------|
| `src/auth/auth.ts` | Extract validateToken() | Remove duplication |
| `src/auth/auth.ts` | Replace nested if/else with early returns | Reduce complexity |
| `src/auth/session.ts` | Use validateToken() | Single source of truth |

## Commits

### 1. refactor(auth): extract validateToken helper
Move duplicated token validation into single function.

### 2. refactor(auth): flatten conditionals with early returns
Replace nested if/else with guard clauses.

### 3. refactor(session): use shared validateToken
Replace inline validation with helper.

## Testing Plan

**Behavior verification:**
- All 15 existing tests pass unchanged
- Manual test: valid token → success
- Manual test: invalid token → rejection
- Manual test: expired token → rejection
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
