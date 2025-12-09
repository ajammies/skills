---
name: research
description: Research topics across codebase and online sources. Use when user asks to research best practices, explore how something works, find patterns, or gather information before implementation. Supports semantic queries like "React state management patterns" or "authentication best practices".
---

# Research

Explore codebase and online sources to gather information on a topic.

## WORKFLOW

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Clarify - Understand the research question
- Identify the core question or topic
- Determine scope: codebase-only, online-only, or both
- Note any constraints (specific frameworks, patterns, etc.)
- ⏸️ Confirm understanding if ambiguous

### Step 2: Explore codebase - Find existing patterns
- Use Explore agent to search for relevant implementations
- Look for existing solutions, patterns, or related code
- Note file locations and approaches used
- Skip if scope is online-only

### Step 3: Search online - Gather external knowledge
- Search for authoritative sources (official docs, engineering blogs, GitHub repos)
- Recursively follow promising links for deeper context
- Prioritize: official docs > engineering blogs > Stack Overflow > tutorials
- Skip if scope is codebase-only

### Step 4: Synthesize - Compile findings
- Combine codebase and online findings
- Relate external best practices to project context
- Output using Research Report format below

## Output Format

### Research Report

```markdown
## Summary

[1-2 sentence answer to the research question]

## Codebase Findings

- `path/to/file.ts:123` - [What was found, how it's relevant]
- [Other relevant code locations]

## Online Findings

- [Source Title](url) - [What was learned]
- [Source Title](url) - [What was learned]

## Recommendations

1. **[Recommendation name]** - [Brief description]
   - Why: [Reasoning]
   - How: [Implementation approach]

2. **[Recommendation name]** - [Brief description]
   - Why: [Reasoning]
   - How: [Implementation approach]
```

## Principles

- **Codebase first** - Understand existing patterns before suggesting new ones
- **Authoritative sources** - Prefer official docs and proven engineering blogs
- **Context matters** - Relate findings back to the specific project
- **Cite sources** - Always include URLs for external information
- **AI-first** - Focus on clarity, structure, and verifiable outputs (no human-only advice like time-boxing)

## Code Rules

- Make it as simple as possible, but not simpler
- Write code that is easy to delete - loose coupling, no tentacles
- Keep functions small enough to fit in your head
- Do not abstract until you see the pattern three times
- Prefer explicit over implicit - no magic
- Always read file before editing - never propose changes to code you haven't read
- Use pure functions, immutability, no side effects
- Flow data through parameters, not global state
- Use explicit types for data flowing between functions
- Use 2-3 params direct; 4+ use options object
- Use const by default for parameters
- Minimize control flow complexity - favor consistent execution paths
