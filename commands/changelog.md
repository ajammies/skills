# Generate Changelog

Generate changelog entries from git commits.

## Usage

```
/changelog [version or search terms]
```

Arguments: $ARGUMENTS

## Behavior

1. **If version provided (e.g., `v1.2.0`):** Generate changelog since last tag up to this version
2. **If search terms provided:** Find commits semantically matching the description
3. **If no arguments:** Generate changelog for all commits since last tag

4. Categorize commits by type (feat, fix, refactor, etc.)
5. Format as user-friendly changelog with descriptions
6. Optionally create annotated git tag

## Output Format

```markdown
## [v1.2.0] - 2025-01-15

### Added
- User authentication with OAuth support (#123)
- Dark mode toggle in settings (#456)

### Fixed
- Null pointer in API response handler (#789)

### Changed
- Refactored date utilities for clarity
```

## Examples

```
/changelog                  # Since last tag
/changelog v2.0.0           # Generate for specific version
/changelog auth changes     # Find auth-related commits
/changelog last week        # Recent changes
```

## Commands

```bash
# Commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Create annotated tag
git tag -a v1.2.0 -m "Release v1.2.0"

# List tags
git tag -l
```

## Commit Type Mapping

| Prefix | Changelog Section |
|--------|-------------------|
| feat: | Added |
| fix: | Fixed |
| refactor: | Changed |
| docs: | Documentation |
| perf: | Performance |
| breaking: | Breaking Changes |
