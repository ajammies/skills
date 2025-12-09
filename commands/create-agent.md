# Create Agent

Create or modify an agent using the `create-agent` skill workflow.

## Usage

```
/create-agent [name]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as agent name
   - If no arguments: infer from conversation or schema discussion

2. **Invoke `create-agent` skill** with the determined scope

## Examples

```
/create-agent                     # Infer from conversation
/create-agent proseAgent          # Create/modify prose agent
/create-agent the story agent     # Create by description
```
