---
name: reflect
allowed-tools: Read, Edit
description: End-of-session reflection for continuous improvement. Use when user asks to reflect, after merging PRs, or at session end. Outputs improvement recommendations table.
---

# Reflect

Analyze session and recommend improvements.

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

1. **Review** - Scan full chat history for corrections, preferences, frustrations

2. **Analyze** - Note what worked, what caused friction, patterns

3. **Output** - Generate recommendations table with type, priority, change, why

## Output

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

**Priority:**
- `high` — Caused errors or user corrections
- `medium` — Would help efficiency
- `low` — Nice to have
