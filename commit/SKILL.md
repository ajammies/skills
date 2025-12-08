---
name: commit
allowed-tools: Bash(git:*)
description: |
  Use this skill when committing changes. Validates branch relevance, ensures atomic commits.
---

# Commit

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

1. **Check branch** - Run `git branch` to verify current branch
   - If on wrong branch: see Branch Mismatch Handling below

2. **Review changes** - Run `git status` and `git diff`

3. **Validate** - Ensure code works with real data before committing

4. **Stage** - Add relevant files with `git add`
   - Do not batch unrelated changes

5. **Commit** - Write message with title and description
   ```bash
   git commit -m "<type>: <title>" -m "<description>"
   ```

## Commit Format

```
<type>: <short title>

<description - explain WHY, not just what. 1-2 paragraphs for
significant changes, 1-2 sentences for small fixes.>
```

## Branch Mismatch Handling

If changes don't belong on current branch, commit to main and rebase:

```bash
current_branch=$(git branch --show-current)
git stash
git checkout main && git pull
git stash pop
# ... make commit on main ...
git checkout $current_branch
git rebase main
```

## Commit Types

- `feat:` - new feature
- `fix:` - bug fix
- `refactor:` - no behavior change
- `docs:` - documentation only
- `test:` - adding tests

## Principles

- Always verify on correct branch before committing
- Always make commits atomic - one logical change per commit
- Always validate code works before committing
- Always explain the "why" in the description
