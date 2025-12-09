# Create Pull Request

Create a pull request with description and test plan.

## Usage

```
/pr [description or title]
```

Arguments: $ARGUMENTS

## Behavior

1. **Check state** - Verify branch is pushed and has commits ahead of main
2. **Analyze changes** - Review all commits on branch to understand scope
3. **Generate PR content**
   - Title: concise summary (from argument or inferred)
   - Description: what changed and why
   - Test plan: how to verify the changes
4. **Create PR** with `gh pr create`

## Output Format

```markdown
## Summary
- [Bullet points of key changes]

## Test Plan
- [ ] Step to verify change 1
- [ ] Step to verify change 2
```

## Examples

```
/pr                         # Infer from commits
/pr add user auth           # Use as title hint
/pr fixes the login bug     # Semantic description
```

## Commands

```bash
# Check if pushed
git status

# View commits on branch
git log main..HEAD --oneline

# Create PR
gh pr create --title "<title>" --body "<body>"

# Link to issue
gh pr create --title "<title>" --body "Closes #<issue>"

# Draft PR
gh pr create --draft --title "<title>" --body "<body>"
```

## Notes

- Always push before creating PR if not already pushed
- Link related issues with "Closes #N" in body
- Include test plan for reviewers
