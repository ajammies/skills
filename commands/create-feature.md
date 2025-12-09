# Create Feature

Implement a new feature using the `create-feature` skill workflow.

## Usage

```
/create-feature [description]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as feature description
   - If no arguments: infer from conversation history, recent discussion, or ask

2. **Invoke `create-feature` skill** with the determined scope

## Examples

```
/create-feature                           # Infer from conversation
/create-feature add dark mode toggle      # Explicit description
/create-feature user authentication       # Explicit description
```
