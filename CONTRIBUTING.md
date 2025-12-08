# Contributing

Contributions are welcome! This document outlines how to contribute new skills or improve existing ones.

## Adding a New Skill

1. **Create the skill directory**
   ```
   skill-name/
   └── SKILL.md
   ```

2. **Write the SKILL.md** with required frontmatter:
   ```markdown
   ---
   name: skill-name
   description: Clear description of what this skill does and when to use it.
   ---

   # Skill Name

   ## WORKFLOW

   1. **Step** - Description
   2. **Step** - Description

   ## Principles

   - Key principle
   ```

3. **Test the skill** in a real project before submitting

4. **Submit a PR** with:
   - Clear description of the skill's purpose
   - Example use cases
   - Any dependencies or requirements

## Skill Guidelines

### Keep It Focused

Each skill should do one thing well. Prefer multiple focused skills over one large skill.

### Be Concise

The context window is shared. Challenge each line: "Does Claude need this?"

### Use Progressive Disclosure

- Keep SKILL.md under 500 lines
- Move detailed references to `references/` subdirectory
- Only load extra context when needed

### Follow the Format

- Use imperative form ("Run tests" not "Running tests")
- Include a WORKFLOW section with numbered steps
- Mark pause points with `⏸️`
- Use tables for reference information

## Improving Existing Skills

1. Test the current skill behavior
2. Make your changes
3. Test again to verify improvement
4. Submit PR with before/after examples if applicable

## Code Style

- YAML frontmatter must include `name` and `description`
- Use consistent markdown formatting
- Keep examples minimal but complete

## Questions?

Open an issue for discussion before major changes.
