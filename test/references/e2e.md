# E2E Testing with Playwright

End-to-end tests verify complete user flows through the entire system. Keep to ~10% of test suite.

## When to Write E2E Tests

- Critical user paths (login, checkout, signup)
- Key business flows ("money paths")
- Smoke tests for deployment verification

## Python

```python
import pytest
from playwright.sync_api import Page, expect

@pytest.fixture
def authenticated_page(page: Page):
    """Login before test."""
    page.goto("/login")
    page.fill("[name=email]", "user@example.com")
    page.fill("[name=password]", "password123")
    page.click("button[type=submit]")
    page.wait_for_url("/dashboard")
    return page

def test_user_can_create_post(authenticated_page):
    page = authenticated_page

    # Navigate to create post
    page.click("text=New Post")
    page.wait_for_url("/posts/new")

    # Fill form
    page.fill("[name=title]", "My Test Post")
    page.fill("[name=content]", "This is the content")
    page.click("button:text('Publish')")

    # Verify redirect and success
    page.wait_for_url("/posts/*")
    expect(page.locator("h1")).to_have_text("My Test Post")

def test_checkout_flow(authenticated_page):
    page = authenticated_page

    # Add to cart
    page.goto("/products/1")
    page.click("button:text('Add to Cart')")

    # Checkout
    page.goto("/cart")
    page.click("button:text('Checkout')")
    page.fill("[name=card_number]", "4111111111111111")
    page.fill("[name=expiry]", "12/25")
    page.fill("[name=cvv]", "123")
    page.click("button:text('Pay')")

    # Verify
    page.wait_for_url("/order/confirmation")
    expect(page.locator("h1")).to_have_text("Order Confirmed")
```

### Setup

```bash
pip install pytest-playwright
playwright install
pytest tests/e2e/ --headed  # With browser visible
```

## TypeScript

```typescript
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can login and view dashboard', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[name=email]', 'user@example.com');
    await page.fill('[name=password]', 'password123');
    await page.click('button[type=submit]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toHaveText('Welcome back');
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

  test('user can checkout', async ({ page }) => {
    await page.goto('/products/1');
    await page.click('button:text("Add to Cart")');
    await expect(page.locator('.cart-count')).toHaveText('1');

    await page.click('[data-testid=cart-icon]');
    await page.click('button:text("Checkout")');
    await page.fill('[name=card_number]', '4111111111111111');
    await page.fill('[name=expiry]', '12/25');
    await page.fill('[name=cvv]', '123');
    await page.click('button:text("Pay Now")');

    await expect(page).toHaveURL(/\/orders\/\d+/);
    await expect(page.locator('h1')).toHaveText('Order Confirmed');
  });
});
```

### Configuration

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

### Setup

```bash
npm install -D @playwright/test
npx playwright install
npx playwright test --headed  # With browser
npx playwright test --ui      # Interactive UI
```

## Guidelines

- **Critical paths only** - Login, checkout, key features
- **Stable selectors** - Use `data-testid`, not CSS classes
- **Independent tests** - Each creates its own data
- **Run in CI** - But not on every commit (slow)
- **Maximum 10%** - Of total test suite
