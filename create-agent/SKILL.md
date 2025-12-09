---
name: create-agent
allowed-tools: Read, Edit, Grep, Glob
description: |
  Comprehensive Agent Design, Creation and modification using Vercel AI SDK generateObject with Zod schemas. used when claude needs to create, prompt, modify, fix, refactor or improve any agent code, and any time a Zod Schema is modified that is used by an agent.

  Covers: agent architecture, Zod schema patterns, .describe() usage, prompting for structured output, error handling.
---

# Agent creation, modification, error handling

## Table of Contents
- [Workflow](#workflow)
- [Principles](#principles)
- [Functional Composition](#functional-composition)
- [Template](#template)
- [When to Use](#when-to-use--not-use)
- [References](#references)
- [Checklist](#checklist)
- [Limitations](#limitations)

## Workflow

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

1. **Understand** - Read existing schemas and agents in the area

2. **Schema first** - Define Zod schema with `.describe()` on ambiguous fields
   ⏸️ **STOP**: Review schema design with user. Wait for user input before continuing.

3. **Prompt** - Write system prompt with domain knowledge (not step-by-step)

4. **Implement** - Create agent as pure function, single transformation
   ⏸️ **STOP**: Review implementation with user. Wait for user input before continuing.

5. **Test** - Add tests for valid input, edge cases, malformed input

**Escalation**: If agent fails validation 3 times, use context7 to research the pattern before continuing.

## Principles

- **Name agents after their output** — `proseAgent` outputs `Prose`, `visualsAgent` outputs `VisualDirection`
- **Schema-first** — Define Zod schema before prompt. Schema IS the contract.
- **Explicit `.describe()`** — LLMs make mistakes unless explicitly guided. Use `.describe()` on every ambiguous field.
- **Agents as pure functions** — Single transformation, minimal scope. Split complex tasks into chained agents.
- **LLMs interpret, not regex** — Never pattern match fuzzy text. Use a small agent instead.
- **Domain knowledge > instructions** — Tell it WHAT constraints exist, not step-by-step HOW.

## Functional Composition

Large schemas fail. Split into focused agents, each producing one piece:

```
// Bad: one agent does everything
StoryBrief → everythingAgent → Story ❌

// Good: chain of focused agents
StoryBrief → plotAgent → PlotStructure
StoryWithPlot → proseAgent → Prose
StoryWithProse → visualsAgent → VisualDirection

// Types compose linearly:
StoryWithPlot = StoryBrief & { plot: PlotStructure }
StoryWithProse = StoryWithPlot & { prose: Prose }
ComposedStory = StoryWithProse & { visuals: VisualDirection }
```

**Each agent:** ~10-20 fields max, single transformation, independently testable.

## Template

```typescript
import { generateObject } from 'ai';
import { ProseSchema, type StoryWithPlot, type Prose } from '../schemas';
import { getModel } from '../config';

const SYSTEM_PROMPT = `Domain knowledge here. Not step-by-step instructions.`;

// Agent named after output: proseAgent → Prose
export const proseAgent = async (input: StoryWithPlot): Promise<Prose> => {
  const { object } = await generateObject({
    model: getModel(),
    schema: ProseSchema,
    system: SYSTEM_PROMPT,
    prompt: JSON.stringify(input, null, 2),
  });
  return object;
};
```

## When to Use / Not Use

| Create Agent | Don't Create Agent |
|--------------|-------------------|
| Unstructured → structured | Simple validation |
| Requires reasoning | Deterministic transforms |
| Needs creativity | Pattern matching suffices |

## References

| Topic | File | When to Read |
|-------|------|--------------|
| Schema patterns | [zod-patterns.md](references/zod-patterns.md) | Designing schemas, using `.describe()` |
| Prompting | [prompting-guide.md](references/prompting-guide.md) | Writing system prompts |
| Errors | [error-handling.md](references/error-handling.md) | NoObjectGeneratedError, debugging |

## Checklist

**Design:**
- [ ] Agent named after output type (`fooAgent` → `Foo`)
- [ ] Single responsibility (one transformation)
- [ ] Schema < 20 fields (split if larger)
- [ ] Input/output types explicit

**Schema:**
- [ ] Schema defined before prompt
- [ ] `.describe()` on ambiguous/similar fields

**Prompt:**
- [ ] System prompt provides domain knowledge, not steps
- [ ] System prompt < 500 words

**Implementation:**
- [ ] Single return statement
- [ ] Tests cover valid input, edge cases, malformed input

## Limitations

This skill does NOT cover:
- Streaming responses (useChat, streamObject)
- Tool calling / function calling
- Multi-turn conversations (use conversation patterns instead)
- Non-Vercel AI SDK implementations
- Retry/resilience logic (consider Inngest for that)
