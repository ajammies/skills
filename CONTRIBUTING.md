# Contributing

Contributions welcome! This document covers best practices for creating and improving skills.

## Skill Structure

```
skill-name/
├── SKILL.md              # Required: Core instructions
├── scripts/              # Optional: Executable automation (Python/Bash)
├── references/           # Optional: Detailed docs loaded into context
└── assets/               # Optional: Templates, images (referenced by path only)
```

**Key distinction:** `references/` files consume context tokens when loaded. `assets/` are referenced by path only and don't consume tokens.

## YAML Frontmatter

### Required Fields

```yaml
---
name: skill-name
description: Action-oriented description of what this skill does and when to use it.
---
```

The `description` is critical—Claude uses pure LLM reasoning (no regex or keyword matching) to decide which skill to invoke based on how well the description matches user intent.

### Optional Fields

```yaml
---
name: skill-name
description: ...
allowed-tools: Read,Write,Bash(git:*)   # Scope tool permissions
---
```

**Tool permission patterns:**
- `Read,Write` — Only file operations
- `Bash(git:*)` — Only git commands
- `Bash(npm:*)` — Only npm commands

Only include tools the skill actually needs.

**Avoid:** The `when_to_use` field appears in some codebases but lacks official documentation. Use detailed `description` instead.

## Writing the SKILL.md Body

### Structure

```markdown
# Skill Name

## WORKFLOW

1. **Step** - Description
   ⏸️ Pause for user input if needed

## Principles

- Key principle

## References

| Topic | File | When to Read |
|-------|------|--------------|
| Patterns | references/patterns.md | When implementing X |
```

### Language Guidelines

- Use imperative form ("Analyze code" not "Analyzing code")
- Keep under 5,000 words to prevent context bloat
- Use `{baseDir}` for file paths, never hardcode absolute paths
- Challenge each line: "Does Claude actually need this?"

### Common Patterns

| Pattern | Use Case |
|---------|----------|
| **Script Automation** | Offload computational tasks to `scripts/` |
| **Read-Process-Write** | Simple file transformation |
| **Search-Analyze-Report** | Grep patterns, analyze, generate report |
| **Command Chain** | Sequential multi-step operations |
| **Wizard-Style** | Multi-step with user confirmation between phases |

## Progressive Disclosure

Keep SKILL.md lean. Move details to bundled files:

```markdown
## Advanced Features

- **Form handling**: See [references/forms.md](references/forms.md)
- **API details**: See [references/api.md](references/api.md)
```

Claude loads these only when needed, saving context tokens.

## Adding a New Skill

1. Create the skill directory with `SKILL.md`
2. Write clear frontmatter with action-oriented description
3. Add `scripts/`, `references/`, `assets/` as needed
4. Test the skill in a real project
5. Submit PR with:
   - Clear description of purpose
   - Example use cases
   - Any dependencies

## Improving Existing Skills

1. Test current behavior
2. Make changes
3. Test again
4. Submit PR with before/after examples

## Questions?

Open an issue for discussion before major changes.

---

*Based on best practices from [Claude Skills Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)*
