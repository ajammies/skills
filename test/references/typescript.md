# TypeScript Testing with Vitest

Vitest conventions, mocking, and coverage for TypeScript projects.

## Why Vitest

- 4× faster cold starts than Jest
- Native ESM and TypeScript support
- Jest-compatible API (easy migration)
- First-class Vite integration

## Directory Structure

```
project/
├── src/
│   ├── auth.ts
│   └── api.ts
└── tests/
    ├── setup.ts           # Global test setup
    ├── auth.test.ts
    └── api.test.ts
```

**Conventions:**
- Test files: `*.test.ts` or `*.spec.ts`
- Test directory: `tests/`
- Match source file names: `auth.ts` → `auth.test.ts`

## Basic Test Structure

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { login, AuthError } from '../src/auth';

describe('login', () => {
  beforeEach(() => {
    // Reset state before each test
  });

  it('should return session for valid credentials', () => {
    // Arrange
    const user = createUser('test@example.com', 'password123');

    // Act
    const session = login('test@example.com', 'password123');

    // Assert
    expect(session).toBeDefined();
    expect(session.userId).toBe(user.id);
  });

  it('should throw AuthError for invalid password', () => {
    createUser('test@example.com', 'password123');

    expect(() => {
      login('test@example.com', 'wrong_password');
    }).toThrow(AuthError);
  });
});
```

## Mocking

### Module Mocking

```typescript
import { vi, describe, it, expect } from 'vitest';
import { fetchUser } from '../src/api';

// Mock entire module
vi.mock('../src/database', () => ({
  query: vi.fn(),
}));

import { query } from '../src/database';

describe('fetchUser', () => {
  it('should return user from database', async () => {
    vi.mocked(query).mockResolvedValue({ id: 1, name: 'Test' });

    const user = await fetchUser(1);

    expect(user.name).toBe('Test');
    expect(query).toHaveBeenCalledWith('SELECT * FROM users WHERE id = ?', [1]);
  });
});
```

### Spy on Functions

```typescript
import { vi } from 'vitest';

it('should call logger', () => {
  const logSpy = vi.spyOn(console, 'log');

  processData();

  expect(logSpy).toHaveBeenCalledWith('Processing complete');
  logSpy.mockRestore();
});
```

### Type-Safe Mocking

```typescript
import { vi, type Mock } from 'vitest';

interface UserService {
  getUser(id: number): Promise<User>;
  createUser(data: UserData): Promise<User>;
}

const mockUserService: { [K in keyof UserService]: Mock } = {
  getUser: vi.fn(),
  createUser: vi.fn(),
};

it('should fetch user', async () => {
  mockUserService.getUser.mockResolvedValue({ id: 1, name: 'Test' });

  const user = await mockUserService.getUser(1);

  expect(user.id).toBe(1);
});
```

### Clearing Mocks

```typescript
import { vi, beforeEach } from 'vitest';

beforeEach(() => {
  vi.clearAllMocks();  // Clear call history
  // vi.resetAllMocks(); // Clear + reset implementations
  // vi.restoreAllMocks(); // Restore original implementations
});
```

## Configuration

### vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    setupFiles: ['./tests/setup.ts'],
    include: ['tests/**/*.test.ts'],
  },
});
```

### Setup File (tests/setup.ts)

```typescript
import { beforeAll, afterAll, beforeEach } from 'vitest';

beforeAll(async () => {
  // Run once before all tests
  await setupDatabase();
});

afterAll(async () => {
  // Run once after all tests
  await cleanupDatabase();
});

beforeEach(() => {
  // Run before each test
  vi.clearAllMocks();
});
```

## Async Testing

```typescript
it('should fetch data', async () => {
  const data = await fetchData();
  expect(data).toBeDefined();
});

it('should reject on error', async () => {
  await expect(fetchInvalidData()).rejects.toThrow('Not found');
});
```

## Coverage

### Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reportsDirectory: './coverage',
      include: ['src/**/*.ts'],
      exclude: ['**/*.test.ts', '**/node_modules/**'],
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80,
      },
    },
  },
});
```

### Running Coverage

```bash
vitest --coverage
```

## Testing Patterns

### Testing Errors

```typescript
it('should throw for invalid input', () => {
  expect(() => validate(null)).toThrow('Input required');
});

it('should throw specific error type', () => {
  expect(() => validate(null)).toThrowError(ValidationError);
});
```

### Testing Types (compile-time)

```typescript
import { expectTypeOf } from 'vitest';

it('should return correct type', () => {
  const result = getUser(1);
  expectTypeOf(result).toEqualTypeOf<User>();
});
```

### Snapshot Testing

```typescript
it('should match snapshot', () => {
  const output = renderComponent();
  expect(output).toMatchSnapshot();
});

it('should match inline snapshot', () => {
  const output = formatDate(new Date('2024-01-01'));
  expect(output).toMatchInlineSnapshot(`"January 1, 2024"`);
});
```

## Common Matchers

```typescript
// Equality
expect(value).toBe(exact);           // Strict equality (===)
expect(value).toEqual(deep);         // Deep equality
expect(value).toStrictEqual(deep);   // Deep + type checking

// Truthiness
expect(value).toBeTruthy();
expect(value).toBeFalsy();
expect(value).toBeNull();
expect(value).toBeDefined();

// Numbers
expect(value).toBeGreaterThan(n);
expect(value).toBeLessThan(n);
expect(value).toBeCloseTo(float, decimals);

// Strings
expect(value).toMatch(/regex/);
expect(value).toContain('substring');

// Arrays
expect(array).toContain(item);
expect(array).toHaveLength(n);

// Objects
expect(obj).toHaveProperty('key');
expect(obj).toMatchObject(partial);

// Functions
expect(fn).toHaveBeenCalled();
expect(fn).toHaveBeenCalledWith(arg1, arg2);
expect(fn).toHaveBeenCalledTimes(n);
```

## Running Tests

```bash
vitest                    # Watch mode
vitest run               # Single run
vitest run auth.test.ts  # Specific file
vitest -t "login"        # Match pattern
```

## Debugging

```typescript
// Only run this test
it.only('focus on this test', () => {
  // ...
});

// Skip test
it.skip('not ready yet', () => {
  // ...
});
```
