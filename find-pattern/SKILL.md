---
name: find-pattern
description: Find existing patterns before implementing new features. Use before creating new agents, schemas, CLI commands, or pipeline stages.
---

# Find Pattern

Search the codebase for existing patterns before implementing something new.

## WORKFLOW

1. **Identify** - Determine what type of thing is being created
2. **Search** - Find existing examples of that type
3. **Report** - State the pattern to follow with file path and key elements

## Pattern Locations

| Creating | Look in |
|----------|---------|
| Agent | `src/core/agents/` |
| Schema | `src/core/schemas/` |
| CLI command | `src/cli/commands/` |
| Pipeline stage | `src/core/pipeline.ts` |

## Report Format

After searching, state:
- **Pattern file:** `path/to/example.ts`
- **Key elements:** [naming, structure, error handling]
- **Will follow:** [specific patterns to adopt]
