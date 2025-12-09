# Skills Repository

A composable collection of Claude Code skills and commands.

## Project Rules

### Commands

- **Semantic fuzzy search**: All parameterized commands must support semantic fuzzy search, not just exact ID matching
- **Commands vs skills**: Commands are single-action prompts. Skills are multi-step workflows. Commands route to skills when orchestration is needed.

### Git Workflow

- **Push main before branching**: Always `git push origin main` before creating feature branches to avoid stale commits polluting PRs
- Branch from `main`: `<type>/<description>`
- Squash merge after approval

### Skill Design

- Skills are self-contained - duplicate short content (< 30 lines) rather than sharing references
- Each skill defines its own appropriate steps - never force a template step count
- When user says "do inline" or "don't make separate steps", incorporate into existing steps

### References

- [anthropics/skills](https://github.com/anthropics/skills)
- [diet103 showcase](https://github.com/diet103/claude-code-infrastructure-showcase)
- [deep dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)
