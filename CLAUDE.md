# Project Guidelines

<!--
This is a template CLAUDE.md file. Copy this to your project root and customize.
Claude reads this file to understand project-specific context, conventions, and constraints.
-->

## Project Overview

<!-- Describe what this project does in 1-2 sentences -->

## Tech Stack

<!-- List key technologies, frameworks, and tools -->
- Language:
- Framework:
- Testing:
- Database:

## Architecture

<!-- Describe the high-level structure -->

```
src/
├── core/           # Business logic
├── api/            # API routes/handlers
├── lib/            # Shared utilities
└── types/          # Type definitions
```

## Development Commands

```bash
# Development
npm run dev

# Testing
npm run test        # Watch mode
npm run test:run    # Single run
npm run typecheck   # Type checking

# Build
npm run build
```

## Coding Standards

<!-- These are loaded from skills but you can add project-specific overrides -->

### File Organization

- Co-locate tests: `file.ts` → `file.test.ts`
- Keep related code together
- No circular dependencies

### Naming Conventions

- Files: `kebab-case.ts`
- Functions: `camelCase`
- Types/Interfaces: `PascalCase`
- Constants: `SCREAMING_SNAKE_CASE`

### Code Style

- Prefer pure functions over classes
- Use explicit types for function boundaries
- No magic numbers/strings
- Single responsibility per function

## Git Workflow

<!-- Customize for your team's process -->

1. **Always push main before branching** - Avoid stale commits polluting PRs
2. Create branch from `main`: `<type>/<description>`
3. Make atomic commits with descriptive messages
4. Run tests before pushing
5. Create PR with description and test plan
6. Squash merge after approval

### Branch Prefixes

- `feat/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code improvements
- `docs/` - Documentation
- `test/` - Test additions

## Environment Setup

<!-- Document any required setup steps -->

```bash
# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your values

# Run database migrations (if applicable)
npm run db:migrate
```

## Key Files

<!-- Point Claude to important files for context -->

| File | Purpose |
|------|---------|
| `src/core/index.ts` | Main entry point |
| `src/types/index.ts` | Shared type definitions |
| `.env.example` | Required environment variables |

## Constraints

<!-- List any hard constraints Claude should never violate -->

- Never commit secrets or credentials
- Always run tests before creating PRs
- Keep bundle size under X KB (if applicable)
- Maintain backwards compatibility for public APIs

## Known Issues

<!-- Document workarounds or gotchas -->

- Issue description → Workaround

## External Resources

<!-- Links to relevant documentation -->

- [API Documentation](link)
- [Design System](link)
- [Architecture Decision Records](link)

## Skill Design

Skills are self-contained. Duplicate short content (< 30 lines) rather than sharing references across skills. See [anthropics/skills](https://github.com/anthropics/skills), [diet103 showcase](https://github.com/diet103/claude-code-infrastructure-showcase), [deep dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/), [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code).
