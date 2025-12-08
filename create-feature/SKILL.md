---
name: create-feature
description: |
  ALWAYS use this skill when the user asks to: start an issue, work on an issue, do an issue, create a feature, make significant, add something, implement anything, or create a PR. This skill MUST be invoked before making any code changes. Provides the standard workflow for branching, commits, and PRs.
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
  git checkout -b feat/<feature-name>
  ```
  If not on main branch, ⏸️ Wait for user instruction
   

### Step 2: Propose a Technical Design Document
  - Enter planning mode
  - Analyse the current architecture
  - Create the TDD that has the following sections
    - Overview - concise, plain-english describe the delta between intended state and current state, and key considerations.
    - Codebase best practices
    - List of Planned Changes
    - List of small, atomic, commits (each is deletable, testable, single purpose)
  - Testing plan (user flows, edge cases, common failures)
  - ⏸️ Wait for user approval of TDD

### Step 3: Write plan to `docs/plans/plan-<feature>.md`

### Step 4: Implement
  - Iteratively implement each commit in the plan
    - Concise, clear, imperative commit message (the "what")
    - Comprehensive, concise, commit message (the "how" and "why")
    - Do NOT reference claude code.
    - ⏸️ Wait for user approval after each commit unless instructed otherwise

### Step 5: Push and create PR
   ```bash
   git push -u origin <branch>
   gh pr create --title "<title>" --body "<description>"
   ```
   ⏸️ Wait for user to approve PR

### Step 6: Merge and cleanup
   ```bash
   gh pr merge --squash --delete-branch
   git checkout main && git pull
   ```

## Error Handling
- Clearly describe the error
- Recommend the best path to proceed
- ⏸️ Wait for user approval

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

## Codebase Best Practices
- Pure functions, no side effects
- Explicit types at function boundaries
- Co-locate tests: `file.ts` → `file.test.ts`
- Use Result types for operations that can fail

## Planned Changes

| File | Change |
|------|--------|
| `src/types/auth.ts` | Add `User`, `Session`, `AuthResult` types |
| `src/core/auth.ts` | Add `validateCredentials()`, `createSession()` |
| `src/core/auth.test.ts` | Add unit tests for auth logic |
| `src/api/login.ts` | Add POST /login endpoint |
| `src/middleware/auth.ts` | Add auth middleware for protected routes |

## Commits

### 1. feat(auth): add authentication types

Define User, Session, and AuthResult types for the auth system.
AuthResult uses discriminated union to handle success/failure without exceptions.

### 2. feat(auth): add credential validation and session creation

Add validateCredentials() to verify password against bcrypt hash.
Add createSession() to generate JWT with 24h expiry.
Both return Result types for explicit error handling.

### 3. test(auth): add unit tests for auth core

Test valid/invalid credentials, empty inputs, and session expiry.
Mock bcrypt and jwt for deterministic tests.

### 4. feat(api): add login endpoint

POST /login accepts {username, password}, returns session cookie on success.
Returns 401 with error message on failure. Rate limited to 5 attempts/minute.

### 5. feat(middleware): add auth middleware

Verify JWT on protected routes. Attach user to request context.
Return 401 if token missing/invalid/expired.

## Testing Plan

**User flows:**
- Valid credentials → session cookie set, redirect to dashboard
- Invalid credentials → error message, stay on login

**Edge cases:**
- Empty username/password
- Expired token
- Malformed JWT

**Common failures:**
- DB connection timeout → 503 with retry message
- Rate limit exceeded → 429 with wait time
```

### Example Commit Message

```
feat(auth): add credential validation and session creation

Add validateCredentials() to verify password against bcrypt hash.
Add createSession() to generate JWT with 24h expiry.
Both return Result types for explicit error handling.
```

#### Commit Format

```
<type>(<scope>): <what> (imperative, max 50 chars)

<why and how - wrap at 72 chars>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

#### Bad Commits (avoid)

```
# Too vague
update auth stuff

# References AI tooling
feat: add login (generated by Claude)

# No description
feat(auth): add validation
```

## Resources (none)