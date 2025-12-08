---
name: pr-workflow
description: |
  ALWAYS use this skill when the user asks to: start an issue, work on an issue, do an issue, create a feature, fix a bug, make changes, add something, implement anything, or create a PR. This skill MUST be invoked before making any code changes. Provides the standard workflow for branching, commits, and PRs.
---

# PR Workflow

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

1. **Branch** - Create branch from main
   ```bash
   git checkout main && git pull
   git checkout -b <type>/<feature-name>
   ```
   Prefixes: `feat/` `fix/` `refactor/` `docs/`

2. **Plan** - Invoke `code-rules` skill, propose the plan with atomic commits
   - Break feature into small, independent commits (each ~1-3 files)
   - Each commit should be: deletable, testable, single-purpose
   - Format commits as numbered list with clear scope
   ⏸️ Wait for user approval of plan

3. **Write plan** - Write plan to `docs/plans/plan-<feature>.md`

4. **Implement** - Make small changes, use `commit` skill after each logical unit
   ⟳ Repeat: implement → commit → ⏸️ wait for feedback

5. **Test** - Run `npm run test:run && npm run typecheck`

6. **PR** - Push and create PR
   ```bash
   git push -u origin <branch>
   gh pr create --title "<title>" --body "<description>"
   ```
   ⏸️ Wait for user to approve PR

7. **Merge** - Merge and cleanup
   ```bash
   gh pr merge --squash --delete-branch
   git checkout main && git pull
   ```

8. **Reflect** - Invoke `reflect` skill for learnings

## Pre-PR Checklist

Before creating PR, verify:

- [ ] Tests pass (`npm run test:run`)
- [ ] Types check (`npm run typecheck`)
- [ ] No global mutable state
- [ ] Single-responsibility functions
- [ ] Code is easy to delete
- [ ] No premature abstractions

## Principles

- Always make changes small, contained, and atomic
- Always write code that is easy to follow and delete
- Do not use premature abstractions
