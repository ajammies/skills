# Cleanup

Review and clean up stale issues, branches, and other project artifacts.

## Usage

```
/cleanup [scope]
```

Arguments: $ARGUMENTS

## Behavior

1. **If no arguments:** Run all cleanup checks
2. **If scope provided:** Focus on that area (issues, branches, prs, deps, etc.)

## Cleanup Checks

### Issues
- Find issues that appear resolved (referenced in merged PRs, no activity)
- Identify stale issues (no updates in 30+ days)
- Suggest closing or following up

### Branches
- Find branches already merged to main
- Find stale branches (no commits in 30+ days)
- Check for orphaned branches (no associated PR)
- Suggest deletion with confirmation

### Pull Requests
- Find stale PRs (no activity in 14+ days)
- Find PRs with merge conflicts
- Identify draft PRs that may be abandoned

### Dependencies (if applicable)
- Check for outdated dependencies
- Identify security vulnerabilities
- Suggest updates

### Files
- Find uncommitted changes across worktrees
- Identify untracked files that may need attention
- Check for leftover merge conflict markers

## Output Format

```markdown
## Cleanup Report

### Issues (2 actions)
- ✓ #12 "Fix login bug" - resolved by PR #15, suggest close
- ? #8 "Add dark mode" - stale 45 days, needs follow-up

### Branches (3 actions)
- 🗑 `feat/old-feature` - merged, safe to delete
- 🗑 `fix/temp-patch` - merged, safe to delete
- ? `wip/experiment` - stale 60 days, no PR

### Pull Requests (1 action)
- ⚠ #20 - has merge conflicts, needs rebase

Proceed with cleanup? [y/N]
```

## Examples

```
/cleanup                    # Full cleanup check
/cleanup branches           # Only check branches
/cleanup issues             # Only check issues
/cleanup stale              # Find all stale items
```

## Commands

```bash
# Merged branches
git branch --merged main

# Stale branches
git for-each-ref --sort=committerdate refs/heads/ --format='%(refname:short) %(committerdate:relative)'

# Issues referenced in merged PRs
gh issue list --state open

# Stale PRs
gh pr list --state open

# Outdated deps (Node)
npm outdated

# Security audit (Node)
npm audit
```

## Safety

- Always confirm before deleting branches
- Never force-delete unmerged branches without explicit approval
- Show what will be affected before taking action
