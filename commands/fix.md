# Fix Bug

Fix a bug using the `fix` skill workflow.

## Usage

```
/fix [issue or description]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as bug description or issue reference
   - If no arguments: infer from error messages, conversation, git diff, or ask

2. **Invoke `fix` skill** with the determined scope

## Examples

```
/fix                              # Infer from recent errors or conversation
/fix #123                         # Fix GitHub issue #123
/fix login button not working     # Explicit bug description
```
