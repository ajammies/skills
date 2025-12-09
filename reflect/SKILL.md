---
name: reflect
allowed-tools: Read, Edit
description: End-of-session reflection for continuous improvement. Use when user asks to reflect, after merging PRs, or at session end. Outputs improvement recommendations table.
---

# Reflect

Analyze session chats, git commits, and other available logs to recommend improvements.

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

1. **Review** - Scan full chat history, git commits, logs for what was done, user corrections, user preferences, user frustrations.

2. **Analyze** - Think deeply about the root cause reasons for this feedback, an isolate specific behavior from claude that contributed.

3. **Output** - Create a report that recommends new changes claude workflow (beyond whats already impemented). They should be derivative changes. These changes should be intended to automate the user workflow to require zero feedback in the future.

## Output

(note: wrap the text to fit in screen contraints)

### Session Summary

Brief recap: what was done, what worked, what didn't.

### Recommendations

| Type | Priority | Change | Why |
|------|----------|--------|-----|
| `claude.md` | high | Add X | User corrected this twice |
| `skill` | medium | Update Y | Missing pattern |
| `new-skill` | low | Create Z | Repeated workflow |

## Reference

**Types:**
- `claude.md` — Project conventions
- `skill` — Update existing skill
- `new-skill` — New repeatable workflow
- `command` - Update existing commands
- `new-command` - Create new command

**Priority:**
- `high` — Caused errors or user corrections
- `medium` — Would help efficiency
- `low` — Nice to have
