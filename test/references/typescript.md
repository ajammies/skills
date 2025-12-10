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

## Integration Testing

### API Integration Test

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { createServer } from '../src/server';
import { prisma } from '../src/database';

describe('User API', () => {
  let server: ReturnType<typeof createServer>;

  beforeAll(async () => {
    server = createServer();
    await server.listen(0); // Random port
  });

  afterAll(async () => {
    await server.close();
    await prisma.$disconnect();
  });

  it('should create and retrieve user', async () => {
    // Create user
    const createRes = await fetch(`${server.url}/api/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', name: 'Test' }),
    });
    expect(createRes.status).toBe(201);
    const { id } = await createRes.json();

    // Verify in database
    const dbUser = await prisma.user.findUnique({ where: { id } });
    expect(dbUser?.email).toBe('test@example.com');

    // Retrieve via API
    const getRes = await fetch(`${server.url}/api/users/${id}`);
    expect(getRes.status).toBe(200);
    const user = await getRes.json();
    expect(user.name).toBe('Test');
  });
});
```

### Database Integration with Transactions

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { prisma } from '../src/database';

describe('Order Service', () => {
  beforeEach(async () => {
    // Clean up before each test
    await prisma.order.deleteMany();
    await prisma.user.deleteMany();
  });

  it('should create order with items', async () => {
    // Arrange
    const user = await prisma.user.create({
      data: { email: 'test@example.com', name: 'Test' },
    });

    // Act
    const order = await prisma.order.create({
      data: {
        userId: user.id,
        items: {
          create: [
            { productId: 1, quantity: 2, price: 10.00 },
            { productId: 2, quantity: 1, price: 25.00 },
          ],
        },
      },
      include: { items: true },
    });

    // Assert
    expect(order.items).toHaveLength(2);
    expect(order.items[0].quantity).toBe(2);
  });
});
```

## E2E Testing with Playwright

```typescript
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can login and view dashboard', async ({ page }) => {
    // Navigate to login
    await page.goto('/login');

    // Fill credentials
    await page.fill('[name=email]', 'user@example.com');
    await page.fill('[name=password]', 'password123');
    await page.click('button[type=submit]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toHaveText('Welcome back');
  });

  test('shows error for invalid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[name=email]', 'wrong@example.com');
    await page.fill('[name=password]', 'wrongpassword');
    await page.click('button[type=submit]');

    await expect(page.locator('.error-message')).toBeVisible();
    await expect(page.locator('.error-message')).toHaveText('Invalid credentials');
  });
});

test.describe('Shopping Cart', () => {
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await page.goto('/login');
    await page.fill('[name=email]', 'user@example.com');
    await page.fill('[name=password]', 'password123');
    await page.click('button[type=submit]');
    await page.waitForURL('/dashboard');
  });

  test('user can add item to cart and checkout', async ({ page }) => {
    // Add product to cart
    await page.goto('/products/1');
    await page.click('button:text("Add to Cart")');
    await expect(page.locator('.cart-count')).toHaveText('1');

    // Go to cart and checkout
    await page.click('[data-testid=cart-icon]');
    await page.click('button:text("Checkout")');

    // Fill payment info
    await page.fill('[name=card_number]', '4111111111111111');
    await page.fill('[name=expiry]', '12/25');
    await page.fill('[name=cvv]', '123');
    await page.click('button:text("Pay Now")');

    // Verify success
    await expect(page).toHaveURL(/\/orders\/\d+/);
    await expect(page.locator('h1')).toHaveText('Order Confirmed');
  });
});
```

### Playwright Configuration

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Running Playwright Tests

```bash
# Install
npm install -D @playwright/test
npx playwright install

# Run tests
npx playwright test              # Headless
npx playwright test --headed     # With browser
npx playwright test --ui         # Interactive UI
npx playwright show-report       # View HTML report
```
