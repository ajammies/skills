# Create Skill

Create or update a skill using the `create-skill` skill workflow.

## Usage

```
/create-skill [name]
```

Arguments: $ARGUMENTS

## Behavior

1. **Determine scope** from context:
   - If arguments provided: use as skill name
   - If no arguments: infer from conversation or skill discussion

2. **Invoke `create-skill` skill** with the determined scope

## Examples

```
/create-skill                     # Infer from conversation
/create-skill deploy              # Create a deploy skill
/create-skill review              # Update existing review skill
```
