# Refactor Code

Refactor code using the `refactor` skill workflow.

## Usage

```
/refactor [target]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as refactor target
   - If no arguments: infer from current file, conversation, git diff, or ask

2. **Invoke `refactor` skill** with the determined scope

## Examples

```
/refactor                         # Infer from current file or conversation
/refactor src/utils/auth.ts       # Refactor specific file
/refactor the validation logic    # Refactor by description
```
