---
name: test
description: |
  Use this skill when writing, improving, or analyzing tests. Supports two modes: (1) Full Coverage - analyze codebase and implement comprehensive tests for gaps, (2) Contextual - write targeted tests for a specific feature, fix, or refactor. Invoke when user asks to: write tests, improve coverage, add test coverage, create unit tests, or test a feature.
---

# Testing Skill

Structured workflow for writing effective tests with full coverage or targeted scope.

## Mode Detection

Determine which mode based on context:

**Full Coverage Mode** - Use when:
- User asks to "improve coverage" or "add missing tests"
- No specific feature/fix/refactor in progress
- User wants comprehensive test analysis

**Contextual Mode** - Use when:
- Called from within `create-feature`, `fix`, or `refactor` workflow
- User asks to "test this feature" or "write tests for X"
- Specific code changes are in progress

---

## Full Coverage Mode

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Analyze - Generate coverage report
```bash
# Python
pytest --cov=src --cov-report=term-missing

# TypeScript
npm run test -- --coverage
```
- Identify files with low or no coverage
- List untested functions and branches
- ⏸️ **STOP**: Present coverage analysis to user. Wait for user input before continuing.

### Step 2: Prioritize - Rank by risk
Prioritize test gaps by:
1. Critical business logic
2. Error handling paths
3. Complex algorithms
4. Integration points
5. Edge cases and boundaries

Present prioritized list with rationale.
- ⏸️ **STOP**: Confirm priorities with user. Wait for user input before continuing.

### Step 3: Plan - Design test suite
For each priority area:
- Identify test type needed (unit/integration/e2e)
- List specific test cases
- Note dependencies and mocking needs

See [best-practices.md](references/best-practices.md) for testing pyramid guidance.
- ⏸️ **STOP**: Present test plan for approval. Wait for user input before continuing.

### Step 4: Implement - Write tests incrementally
- Follow AAA pattern (Arrange-Act-Assert)
- One test file per module
- Commit after each logical group
- Run tests after each addition

Language-specific patterns:
- Python: See [python.md](references/python.md)
- TypeScript: See [typescript.md](references/typescript.md)

### Step 5: Verify - Confirm coverage improvement
```bash
# Python
pytest --cov=src --cov-report=term-missing

# TypeScript
npm run test -- --coverage
```
- Compare before/after coverage
- Ensure no regressions
- ⏸️ **STOP**: Present coverage improvement summary. Wait for user input before continuing.

---

## Contextual Mode

**Follow these steps. After each, state: "✓ Step N done. Next: Step N+1"**

### Step 1: Understand - Identify what to test
- What feature/fix/refactor is being implemented?
- What files are being changed?
- What are the expected behaviors?

### Step 2: Design - Plan targeted tests
Based on context:
- **Feature**: Unit tests for new functions + integration test for user flow
- **Fix**: Regression test that reproduces the bug (should fail before fix, pass after)
- **Refactor**: Verify existing tests pass; add tests if coverage gaps exist

List specific test cases needed.
- ⏸️ **STOP**: Confirm test cases with user. Wait for user input before continuing.

### Step 3: Implement - Write tests
- Follow AAA pattern
- Test happy path first
- Add edge cases and error conditions
- Ensure tests are isolated and independent

Language-specific patterns:
- Python: See [python.md](references/python.md)
- TypeScript: See [typescript.md](references/typescript.md)

### Step 4: Verify - Run and confirm
```bash
# Python
pytest tests/ -v

# TypeScript
npm run test
```
- All tests pass
- New code has adequate coverage
- No flaky tests introduced

---

## Output Format

### Coverage Analysis Report

```markdown
## Coverage Analysis

**Current Coverage**: X% (statements) / Y% (branches)

### Critical Gaps (High Priority)
| File | Coverage | Missing |
|------|----------|---------|
| `src/auth.py` | 45% | login(), validate_token() |
| `src/api.ts` | 60% | error handling branches |

### Recommended Test Plan
1. [Priority] `test_auth.py` - Add tests for login flow
2. [Priority] `test_api.ts` - Add error handling tests

### Estimated Effort
- X new test files
- Y new test cases
- Target coverage: Z%
```

### Test Implementation Summary

```markdown
## Tests Added

| File | Tests | Coverage Impact |
|------|-------|-----------------|
| `tests/test_auth.py` | 5 | +15% |
| `tests/test_api.ts` | 3 | +10% |

**Before**: X% coverage
**After**: Y% coverage
**Delta**: +Z%
```

---

## Principles

- **Test behavior, not implementation** - Tests should survive refactoring
- **One assertion per test** - Makes failures easy to diagnose
- **Tests are documentation** - Clear names describe expected behavior
- **Isolation is critical** - Tests must not depend on each other
- **Fast feedback** - Unit tests should run in milliseconds
- **Testing pyramid** - 70% unit, 20% integration, 10% E2E

## Test Organization

```
project/
├── src/              # Source code
│   ├── auth.py
│   └── api.ts
└── tests/            # All tests in separate directory
    ├── unit/         # Fast, isolated tests
    │   ├── test_auth.py
    │   └── api.test.ts
    ├── integration/  # Component interaction tests
    └── e2e/          # End-to-end user flow tests
```

## References

- [best-practices.md](references/best-practices.md) - Universal testing principles
- [python.md](references/python.md) - pytest patterns and conventions
- [typescript.md](references/typescript.md) - Jest/Vitest patterns and conventions
