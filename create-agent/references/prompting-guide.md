# Prompting Guide for generateObject

## Table of Contents
- [System vs User Prompt](#system-vs-user-prompt)
- [Domain Knowledge vs Instructions](#domain-knowledge-vs-instructions)
- [Examples Over Explanations](#examples-over-explanations)
- [Prompt Patterns](#prompt-patterns)
- [Anti-Patterns](#anti-patterns)

## System vs User Prompt

**System prompt:** Role, context, domain knowledge, output guidelines
**User prompt:** The actual input data to transform

```typescript
await generateObject({
  model: getModel(),
  schema: OutputSchema,
  system: SYSTEM_PROMPT,  // Role and domain knowledge
  prompt: JSON.stringify(input, null, 2),  // Input data
});
```

## Domain Knowledge vs Instructions

**Bad - step-by-step instructions:**
```
1. First, read the story brief
2. Then, extract the title
3. Next, identify the main character
4. After that, determine the setting
5. Finally, format as JSON
```

**Good - domain knowledge:**
```
Write a complete manuscript, which contains the text and imagePrompt for each page of the book.

The blurb contains 5-6 structural beats (setup, conflict, rising_action, climax, resolution). Expand each beat into multiple pages based on pageCount. Use your best judgement based on the narrative, age range, style, to pace the story.


Writing guidelines by age:
- Ages 2-5: Simple words, rhythmic patterns, 1-2 sentences per page
- Ages 6-9: Longer sentences, more vocabulary, up to a paragraph

Best Practices to follow:
- Do not describe visuals in the story, the illustration will do show this
...
```

Provide clear explanation of inputs / outputs, constraints, best practices.

## Examples Over verbose explanations

**Bad - verbose explanation:**
```
The plotBeats field should contain an array of objects where each object has a purpose field that is one of the following enum values: setup, conflict, rising_action, climax, or resolution. The purpose field indicates the narrative function of that beat in the overall story structure. Additionally, each object should have a description field that contains a string describing what happens during that beat.
```

**Good - concrete example:**
```
plotBeats (5-6 beats with purpose labels):
- setup: Introduce character, world, and status quo
- conflict: The problem, challenge, or inciting incident
- rising_action: Attempts, obstacles, escalation (can have 1-2 of these)
- climax: The turning point or biggest moment
- resolution: How it ends, what's learned
```

## Prompt Patterns

### Transformation Agent
```typescript
const SYSTEM_PROMPT = `Transform [input type] into [output type].

[Domain constraints and knowledge]

Output requirements:
- [Requirement 1]
- [Requirement 2]`;
```

### Conversation Agent
```typescript
const SYSTEM_PROMPT = `[Role description]. Ask questions to gather [information type].

Current state: [What we know so far]

Ask about:
- [Topic 1] if missing
- [Topic 2] if unclear

Provide helpful suggestions when appropriate.`;
```

### Interpreter Agent
```typescript
const SYSTEM_PROMPT = `Modify [data type] based on user feedback.

Users may reference items by [identifier type].

Rules:
- [Constraint 1]
- [Constraint 2]
- Preserve items the user didn't mention`;
```

### Generator Agent
```typescript
const SYSTEM_PROMPT = `Generate [output type] from [input type].

[Domain knowledge about the output format]

Guidelines by [context variable]:
- [Context 1]: [Guidelines]
- [Context 2]: [Guidelines]`;
```

## Anti-Patterns

### 1. Redundant Instructions
```
// Bad - model knows how to converse
"When the user says hello, respond with a greeting. When they ask a question, answer it."

// Good - provide context, trust conversational ability
"You are gathering story preferences from a parent creating a book for their child."
```

### 2. Over-Specifying Format
```
// Bad - fighting the schema
"Return a JSON object with the following structure: { title: string, ... }"

// Good - schema handles format, prompt handles content
"Create a story title that captures the adventure's spirit."
```

### 3. Conditional Logic in Prompts
```
// Bad - hardcoding decisions
"If the user mentions approval words like 'yes', 'okay', 'looks good', set isComplete to true."

// Good - let model understand intent
"Set isComplete=true when the user approves the current state."
```


## Prompt Length

- Keep prompts under 500 words
- Move property specific examples and instructions to zod schema `.describe()`
- Use bullet points for lists
