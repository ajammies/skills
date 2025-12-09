---
name: create-feature
description: |
  Use this skill when implementing new features or major changes. Provides structured workflow for branching, planning (TDD), implementing via atomic commits, testing, code review, and PR creation. Invoke when user asks to: create a feature, add functionality, implement something new, or build a capability.
---

# Purpose
To follow an explicit, stepped best practices while implementing features and major changes.

## Overview
This skill follows an explicit workflow for creating features and major changes. This skill guides the user through creating a branch, planning the feature, implementing via atomic commits, testing, creating and merging a pull request.

## Prerequisites (None)

## Instructions

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Branch - Create branch from main
  ```bash
  git checkout main && git pull
  git push origin main  # Ensure local commits are pushed before branching
  git checkout -b feat/<feature-name>
  ```
  If not on main branch, ⏸️ **STOP**: Wait for user instruction before continuing.
  If main is ahead of origin/main, push first to avoid stale commits in PR


### Step 2: Research - Gather context and best practices
  - Use `research` skill to find relevant patterns and best practices
  - Explore codebase for existing solutions and conventions
  - ⏸️ **STOP**: Present research findings before planning. Wait for user input before continuing.

### Step 3: Propose a Technical Design Document
  - Enter planning mode
  - Create the TDD that has the following sections
    - Overview - concise, plain-english describe the delta between intended state and current state, and key considerations.
    - Approach - high level overview of how the feature will be implemented, and the justification why this approach is superlative
    - Relevant specific coding best practices
    - List of Planned Changes
    - List of small, atomic, commits (each is deletable, testable, single purpose)
  - Testing plan (user flows, edge cases, common failures)
  - ⏸️ **STOP**: Wait for user approval of TDD before continuing.

### Step 4: Write plan to `docs/plans/plan-<feature>.md`

### Step 5: Implement
  - Iteratively implement each commit in the plan
    - Concise, clear, imperative commit message (the "what")
    - Comprehensive, concise, commit message (the "how" and "why")
    - Do NOT reference claude code.
    - ⏸️ **STOP**: Wait for user approval after each commit unless instructed otherwise.

### Step 6: Test
  - Check for full test coverage
  - Run tests and typecheck
    ```bash
    npm run test:run && npm run typecheck
    ```
  - Fix any failures before proceeding
  - Verify the feature works end-to-end

### Step 7: Code Review
  - Use `review` skill to analyze changes
  - Fix any issues found before proceeding
  - ⏸️ **STOP**: Wait for user approval before continuing.

### Step 8: Push and create PR
   ```bash
   git push -u origin <branch>
   gh pr create --title "<title>" --body "<description>"
   ```
   ⏸️ **STOP**: Wait for user to approve PR before continuing.

### Step 9: Merge and cleanup
   ```bash
   gh pr merge --squash --delete-branch
   git checkout main && git pull
   ```

### Step 10: Reflect
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
# TDD: Add User Authentication

## Overview
Currently the app has no authentication. Users can access all routes without login.

This change adds credential-based authentication with JWT tokens. After implementation,
users must login to access protected routes. Session expires after 24 hours.

Key considerations:
- Password hashing with bcrypt (not plaintext)
- Token stored in httpOnly cookie (not localStorage)
- Rate limiting on login endpoint to prevent brute force

## Approach
Use a layered architecture: types → core logic → API endpoint → middleware.

JWT over sessions because:
- Stateless - no server-side session storage needed
- Scales horizontally without shared state
- Standard library support (jsonwebtoken)

## Planned Changes

| File | Change |
|------|--------|
| `src/types/auth.ts` | Add `User`, `Session`, `AuthResult` types |
| `src/core/auth.ts` | Add `validateCredentials()`, `createSession()` |
| `src/api/login.ts` | Add POST /login endpoint |

## Commits

### 1. feat(auth): add authentication types
Define User, Session, and AuthResult types for the auth system.

### 2. feat(auth): add credential validation
Add validateCredentials() to verify password against bcrypt hash.

## Testing Plan

**User flows:**
- Valid credentials → session cookie set, redirect to dashboard
- Invalid credentials → error message, stay on login

**Edge cases:**
- Empty username/password
- Expired token
```

### Commit Format

```
<type>(<scope>): <what> (imperative, max 50 chars)

<why and how - wrap at 72 chars>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

## Code Rules

- Make it as simple as possible, but not simpler
- Write code that is easy to delete - loose coupling, no tentacles
- Keep functions small enough to fit in your head
- Do not abstract until you see the pattern three times
- Prefer explicit over implicit - no magic
- Always read file before editing - never propose changes to code you haven't read
