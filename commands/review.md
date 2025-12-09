# Review Code

Review code using the `review` skill workflow.

## Usage

```
/review [scope]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as review scope
   - If no arguments: infer from git staged changes, branch diff, or conversation

2. **Invoke `review` skill** with the determined scope

## Examples

```
/review                           # Review staged changes or branch diff
/review staged                    # Review staged changes
/review branch                    # Review current branch vs main
/review src/components/           # Review specific directory
```
