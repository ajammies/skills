# List Issues

List open GitHub issues, with optional semantic search.

## Usage

```
/issues [search terms]
```

Arguments: $ARGUMENTS

## Behavior

1. **If no arguments:** List all open issues
2. **If arguments provided:** Semantically match against issue titles and descriptions, show relevant issues ranked by relevance

3. Display as formatted table with: number, title, labels, age
4. Recommend which to work on based on priority and relevance

## Output Format

```markdown
| # | Title | Labels | Age |
|---|-------|--------|-----|
| 123 | Fix auth timeout | bug, priority:high | 2d |
| 456 | Add dark mode | feature | 1w |

**Recommended:** #123 - high priority, oldest
```

## Examples

```
/issues                     # All open issues
/issues auth                # Issues related to authentication
/issues slow performance    # Issues about performance problems
/issues user onboarding     # Issues related to onboarding flow
```

## Commands

```bash
# All open issues
gh issue list

# Search by text
gh issue list --search "<query>"

# Filter by label
gh issue list --label "bug"

# Include closed
gh issue list --state all
```
