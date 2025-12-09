# Explain Code

Generate clear explanations of code, functions, or architecture.

## Usage

```
/explain [file, function, or concept]
```

Arguments: $ARGUMENTS

## Behavior

1. **Find target**
   - If file path: explain that file's purpose and structure
   - If function/class name: find and explain it
   - If concept (e.g., "auth flow"): find related code and explain

2. **Analyze** - Read the code and understand its purpose
3. **Explain** - Write clear, concise explanation at appropriate level
4. **Show relationships** - How it connects to other parts of the codebase

## Output Format

```markdown
## Overview
[1-2 sentence summary of what this does]

## How It Works
[Step-by-step explanation of the logic]

## Key Components
- `functionA`: [what it does]
- `functionB`: [what it does]

## Usage
[How other code uses this, with examples]

## Related
- `path/to/related.ts` - [relationship]
```

## Examples

```
/explain src/auth/login.ts          # Explain a file
/explain handleUserAuth             # Explain a function
/explain the payment flow           # Explain a concept
/explain how errors are handled     # Explain a pattern
```

## Notes

- Adjust detail level to code complexity
- Include code snippets for key logic
- Link to related files when relevant
