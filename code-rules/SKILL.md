---
name: code-rules
description: Code editing rules. Reference before complex edits.
---

# Code Rules

## Philosophy

- 🔴 Always make it as simple as possible, but not simpler
- Always write code that is easy to follow and read
- 🔴 Always write code that is easy to delete - loose coupling, no tentacles across files
- Always keep functions small enough to fit in your head
- Do not abstract until you see the pattern three times
- Always prefer explicit over implicit - no magic

## Writing Code

- 🔴 Always read file before editing - never propose changes to code you haven't read
- 🔴 Always use pure functions, immutability, no side effects
- Use context7 when working with libraries or doing something new
- Always use explicit types for data flowing between functions
- Always use standalone exported functions, not classes
- Always flow data through parameters, not global state
- Use 2-3 params as direct arguments; 4+ use options object
- Always use logger (pino) not console.log
- Prefer descriptive function names: `showSelector` over `promptUser`, `extractorAgent` over `interpreterAgent`

## Agent Design (LLM-driven features)

- 🔴 NEVER hardcode what an LLM can decide - use `generateObject` with Zod schema
- 🔴 NEVER hardcode option/suggestion arrays - LLM should generate contextual options
- Agents should be like pure functions - single transformation, no side effects
- Name agents after their OUTPUT type (e.g., `proseAgent` outputs `Prose`)
- Schema-first - define Zod schema before prompt, schema IS the contract
- Add .describe() to Zod fields to guide LLM on ambiguous fields
- Trust the model - don't over-prescribe what it already understands

## Refactoring

- Always check data shapes when connecting different parts of system (id vs name mismatches)
- Always keep intuitive file organization - things live where you'd expect
- Always make external services injectable via optional params with factory defaults
- 🔴 Utils must have zero imports from project code - only external dependencies allowed

## Testing

- Always co-locate tests: `file.ts` → `file.test.ts`
- Always run `npm run test:run` and `npm run typecheck` before PR
- Always test with real data before committing performance optimizations

## Collaboration

- Trust terse instructions - execute, do not over-ask
- Always default to simpler solution even if it feels "wasteful"
- Do one spike to validate assumptions, then commit - avoid fix-forward chains

## Examples

### Pure Functions

```ts
// INCORRECT - side effect, mutates external state
let count = 0;
function increment() { count++; }

// CORRECT - pure, returns new value
function increment(count: number): number { return count + 1; }
```

### Data Flow

```ts
// INCORRECT - global state
const config = { apiKey: '' };
function fetchData() { return fetch(url, { headers: { key: config.apiKey } }); }

// CORRECT - explicit parameters
function fetchData(apiKey: string) { return fetch(url, { headers: { key: apiKey } }); }
```

### Premature Abstraction

```ts
// INCORRECT - abstraction for one use case
const createHandler = (type: string) => (data: unknown) => process(type, data);
const userHandler = createHandler('user');

// CORRECT - direct and simple
function handleUser(data: unknown) { return process('user', data); }
```

### Agent Design - Hardcoded vs LLM-generated

```ts
// 🔴 INCORRECT - hardcoded suggestions
const answer = await select({
  message: 'Adjust the tone?',
  choices: [
    { name: 'Make it more playful', value: 'playful' },
    { name: 'Make it more heartfelt', value: 'heartfelt' },
  ],
});

// ✅ CORRECT - LLM generates contextual suggestions
const ToneResponseSchema = z.object({
  options: z.array(z.string()).describe('Story-specific tone suggestions'),
});
const response = await generateObject({ schema: ToneResponseSchema, ... });
const answer = await showSelector({
  question: 'Adjust the tone?',
  options: response.options,
});
```
