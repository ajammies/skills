# TDD: Rename to feature-workflow + Add fix-workflow

## Overview

Currently `create-feature` is the only workflow skill. The `/do-issue` command expects a `create-fix` skill that doesn't exist.

This change:
1. Renames `create-feature` → `feature-workflow`
2. Creates `fix-workflow` skill with references for root cause analysis
3. Updates `/do-issue` command routing

## Research Summary

Based on best practices from [Bugasura](https://bugasura.io/blog/root-cause-analysis-for-bug-tracking/), [ACV Engineering](https://acv.engineering/posts/Five-Why-Analysis/), [Wikipedia](https://en.wikipedia.org/wiki/Five_whys), and [LinkedIn](https://www.linkedin.com/advice/0/what-best-practices-preventing-reintroduction-01xgf):

**Key principles for bug fixing:**
1. **Reproduce before fixing** - Never fix blind
2. **Root cause analysis** - Use 5 Whys technique, don't patch symptoms
3. **Minimal change principle** - Smallest fix that resolves the issue
4. **Regression test mandatory** - Every bug fix needs a test that fails without the fix
5. **Document the analysis** - Knowledge base for future reference

**5 Whys Technique:**
- Ask "Why?" repeatedly until root cause is found
- Example: App crashes → null pointer → uninitialized variable → missing validation → unclear API contract
- Involves cross-functional perspective when needed

## Approach

### feature-workflow (rename)
Preserve existing content, update frontmatter name and description only.

### fix-workflow (new)

**Structure:**
```
fix-workflow/
├── SKILL.md              # Main workflow (concise)
└── references/
    └── root-cause-analysis.md   # 5 Whys, techniques, examples
```

**SKILL.md Workflow:**
1. **Understand** - Gather context from issue, logs, user reports
2. **Reproduce** - Recreate the bug in controlled environment
3. **Analyze** - Root cause analysis (see references/root-cause-analysis.md)
4. **Fix** - Implement minimal change + regression test
5. **Verify** - Confirm fix resolves issue, no regressions
6. **PR** - Create PR with root cause explanation

**references/root-cause-analysis.md Content:**
- 5 Whys technique with software examples
- Fishbone diagram approach
- Common root cause categories (technical, process, human)
- Best practices checklist

## Planned Changes

| File | Change |
|------|--------|
| `create-feature/` | Delete directory |
| `feature-workflow/SKILL.md` | Create - renamed from create-feature |
| `fix-workflow/SKILL.md` | Create - bug fix workflow |
| `fix-workflow/references/root-cause-analysis.md` | Create - RCA techniques |
| `commands/do-issue.md` | Update - route to new skill names |

## Commits

### 1. refactor: rename create-feature to feature-workflow

Rename skill directory and update SKILL.md frontmatter.

### 2. feat(skills): add fix-workflow skill

Add workflow for fixing bugs with:
- SKILL.md with 6-step workflow
- references/root-cause-analysis.md with 5 Whys and techniques

### 3. fix(commands): update do-issue routing

Update routing table to use feature-workflow and fix-workflow.

## Testing Plan

- Verify both skills have valid frontmatter
- Verify fix-workflow references file is discoverable
- Verify `/do-issue` routes correctly

## Sources

- [Bugasura - Root Cause Analysis for Bug Tracking](https://bugasura.io/blog/root-cause-analysis-for-bug-tracking/)
- [ACV Engineering - Five Why Analysis](https://acv.engineering/posts/Five-Why-Analysis/)
- [Wikipedia - Five Whys](https://en.wikipedia.org/wiki/Five_whys)
- [LinkedIn - Preventing Bug Reintroduction](https://www.linkedin.com/advice/0/what-best-practices-preventing-reintroduction-01xgf)
