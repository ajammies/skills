# Research Topic

Research a topic using the `research` skill workflow.

## Usage

```
/research [topic]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as research topic
   - If no arguments: infer from conversation or current task

2. **Invoke `research` skill** with the determined scope

## Examples

```
/research                                # Infer from conversation
/research authentication best practices  # Explicit topic
/research how errors are handled here    # Codebase-specific research
```
