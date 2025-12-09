# TDD: Slash Commands for Claude Code

## Overview

Currently the `~/.claude/skills/commands/` directory is empty. There are existing skills (`commit/`, `create-issue/`, `pr-workflow/`) that handle some overlapping functionality.

This change creates 11 slash commands for everyday development workflows. After implementation:
- Commands will be available globally via `/command-name`
- Overlapping skills will be removed (commit, create-issue, pr-workflow)
- Users can invoke commands directly without relying on skill auto-detection

Key considerations:
- Commands are markdown files that expand into prompts
- Support `$ARGUMENTS` for parameterized commands
- Keep commands concise but complete
- Follow patterns from research (conventional commits, gh CLI, etc.)

## Approach

Create standalone command files in `commands/` directory. Each is a self-contained markdown prompt.

Why standalone over skill wrappers:
- Simpler - no indirection
- Portable - commands work without skills repo
- Explicit - user knows exactly what they're invoking
- Consistent - all commands follow same pattern

Why remove overlapping skills:
- Reduces confusion (one way to do things)
- Commands are more explicit user intent
- Skills still exist for complex multi-step workflows (create-feature, reflect, etc.)

## Relevant Coding Best Practices

- Keep commands concise (<100 lines each)
- Use `$ARGUMENTS` for parameterized commands
- Include clear usage examples in each command
- Use imperative voice ("Create...", "Run...", not "Creates...")
- Follow conventional commit format for commit command
- Use gh CLI for GitHub operations

## Planned Changes

| File | Change |
|------|--------|
| `commands/commit.md` | Create - conventional commit workflow |
| `commands/check.md` | Create - lint, typecheck, test runner |
| `commands/create-issue.md` | Create - GitHub issue creation |
| `commands/do-issue.md` | Create - implement issue end-to-end |
| `commands/issues.md` | Create - list open GitHub issues |
| `commands/changelog.md` | Create - generate changelog from commits |
| `commands/research.md` | Create - search online for best practices |
| `commands/review.md` | Create - code review staged changes |
| `commands/pr.md` | Create - create pull request |
| `commands/fix-pr.md` | Create - address PR review comments |
| `commands/explain.md` | Create - generate documentation |
| `commit/SKILL.md` | Delete - replaced by command |
| `create-issue/SKILL.md` | Delete - replaced by command |
| `pr-workflow/SKILL.md` | Delete - replaced by command |

## Commits

### 1. feat(commands): add commit command

Add /commit command for staging and committing with conventional commit format.
Supports conventional commit types (feat, fix, refactor, docs, test, chore).

### 2. feat(commands): add check command

Add /check command to run lint, typecheck, and tests.
Detects project tooling (npm, yarn, cargo, etc.) and runs appropriate commands.

### 3. feat(commands): add create-issue command

Add /create-issue command to create detailed GitHub issues.
Uses gh CLI, supports $ARGUMENTS for issue description.

### 4. feat(commands): add do-issue command

Add /do-issue command to implement GitHub issues end-to-end.
Creates branch, implements, tests, and prepares for PR.

### 5. feat(commands): add issues command

Add /issues command to list open GitHub issues.
Displays as markdown table with priority recommendations.

### 6. feat(commands): add changelog command

Add /changelog command to generate changelog from git commits.
Categorizes by type, supports version tagging.

### 7. feat(commands): add research command

Add /research command to search online for best practices.
Recursively explores GitHub, docs, and authoritative sources.

### 8. feat(commands): add review command

Add /review command for self-review of staged changes.
Checks correctness, security, simplicity, and test coverage.

### 9. feat(commands): add pr command

Add /pr command to create pull requests.
Generates description, test plan, and uses gh CLI.

### 10. feat(commands): add fix-pr command

Add /fix-pr command to address PR review comments.
Fetches comments, makes targeted fixes, and pushes updates.

### 11. feat(commands): add explain command

Add /explain command to generate documentation.
Analyzes code and produces clear explanations.

### 12. chore: remove overlapping skills

Remove commit/, create-issue/, and pr-workflow/ skill directories.
These are now replaced by standalone commands.

## Testing Plan

**Manual verification:**
- Verify commands appear in `/help` output
- Test each command with sample arguments
- Verify gh CLI commands work correctly

**Edge cases:**
- Empty arguments for parameterized commands
- No git repo initialized
- No GitHub remote configured
- No package.json/Cargo.toml for check command

**Common failures:**
- gh CLI not authenticated - command should provide helpful message
- No staged changes for commit - should warn user
- Rate limiting on research - should handle gracefully
