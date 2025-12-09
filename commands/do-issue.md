# Do Issue

Implement a GitHub issue by invoking the appropriate skill based on issue type.

## Usage

```
/do-issue <issue-number or description>
```

Arguments: $ARGUMENTS

## Workflow

1. **Find issue**
   - If argument is a number: fetch directly with `gh issue view <number>`
   - If argument is text: search open issues with `gh issue list`, find best semantic match, confirm with user before proceeding
   - If no argument: list open issues and ask user to pick one

2. **Confirm** - Show issue title and summary, get user confirmation this is the right issue

3. **Classify type** - Determine issue type from labels, title, and description

4. **Invoke skill** - MUST invoke the corresponding skill:

| Issue Type | Skill to Invoke |
|------------|-----------------|
| Feature / Enhancement | `create-feature` |
| Bug / Fix | `fix` |
| Refactor | `refactor` |

5. **Pass context** - Provide the skill with issue details, acceptance criteria, and relevant context

## Classification Hints

- Labels: `bug`, `feature`, `enhancement`, `docs`, `refactor`, `test`
- Title prefixes: "Fix", "Add", "Update", "Refactor", "Document"
- If unclear, ask user which type applies

## Commands

```bash
# List open issues
gh issue list

# Search issues
gh issue list --search "<query>"

# View issue
gh issue view <number>

# View with comments
gh issue view <number> --comments
```

## Notes

- The invoked skill handles branching, implementation, testing, and PR prep
- If a required skill doesn't exist yet, inform the user and suggest creating it
- Always link the issue in the eventual PR with "Closes #<number>"
