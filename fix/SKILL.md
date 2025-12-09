---
name: fix
description: |
  Use this skill when fixing bugs, resolving defects, or addressing issues. Provides structured workflow for reproduction, root cause analysis, minimal fix implementation, and regression testing. Invoke when user asks to: fix a bug, resolve an issue, debug a problem, or address a defect.
---

# Purpose

Structured workflow for fixing bugs with emphasis on understanding before fixing.

## Overview

Bug fixing is different from feature development. This workflow ensures:
- Bugs are reproduced before attempting fixes
- Root causes are identified (not just symptoms patched)
- Regression tests are written before the fix
- Minimal changes reduce risk of new bugs

## Instructions

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Branch - Create fix branch
```bash
git checkout main && git pull
git push origin main
git checkout -b fix/<issue-or-description>
```

### Step 2: Understand - Gather context
- Read the issue/bug report thoroughly
- Collect error messages, logs, stack traces
- **Explore the codebase** - Use Explore agent to understand affected components
- **Research online** - Search for similar issues, known bugs in dependencies, or relevant patterns
- Identify affected components and user impact
- ⏸️ Confirm understanding with user if unclear

### Step 3: Plan reproduction
- Review environment requirements (see `references/reproduction-environments.md`)
- Draft reproduction plan with specific steps
- Identify any data, credentials, or setup needed
- ⏸️ Present reproduction plan to user for approval

### Step 4: Reproduce - Recreate the bug
- Set up environment per approved plan
- Execute steps to trigger the bug
- Add temporary logging/debugging to trace the issue if needed
- Document exact reproduction steps and observed behavior
- If cannot reproduce: gather more information before proceeding
- ⏸️ Confirm reproduction before continuing

### Step 5: Analyze - Find root cause
- Use the **5 Whys technique** (see `references/root-cause-analysis.md`)
- Ask "Why?" repeatedly until you reach the fundamental cause
- Avoid fixing symptoms - find the actual source
- Consider: Is this a code bug, design flaw, or missing requirement?
- ⏸️ Present root cause analysis to user

### Step 6: Write regression test
- Write a test that **fails** with the current buggy behavior
- Test should pass once the fix is applied
- This prevents the bug from being reintroduced later
- Commit the failing test separately (optional)

### Step 7: Identify related vulnerabilities
- Search codebase for similar patterns that could have the same bug
- List any other locations where this issue might reoccur
- Note in the Bug Analysis Report for future reference or additional fixes

### Step 8: Fix - Implement minimal change
- Apply the **minimal change principle** - smallest fix that resolves the issue
- Verify the regression test now passes
- Run existing tests to ensure no breakage

### Step 9: Verify - Confirm resolution
- Re-run the reproduction steps - bug should be gone
- Test edge cases related to the fix
- Run full test suite
```bash
npm run test:run && npm run typecheck
```

### Step 10: Code Review
- Use `review` skill to analyze changes
- Fix any issues found before proceeding

### Step 11: Clean up and PR
- Remove any temporary logging/debug statements added during investigation
- Ensure no sensitive data is logged
```bash
git push -u origin <branch>
gh pr create --title "fix: <description>" --body "<bug-analysis-report>"
```
Use the Bug Analysis Report (from Step 5) as the PR body.

⏸️ Wait for user to approve PR

### Step 12: Merge and cleanup
```bash
gh pr merge --squash --delete-branch
git checkout main && git pull
```

## Output Format

### Bug Analysis Report

Present using this structure (used in Step 4 and as PR body):

```markdown
## Bug Analysis

**Severity**: [Critical/High/Medium/Low]
- Critical: System failure, data loss, security vulnerability
- High: Major functionality broken
- Medium: Edge cases, inconsistent behavior
- Low: Cosmetic, minor inconvenience

**Location**: `path/to/file.ts:123` - [function/component name]

**Symptom**: [What the user experienced]

**Reproduction Steps**:
1. [Step to reproduce]
2. [Step to reproduce]

**Root Cause Analysis (5 Whys)**:
1. Why? → [First answer]
2. Why? → [Second answer]
3. Why? → [Root cause identified]

**Root Cause**: [Clear statement of the fundamental issue]

**Related Vulnerabilities**:
- `path/to/similar.ts:45` - [Same pattern exists here]
- [Other areas that might have the same bug]

**Proposed Fix**: [Minimal change to resolve - be specific about what changes]

**Risk Assessment**: [Low/Medium/High] - [Reasoning]
```

## Principles

- **Never fix blind** - Always reproduce first
- **Understand before changing** - Root cause analysis prevents wrong fixes
- **Test before fix** - Write the regression test first
- **Minimal changes** - Less code changed = less risk
- **Document the analysis** - Future bugs may be related

## Commit Format

```
fix(<scope>): <what was fixed>

Root cause: <why it was broken>
Fix: <what was changed>
```

## Resources

- `references/root-cause-analysis.md` - 5 Whys technique and RCA methods
- `references/reproduction-environments.md` - Environment setup patterns
