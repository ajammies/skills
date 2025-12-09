# Create GitHub Issue

Create a detailed GitHub issue, inferring context from the current work.

## Usage

```
/create-issue [optional description]
```

Arguments: $ARGUMENTS

## Behavior

1. **Gather context** - Review current branch, recent changes, conversation history
2. **Infer issue details** - If no description provided, infer from context
3. **Clarify with user** - Ask targeted questions until you have:
   - Clear problem statement or feature request
   - Why this matters (impact/priority)
   - Acceptance criteria (what "done" looks like)
4. **Draft and confirm** - Show draft, get user approval
5. **Create** - Run `gh issue create`

## Clarifying Questions

Ask only what's needed. Examples:

- "Is this a bug fix or new feature?"
- "What should happen when this is complete?"
- "How urgent is this - blocking current work?"
- "Should this be assigned to anyone?"

## Issue Format

```markdown
## Description
[What and why - inferred from context + user input]

## Acceptance Criteria
- [ ] [Specific, testable criteria]

## Context
[Relevant code paths, related issues, technical notes]
```

## Commands

```bash
gh issue create --title "<title>" --body "<body>"
gh issue create --title "<title>" --body "<body>" --label "bug"
gh issue create --title "<title>" --body "<body>" --assignee "@me"
```
