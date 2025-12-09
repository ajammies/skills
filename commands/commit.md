# Commit Changes

Stage and commit changes using conventional commit format.

## Steps

1. Run `git status` and `git diff` to review changes
2. Stage relevant files with `git add` (do not batch unrelated changes)
3. Write commit message following format below
4. Commit with `git commit`

## Commit Format

```
<type>(<scope>): <subject>

<body - explain WHY, not just what>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

**Examples:**
- `feat(auth): add password reset flow`
- `fix(api): handle null response from upstream`
- `refactor(utils): extract date formatting logic`

## Rules

- One logical change per commit
- Subject line max 50 chars, imperative mood
- Body wraps at 72 chars
- Explain the "why" in the body
- Do NOT reference AI tooling in commit messages
