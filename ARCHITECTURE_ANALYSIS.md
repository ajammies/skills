# Skills Architecture Analysis & Recommendations

## Executive Summary

Your current skills collection suffers from **identity confusion**, **scope creep**, and **missing workflows**. The skills blur the line between:
- Project-specific conventions vs reusable workflows
- Skills (expertise provision) vs Agents (execution delegation)
- High-level philosophy vs actionable procedures

This analysis proposes a restructured architecture with clear separation of concerns.

---

## Current State Assessment

### Skill-by-Skill Analysis

| Skill | Type | Issues | Verdict |
|-------|------|--------|---------|
| `code-rules` | Philosophy/Standards | Too broad, mixes philosophy with agent design rules | **SPLIT** |
| `commit` | Workflow | Good focus, but overlaps with `pr-workflow` | **MERGE** |
| `create-issue` | Workflow | Good, but should be part of broader issue management | **EXPAND** |
| `create-skill` | Meta/Tooling | Overly verbose, references bloat context | **SIMPLIFY** |
| `design-agent` | Technical Guide | Excellent structure, but too project-specific (Vercel AI SDK) | **KEEP** |
| `find-pattern` | Workflow | Too thin, unclear trigger conditions | **MERGE or DELETE** |
| `pr-workflow` | Workflow | Overly prescriptive, conflates planning with execution | **REFACTOR** |
| `reflect` | Workflow | Good concept, but output format is rigid | **KEEP** |

### Architectural Problems

#### 1. Overlapping Triggers
Multiple skills trigger on similar conditions:
- `pr-workflow` says "ALWAYS use when user asks to start an issue, work on an issue..."
- `create-issue` says "Use when creating issues, viewing issues..."
- Both fight for the same user intent

#### 2. Mixed Abstraction Levels
`code-rules` contains:
- High-level philosophy ("make it as simple as possible")
- Specific agent design patterns (Vercel AI SDK generateObject)
- Testing conventions
- Collaboration guidelines

These serve different purposes and should live separately.

#### 3. Project-Specific vs Universal
Several skills encode project-specific assumptions:
- `pr-workflow` assumes `npm run test:run && npm run typecheck`
- `find-pattern` hardcodes paths like `src/core/agents/`
- `code-rules` mentions "pino" logger and "context7"

These should be in project `CLAUDE.md`, not universal skills.

#### 4. Missing Critical Workflows

| Gap | Description | Impact |
|-----|-------------|--------|
| **Debugging** | No skill for systematic debugging | Ad-hoc, inconsistent debugging |
| **Code Review** | No skill for reviewing others' code | Missing quality gate |
| **Logging/Observability** | No guidance for adding logging | Inconsistent observability |
| **Testing Strategy** | Scattered across skills | No unified testing approach |
| **Error Handling** | Only in `design-agent` context | Missing general patterns |
| **Documentation** | No skill for writing docs | Inconsistent documentation |
| **Performance** | No profiling/optimization guidance | Performance issues missed |
| **Security** | No security review workflow | Vulnerabilities missed |

#### 5. Skills vs Agents Misuse

`find-pattern` is described as a skill but behaves like what the **Explore agent** does. It should either:
- Be deleted (use Explore agent directly)
- Become an agent definition with specific search patterns

---

## Proposed Architecture

### Tier 1: Foundation (Always-on philosophy)

```
philosophy/
└── SKILL.md     # Core coding philosophy - lean, 20 lines max
```

**Content**: Only universal, timeless principles. No project-specific tools, no framework references.

```yaml
---
name: philosophy
description: Core coding principles. Auto-activates for all code changes.
---
```

### Tier 2: Workflows (Task-triggered procedures)

```
git-workflow/
└── SKILL.md     # Unified: branch → commit → PR → merge

debug/
└── SKILL.md     # Systematic debugging procedure

code-review/
└── SKILL.md     # Reviewing code (own or others')

test/
└── SKILL.md     # Test strategy and execution

document/
└── SKILL.md     # Writing documentation
```

### Tier 3: Technical Guides (Domain expertise)

```
agent-design/
├── SKILL.md
└── references/
    ├── zod-patterns.md
    ├── prompting-guide.md
    └── error-handling.md

skill-authoring/
├── SKILL.md          # Simplified from create-skill
└── scripts/
    └── validate.py   # Single validation script
```

### Tier 4: Meta/Improvement

```
reflect/
└── SKILL.md     # End-of-session reflection (keep as-is)
```

### What to DELETE

| Skill | Reason | Replacement |
|-------|--------|-------------|
| `find-pattern` | Use Explore agent instead | Built-in Task tool |
| `create-issue` | Merge into `git-workflow` | Unified workflow |
| `commit` | Merge into `git-workflow` | Unified workflow |

### What Should Be AGENTS, Not Skills

| Task | Why Agent? | Agent Type |
|------|-----------|------------|
| Codebase exploration | Context isolation, parallel search | Explore (built-in) |
| Security review | Specialized, deep analysis | Custom agent |
| Performance profiling | Long-running, separate context | Custom agent |
| Test execution | Parallel, isolated output | Custom agent |

---

## Detailed Skill Redesigns

### 1. `philosophy` (NEW - replaces `code-rules`)

```yaml
---
name: philosophy
description: Core coding principles. Reference before any code changes.
---
```

```markdown
# Philosophy

- Simple as possible, but not simpler
- Easy to read, easy to delete
- Pure functions, no side effects
- Explicit over implicit
- No abstraction until pattern repeats 3x
- Small functions that fit in your head

## Code Flow
- Data through parameters, not global state
- 2-3 params direct, 4+ use options object
- Explicit types at function boundaries

## Testing
- Co-locate: `file.ts` → `file.test.ts`
- Test before commit
```

**~30 lines. No framework references. Universal.**

### 2. `git-workflow` (NEW - consolidates commit, create-issue, pr-workflow)

```yaml
---
name: git-workflow
description: |
  Git operations: branching, commits, issues, PRs. Use when:
  - Starting work on a feature or bug
  - Making commits
  - Creating or managing issues
  - Opening or merging PRs
---
```

```markdown
# Git Workflow

## Starting Work

1. **Branch** from main
   ```bash
   git checkout main && git pull
   git checkout -b <type>/<name>
   ```
   Types: `feat/`, `fix/`, `refactor/`, `docs/`

2. **Plan** - Break into atomic commits (1-3 files each)
   ⏸️ Get approval before coding

## Committing

```bash
git add <files>
git commit -m "<type>: <title>" -m "<description - explain WHY>"
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`

## Issues

```bash
# Create
gh issue create --title "<title>" --body "<context + acceptance criteria>"

# View
gh issue list

# Close
gh issue close <number> --reason completed
```

## Pull Requests

1. Push: `git push -u origin <branch>`
2. Create: `gh pr create --title "<title>" --body "Closes #<issue>"`
3. After approval: `gh pr merge --squash --delete-branch`

## Principles

- Atomic commits - one logical change each
- Explain the WHY in commit messages
- Link PRs to issues with "Closes #N"
```

### 3. `debug` (NEW)

```yaml
---
name: debug
description: |
  Systematic debugging workflow. Use when:
  - Investigating errors or unexpected behavior
  - User reports a bug
  - Tests are failing
  - Something "doesn't work"
---
```

```markdown
# Debug

## WORKFLOW

1. **Reproduce** - Get exact steps to trigger the issue
   - What input causes it?
   - Is it consistent or intermittent?

2. **Isolate** - Narrow the scope
   - Which file/function?
   - What's the last known good state?
   - `git bisect` if needed

3. **Inspect** - Gather data
   - Add logging at boundaries
   - Check actual vs expected values
   - Verify assumptions about data shapes

4. **Hypothesize** - Form theory about root cause
   - State your hypothesis explicitly
   ⏸️ Validate hypothesis with user

5. **Fix** - Minimal change to resolve
   - Fix the bug, not symptoms
   - Add regression test

6. **Verify** - Confirm fix works
   - Run tests
   - Check original reproduction steps

## Anti-patterns

- Don't fix symptoms (null checks everywhere)
- Don't assume - verify with logs
- Don't change multiple things at once
```

### 4. `code-review` (NEW)

```yaml
---
name: code-review
description: |
  Code review checklist and process. Use when:
  - Reviewing a PR
  - Asked to review code
  - Self-reviewing before commit
---
```

```markdown
# Code Review

## Checklist

### Correctness
- [ ] Does it do what it claims?
- [ ] Edge cases handled?
- [ ] Error paths covered?

### Design
- [ ] Single responsibility?
- [ ] Easy to delete?
- [ ] No premature abstraction?

### Security
- [ ] Input validated at boundaries?
- [ ] No secrets in code?
- [ ] No injection vulnerabilities?

### Testing
- [ ] Tests exist for new code?
- [ ] Tests cover failure cases?
- [ ] Tests are deterministic?

### Readability
- [ ] Clear naming?
- [ ] Comments explain WHY, not WHAT?
- [ ] No dead code?

## Feedback Format

```
**File**: path/to/file.ts:42
**Issue**: [bug|design|security|style|question]
**Comment**: Explain the concern
**Suggestion**: (optional) How to fix
```
```

### 5. `test` (NEW)

```yaml
---
name: test
description: |
  Testing strategy and execution. Use when:
  - Writing new tests
  - Deciding what to test
  - Tests are failing
  - Asked about test coverage
---
```

```markdown
# Test

## What to Test

| Priority | Test Type | Coverage |
|----------|-----------|----------|
| High | Happy path | Core functionality works |
| High | Error cases | Failures handled gracefully |
| Medium | Edge cases | Boundaries, nulls, empty |
| Low | Integration | Components work together |

## Structure

```typescript
describe('functionName', () => {
  it('should [expected behavior] when [condition]', () => {
    // Arrange
    const input = ...;

    // Act
    const result = functionName(input);

    // Assert
    expect(result).toEqual(expected);
  });
});
```

## Principles

- Test behavior, not implementation
- One assertion per test (ideally)
- Tests should be fast and deterministic
- Mock external services, not internal modules
- If it's hard to test, the design needs work
```

### 6. `agent-design` (KEEP, minor updates)

Remove `allowed-tools` from frontmatter (unnecessary restriction for a guide).

Keep the references structure - it's well-designed for progressive disclosure.

### 7. `skill-authoring` (SIMPLIFIED from create-skill)

```yaml
---
name: skill-authoring
description: |
  Guide for creating Claude skills. Use when user wants to create or update a skill.
---
```

```markdown
# Skill Authoring

## Structure

```
skill-name/
├── SKILL.md              # Required
├── scripts/              # Optional: executable automation
├── references/           # Optional: detailed docs (loaded into context)
└── assets/               # Optional: templates, files (referenced by path)
```

## SKILL.md Template

```yaml
---
name: skill-name
description: |
  What it does. When to use it:
  - Trigger condition 1
  - Trigger condition 2
---
```

```markdown
# Skill Name

## WORKFLOW

1. **Step** - Description
   ⏸️ Pause for user input

## Principles

- Principle 1
- Principle 2
```

## Guidelines

- Keep SKILL.md under 500 lines
- Use imperative form ("Run tests" not "Running tests")
- Description determines when skill triggers - be specific
- Move detailed docs to `references/`
- Scripts in `scripts/` can execute without loading into context

## Validation

Run: `python scripts/validate.py <skill-path>`
```

Delete the verbose `init_skill.py` and `package_skill.py` - they add complexity without proportional value.

---

## Agent Recommendations

### Use Built-in Explore Agent For:

Instead of `find-pattern` skill:

```markdown
When searching codebase:
- Use Task tool with subagent_type=Explore
- Specify thoroughness: quick, medium, very thorough
- Results stay in agent's context, not main conversation
```

### Create Custom Agents For:

#### 1. Security Review Agent

```markdown
# .claude/agents/security-review.md

---
name: security-reviewer
description: Deep security analysis with restricted scope
allowed-tools: Read,Grep,Glob
---

Analyze code for security vulnerabilities:
- Input validation
- Authentication/authorization
- Injection risks (SQL, XSS, command)
- Secrets exposure
- Dependency vulnerabilities

Output: Security report with severity ratings
```

#### 2. Performance Profiler Agent

```markdown
# .claude/agents/performance.md

---
name: performance-profiler
description: Identify performance bottlenecks
allowed-tools: Read,Grep,Glob,Bash(read-only)
---

Analyze for performance issues:
- N+1 queries
- Unnecessary re-renders
- Large bundle imports
- Blocking operations
- Memory leaks

Output: Performance report with actionable fixes
```

---

## Migration Plan

### Phase 1: Consolidate (Do First)

1. Create `git-workflow` by merging `commit`, `create-issue`, and `pr-workflow`
2. Delete `find-pattern` (use Explore agent)
3. Create lean `philosophy` from `code-rules`

### Phase 2: Fill Gaps

1. Create `debug` skill
2. Create `code-review` skill
3. Create `test` skill

### Phase 3: Simplify

1. Slim down `create-skill` → `skill-authoring`
2. Remove project-specific references from all skills
3. Move project-specific config to `CLAUDE.md` template

### Phase 4: Add Agents

1. Document when to use Explore agent
2. Create security-review agent definition
3. Create performance agent definition

---

## Final Proposed Structure

```
~/.claude/skills/
├── README.md
├── CLAUDE.md              # Template for projects
├── CONTRIBUTING.md
├── LICENSE
│
├── philosophy/            # Tier 1: Foundation
│   └── SKILL.md
│
├── git-workflow/          # Tier 2: Workflows
│   └── SKILL.md
├── debug/
│   └── SKILL.md
├── code-review/
│   └── SKILL.md
├── test/
│   └── SKILL.md
│
├── agent-design/          # Tier 3: Technical Guides
│   ├── SKILL.md
│   └── references/
│       ├── zod-patterns.md
│       ├── prompting-guide.md
│       └── error-handling.md
├── skill-authoring/
│   ├── SKILL.md
│   └── scripts/
│       └── validate.py
│
└── reflect/               # Tier 4: Meta
    └── SKILL.md
```

**Deleted:**
- `code-rules/` (replaced by `philosophy/`)
- `commit/` (merged into `git-workflow/`)
- `create-issue/` (merged into `git-workflow/`)
- `pr-workflow/` (merged into `git-workflow/`)
- `find-pattern/` (use Explore agent)
- `create-skill/` (simplified to `skill-authoring/`)

**Added:**
- `philosophy/` (lean principles)
- `git-workflow/` (consolidated)
- `debug/` (new)
- `code-review/` (new)
- `test/` (new)
- `skill-authoring/` (simplified)

---

## Summary of Changes

| Current | Proposed | Action |
|---------|----------|--------|
| 8 skills | 7 skills | Net reduction |
| ~1500 lines | ~500 lines | 67% reduction |
| Overlapping triggers | Clear separation | No conflicts |
| Project-specific | Universal | Portable |
| Missing workflows | Complete coverage | No gaps |
| Skills only | Skills + Agents | Right tool for job |

---

## Insight from diet103/claude-code-infrastructure-showcase

After reviewing [diet103's infrastructure showcase](https://github.com/diet103/claude-code-infrastructure-showcase), several patterns emerge that address your concern about CLAUDE.md adherence:

### Why Language-Specific Skills Work Better Than CLAUDE.md

1. **Composability**: Skills can be selectively loaded. CLAUDE.md is all-or-nothing.

2. **Progressive Disclosure**: Skills use `references/` for deep dives. The showcase keeps SKILL.md under 500 lines with 11 reference files for backend alone.

3. **Trigger Specificity**: Skills activate on file patterns and keywords. Example: `frontend-dev-guidelines` triggers on `*.tsx` files and terms like "component", "React".

4. **Enforcement Modes**: Their `skill-rules.json` supports:
   - `suggest` - recommendations only
   - `block` - must use skill before proceeding (guardrail)
   - `warn` - alert but allow continuation

### Their Skill Categories

| Category | Example | Trigger Pattern |
|----------|---------|-----------------|
| **Stack Guidelines** | `backend-dev-guidelines` | File paths (`**/routes/**`), keywords ("Express", "controller") |
| **Stack Guidelines** | `frontend-dev-guidelines` | File paths (`**/*.tsx`), keywords ("React", "component") |
| **Tooling** | `skill-developer` | Keywords ("create skill", "skill trigger") |
| **Domain** | `route-tester` | Keywords ("test route", "API test") |
| **Quality** | `error-tracking` | Keywords ("Sentry", "error handling") |

### Hooks for Auto-Activation

The showcase uses **hooks** (not just skill descriptions) to enforce activation:

```
.claude/hooks/
├── skill-activation-prompt.ts   # UserPromptSubmit - suggests skills
└── post-tool-use-tracker.ts     # PostToolUse - tracks outcomes
```

The hook reads `skill-rules.json` and injects skill suggestions into context.

---

## Revised Architecture: Adding Language-Specific Skills

Based on your feedback and the showcase patterns, here's the updated proposal:

### New Tier: Stack-Specific Guidelines

```
typescript/
├── SKILL.md                    # Core TS conventions (~200 lines)
└── references/
    ├── patterns.md             # Common patterns
    ├── error-handling.md       # TS-specific error patterns
    └── testing.md              # TS testing conventions
```

### `typescript` Skill Design

```yaml
---
name: typescript
description: |
  TypeScript development guidelines. Auto-activates when:
  - Working with .ts or .tsx files
  - Creating new TypeScript code
  - Refactoring existing TypeScript
  - Discussing types, interfaces, or generics
---
```

```markdown
# TypeScript Guidelines

## Core Principles

- Explicit types at function boundaries (params and return)
- Use `type` for unions/intersections, `interface` for objects that may be extended
- Prefer `unknown` over `any`; narrow with type guards
- Use `readonly` for immutable data
- Leverage discriminated unions for state machines

## Function Signatures

```typescript
// Good - explicit, self-documenting
function processUser(
  user: User,
  options: ProcessOptions
): Promise<ProcessResult> {
  // ...
}

// Bad - implicit any, unclear return
function processUser(user, options) {
  // ...
}
```

## Type Patterns

### Options Objects (4+ params)

```typescript
interface CreateUserOptions {
  name: string;
  email: string;
  role?: UserRole;
  sendWelcome?: boolean;
}

function createUser(options: CreateUserOptions): Promise<User>
```

### Result Types (instead of throwing)

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function parseConfig(raw: string): Result<Config, ParseError>
```

### Discriminated Unions

```typescript
type RequestState =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: Data }
  | { status: 'error'; error: Error };
```

## Error Handling

- Use custom error classes extending `Error`
- Include context in error messages
- Type catch blocks: `catch (error: unknown)`

```typescript
class ValidationError extends Error {
  constructor(
    message: string,
    public field: string,
    public value: unknown
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

## Testing

- Co-locate: `file.ts` → `file.test.ts`
- Type test data explicitly
- Use `satisfies` for test fixtures

```typescript
const mockUser = {
  id: '123',
  name: 'Test',
  email: 'test@example.com',
} satisfies User;
```

## References

| Topic | File | When to Read |
|-------|------|--------------|
| Common patterns | references/patterns.md | Implementing new features |
| Error handling | references/error-handling.md | Adding error handling |
| Testing | references/testing.md | Writing tests |
```

---

## Final Revised Structure

```
~/.claude/skills/
├── README.md
├── CLAUDE.md                   # Project template (stack-agnostic)
├── CONTRIBUTING.md
├── LICENSE
│
├── typescript/                 # Stack Guidelines (NEW)
│   ├── SKILL.md
│   └── references/
│       ├── patterns.md
│       ├── error-handling.md
│       └── testing.md
│
├── git-workflow/               # Workflows
│   └── SKILL.md
├── debug/
│   └── SKILL.md
├── code-review/
│   └── SKILL.md
│
├── agent-design/               # Technical Guides
│   ├── SKILL.md
│   └── references/
│       ├── zod-patterns.md
│       ├── prompting-guide.md
│       └── error-handling.md
├── skill-authoring/
│   └── SKILL.md
│
└── reflect/                    # Meta
    └── SKILL.md
```

**Key Changes from Previous Proposal:**

1. **Added `typescript/`** - Stack-specific skill with references
2. **Removed `philosophy/`** - Principles now live in `typescript/` (stack-specific) or `CLAUDE.md` (project-specific)
3. **Removed `test/`** - Testing conventions now in `typescript/references/testing.md`
4. **Kept `code-review/`** - Process is language-agnostic

---

## CLAUDE.md Template (for projects)

The `CLAUDE.md` in this repo becomes a template with placeholders:

```markdown
# Project Guidelines

## Project Overview
<!-- Describe what this project does -->

## Stack
- Language: TypeScript (uses `typescript` skill)
- Framework: <!-- e.g., Next.js, Express -->
- Testing: <!-- e.g., Vitest, Jest -->

## Commands
\`\`\`bash
npm run dev        # Development
npm run test       # Tests
npm run typecheck  # Type checking
npm run build      # Production build
\`\`\`

## Project-Specific Conventions

### Logging
<!-- e.g., Use pino logger, not console.log -->

### External Tools
<!-- e.g., Use context7 for library research -->

### Architecture
<!-- Project-specific paths and patterns -->
\`\`\`
src/
├── core/           # Business logic
├── api/            # API routes
└── lib/            # Utilities
\`\`\`

## Constraints
- Never commit secrets
- Run tests before PR
- <!-- Add project-specific constraints -->
```

---

---

## Future Work: Hooks + Skill Rules System

Reference implementation: [diet103/claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase)

### Why Add This

Currently, skill activation relies on Claude reading descriptions and deciding relevance. This is unreliable. The hooks system provides **programmatic enforcement**.

### Architecture Overview

```
User prompt → Hook intercepts → Checks rules → Injects reminder → Claude processes
```

```
.claude/
├── skills/
│   ├── skill-rules.json      # Trigger definitions
│   ├── typescript/
│   └── ...
├── hooks/
│   ├── skill-activation.ts   # UserPromptSubmit hook
│   └── post-tool-tracker.ts  # PostToolUse hook
└── settings.json             # Hook configuration
```

### Implementation Plan

#### Phase 1: Create `skill-rules.json`

Define triggers for each skill:

```json
{
  "skills": [
    {
      "name": "typescript",
      "triggers": {
        "keywords": ["typescript", "interface", "type", "generic"],
        "intentPatterns": ["(create|add|modify).*?(type|interface|function)"],
        "filePaths": ["**/*.ts", "**/*.tsx"],
        "contentPatterns": ["import.*from", "export (function|const|type)"]
      },
      "enforcement": "suggest",
      "priority": "high"
    },
    {
      "name": "git-workflow",
      "triggers": {
        "keywords": ["commit", "branch", "PR", "pull request", "merge", "issue"],
        "intentPatterns": ["(create|start|open|make).*?(PR|pull request|branch|issue)"]
      },
      "enforcement": "suggest",
      "priority": "medium"
    },
    {
      "name": "agent-design",
      "triggers": {
        "keywords": ["agent", "generateObject", "zod", "schema", "LLM"],
        "intentPatterns": ["(create|build|design).*?agent"],
        "filePaths": ["**/agents/**", "**/*agent*.ts"],
        "contentPatterns": ["generateObject", "z\\.object"]
      },
      "enforcement": "suggest",
      "priority": "high"
    },
    {
      "name": "debug",
      "triggers": {
        "keywords": ["bug", "error", "broken", "failing", "doesn't work", "debug"],
        "intentPatterns": ["(fix|debug|investigate|why).*?(error|bug|issue|broken)"]
      },
      "enforcement": "suggest",
      "priority": "high"
    },
    {
      "name": "code-review",
      "triggers": {
        "keywords": ["review", "PR review", "code review", "feedback"],
        "intentPatterns": ["review.*?(code|PR|pull request|changes)"]
      },
      "enforcement": "suggest",
      "priority": "medium"
    },
    {
      "name": "reflect",
      "triggers": {
        "keywords": ["reflect", "session end", "learnings", "improvements"],
        "intentPatterns": ["(reflect|end session|what did we learn)"]
      },
      "enforcement": "suggest",
      "priority": "low"
    }
  ]
}
```

#### Phase 2: Create Activation Hook

`.claude/hooks/skill-activation.ts`:

```typescript
#!/usr/bin/env npx ts-node

import * as fs from 'fs';
import * as path from 'path';

interface SkillRule {
  name: string;
  triggers: {
    keywords?: string[];
    intentPatterns?: string[];
    filePaths?: string[];
    contentPatterns?: string[];
  };
  enforcement: 'suggest' | 'warn' | 'block';
  priority: 'critical' | 'high' | 'medium' | 'low';
}

interface SkillRules {
  skills: SkillRule[];
}

function loadRules(): SkillRules {
  const rulesPath = path.join(__dirname, '../skills/skill-rules.json');
  return JSON.parse(fs.readFileSync(rulesPath, 'utf-8'));
}

function matchSkills(prompt: string, activeFiles: string[]): SkillRule[] {
  const rules = loadRules();
  const promptLower = prompt.toLowerCase();

  return rules.skills.filter(skill => {
    const { triggers } = skill;

    // Check keywords
    const keywordMatch = triggers.keywords?.some(kw =>
      promptLower.includes(kw.toLowerCase())
    );

    // Check intent patterns
    const intentMatch = triggers.intentPatterns?.some(pattern =>
      new RegExp(pattern, 'i').test(prompt)
    );

    // Check file paths (if we have active files)
    const fileMatch = triggers.filePaths?.some(glob =>
      activeFiles.some(file => minimatch(file, glob))
    );

    return keywordMatch || intentMatch || fileMatch;
  });
}

// Main execution
const prompt = process.argv[2] || '';
const activeFiles = JSON.parse(process.env.ACTIVE_FILES || '[]');

const matched = matchSkills(prompt, activeFiles);

if (matched.length > 0) {
  const suggestions = matched
    .sort((a, b) => {
      const priority = { critical: 0, high: 1, medium: 2, low: 3 };
      return priority[a.priority] - priority[b.priority];
    })
    .map(s => `- ${s.name}`)
    .join('\n');

  console.log(`
<skill-reminder>
Relevant skills for this task:
${suggestions}

Invoke with /skill <name> before proceeding.
</skill-reminder>
`);
}
```

#### Phase 3: Configure settings.json

`.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "command": "npx ts-node .claude/hooks/skill-activation.ts \"$PROMPT\"",
        "timeout": 5000
      }
    ]
  }
}
```

#### Phase 4: Add Post-Tool Tracking (Optional)

Track skill usage and outcomes for refinement.

### Testing Plan

1. Create a test prompt for each skill
2. Verify hook fires and suggests correct skill
3. Test edge cases (multiple skills, no match)
4. Tune trigger patterns based on false positives/negatives

### Dependencies

```bash
npm install -D typescript ts-node minimatch @types/node
```

### Reference Files from Showcase

Study these for implementation details:
- `https://github.com/diet103/claude-code-infrastructure-showcase/blob/main/.claude/hooks/skill-activation-prompt.ts`
- `https://github.com/diet103/claude-code-infrastructure-showcase/blob/main/.claude/skills/skill-rules.json`
- `https://github.com/diet103/claude-code-infrastructure-showcase/blob/main/.claude/settings.json`

---

## Next Steps (Current Session)

1. Restructure existing skills (consolidate, add typescript/)
2. Update CLAUDE.md template
3. Leave hooks system for future implementation
