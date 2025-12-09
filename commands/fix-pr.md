# Fix PR Comments

Address review comments on a pull request.

## Usage

```
/fix-pr [PR number or search terms]
```

Arguments: $ARGUMENTS

## Behavior

1. **Find PR**
   - If number: fetch directly
   - If text: search open PRs semantically, confirm with user
   - If no argument: use current branch's PR

2. **Fetch comments** - Get unresolved review comments with `gh pr view`
3. **Analyze feedback** - Understand what reviewers are asking for
4. **Make fixes** - Address each comment with targeted changes
5. **Push update** - Commit and push fixes
6. **Report** - Summarize what was addressed

## Output Format

```markdown
## Comments Addressed

1. **@reviewer1** on `src/auth.ts:45`
   > "Add null check here"
   - Fixed: Added guard clause

2. **@reviewer2** on `src/api.ts:12`
   > "This could be simplified"
   - Fixed: Refactored to use optional chaining

## Pushed
Commit: `fix: address PR review comments`
```

## Examples

```
/fix-pr                     # Current branch's PR
/fix-pr 123                 # PR #123
/fix-pr auth changes        # Find PR about auth
```

## Commands

```bash
# Find PR for current branch
gh pr view

# View PR comments
gh pr view <number> --comments

# View review comments specifically
gh api repos/{owner}/{repo}/pulls/<number>/comments

# List open PRs
gh pr list
```
