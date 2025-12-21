---
name: status
description: |
  Show current work stack and fastest path to resolution. Use when user asks:
  "status", "what am I working on?", "where was I?", or seems lost after
  switching between tasks. Displays branches, uncommitted work, open PRs,
  and suggests fastest path back to clean main.
---

# Status

Show work stack and fastest resolution path.

## Instructions

### 1. Gather State
```bash
git branch                                 # Local branches
git status                                 # Uncommitted changes
git stash list                             # Stashed work
git log main..HEAD --oneline 2>/dev/null   # Commits on current branch
gh pr list --author @me                    # Open PRs
```

For each non-main branch, check its commits:
```bash
git log main..<branch> --oneline
```

### 2. Present Plain English Summary

Start with a narrative overview:

> **Current situation:** You're on `feat/auth` with uncommitted changes to 2 files.
>
> You started this branch to add user authentication - there are 3 commits
> implementing the login flow. The work appears incomplete (no tests yet).
>
> You also have `fix/typo` with an open PR (#42) waiting for merge.

### 3. List Branches

| Branch | Purpose | State |
|--------|---------|-------|
| `feat/auth` (current) | Add user authentication | 3 commits, 2 uncommitted files |
| `fix/typo` | Fix README typo | PR #42 open |
| `main` | - | Up to date with origin |

### 4. Recommend Resolution Path

Suggest fastest path to clean main:
1. Current uncommitted work → commit, stash, or discard
2. Current branch → finish, PR, or abandon
3. Other branches → merge PRs or delete stale
4. Return to main, pull latest

⏸️ **STOP**: Present summary and ask: "Want me to help resolve these?"
