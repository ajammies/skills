# Testing Best Practices

Universal testing principles that apply across all languages.

## AAA Pattern (Arrange-Act-Assert)

The gold standard for test structure:

```python
def test_user_can_login():
    # Arrange - Set up preconditions
    user = create_user(email="test@example.com", password="secret")

    # Act - Execute the behavior
    result = login(email="test@example.com", password="secret")

    # Assert - Verify the outcome
    assert result.success is True
    assert result.user.id == user.id
```

**Guidelines:**
- Keep each phase clearly separated
- One logical action in the Act phase
- Assertions should verify the single behavior under test

## Testing Pyramid

Optimal test distribution for maintainability and speed:

```
        /\
       /  \     E2E (10%)
      /----\    - Critical user paths only
     /      \   - Expensive, slow, brittle
    /--------\  Integration (20%)
   /          \ - Component interactions
  /------------\- API contracts, DB queries
 /              \ Unit (70%)
/----------------\- Fast, isolated, numerous
```

**Unit Tests (70%)**
- Test single functions/methods in isolation
- Mock all dependencies
- Run in milliseconds
- High ROI - catch bugs early

**Integration Tests (20%)**
- Test component interactions
- Real database, real API calls
- Verify contracts between systems

**E2E Tests (10%)**
- Critical user flows only
- Browser automation or API sequences
- Expensive to maintain

## Integration Test Patterns

Integration tests verify that components work together correctly.

### API Integration Test

```python
# Test that API endpoint correctly interacts with database
def test_create_user_api(client, db):
    # Arrange
    payload = {"email": "new@example.com", "name": "New User"}

    # Act
    response = client.post("/api/users", json=payload)

    # Assert - Check response
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "new@example.com"

    # Assert - Verify database state
    user = db.query(User).filter_by(email="new@example.com").first()
    assert user is not None
    assert user.name == "New User"
```

### Service Integration Test

```python
# Test that services communicate correctly
def test_order_service_creates_payment(order_service, payment_service, db):
    # Arrange
    user = create_user()
    cart = create_cart(user, items=[{"product_id": 1, "qty": 2}])

    # Act
    order = order_service.checkout(cart)

    # Assert - Order created
    assert order.status == "pending"

    # Assert - Payment initiated
    payment = payment_service.get_by_order(order.id)
    assert payment is not None
    assert payment.amount == cart.total
```

### Database Integration Test

```python
# Test database operations with real database
@pytest.fixture
def db():
    """Create test database and rollback after each test."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    session = Session(engine)
    yield session
    session.rollback()
    session.close()

def test_user_cascade_delete(db):
    # Arrange
    user = User(email="test@example.com")
    post = Post(title="Test", author=user)
    db.add_all([user, post])
    db.commit()

    # Act
    db.delete(user)
    db.commit()

    # Assert - Post should be deleted too
    assert db.query(Post).count() == 0
```

**Integration Test Guidelines:**
- Use real dependencies (database, cache) when possible
- Isolate with transactions that rollback
- Test the contract between components
- Slower than unit tests - be selective

## E2E Test Patterns

E2E tests verify complete user flows through the entire system.

### Critical User Flow

```python
# Test complete purchase flow
def test_user_can_complete_purchase(browser):
    # Login
    browser.goto("/login")
    browser.fill("email", "user@example.com")
    browser.fill("password", "password123")
    browser.click("button[type=submit]")
    browser.wait_for_url("/dashboard")

    # Add to cart
    browser.goto("/products/1")
    browser.click("button.add-to-cart")
    browser.wait_for_selector(".cart-count:text('1')")

    # Checkout
    browser.goto("/cart")
    browser.click("button.checkout")
    browser.fill("card_number", "4111111111111111")
    browser.fill("expiry", "12/25")
    browser.fill("cvv", "123")
    browser.click("button.pay")

    # Verify success
    browser.wait_for_url("/order/confirmation")
    assert browser.text_content("h1") == "Order Confirmed"
```

### API E2E Test

```python
# Test complete API workflow without browser
def test_full_order_workflow(api_client):
    # Register
    response = api_client.post("/auth/register", json={
        "email": "new@example.com",
        "password": "secret123"
    })
    assert response.status_code == 201
    token = response.json()["token"]

    # Authenticate subsequent requests
    api_client.headers["Authorization"] = f"Bearer {token}"

    # Create order
    response = api_client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 2}]
    })
    assert response.status_code == 201
    order_id = response.json()["id"]

    # Process payment
    response = api_client.post(f"/orders/{order_id}/pay", json={
        "card_token": "tok_test_visa"
    })
    assert response.status_code == 200

    # Verify order status
    response = api_client.get(f"/orders/{order_id}")
    assert response.json()["status"] == "paid"
```

**E2E Test Guidelines:**
- Test only critical paths (login, checkout, key features)
- Use stable selectors (data-testid, not CSS classes)
- Keep tests independent - each creates its own data
- Run in CI but not on every commit (slow)
- Maximum 10% of test suite

## Test Isolation

Each test must be completely independent:

```python
# BAD - Tests depend on each other
class TestUser:
    user = None

    def test_create_user(self):
        self.user = create_user("test@example.com")
        assert self.user is not None

    def test_delete_user(self):
        delete_user(self.user)  # Fails if test_create_user didn't run first

# GOOD - Each test is self-contained
class TestUser:
    def test_create_user(self):
        user = create_user("test@example.com")
        assert user is not None

    def test_delete_user(self):
        user = create_user("test@example.com")
        delete_user(user)
        assert get_user(user.id) is None
```

**Requirements:**
- No shared mutable state between tests
- Tests can run in any order
- Tests can run in parallel
- Each test sets up its own data

## Naming Conventions

Test names should describe the expected behavior:

```python
# Pattern: test_<unit>_<scenario>_<expected_result>

# Good names
def test_login_with_valid_credentials_returns_session():
def test_login_with_invalid_password_raises_auth_error():
def test_calculate_total_with_empty_cart_returns_zero():

# Bad names
def test_login():           # What scenario?
def test_login_works():     # What does "works" mean?
def test1():                # Completely unclear
```

## One Assertion Per Test

Single-assertion tests make failures easy to diagnose:

```python
# BAD - Multiple assertions hide the actual failure
def test_user_registration():
    user = register("test@example.com", "password")
    assert user.id is not None
    assert user.email == "test@example.com"
    assert user.created_at is not None
    assert user.is_active is True

# GOOD - Separate tests for each behavior
def test_registration_assigns_id():
    user = register("test@example.com", "password")
    assert user.id is not None

def test_registration_stores_email():
    user = register("test@example.com", "password")
    assert user.email == "test@example.com"

def test_registration_sets_active_status():
    user = register("test@example.com", "password")
    assert user.is_active is True
```

## What to Test

**DO test:**
- Business logic and calculations
- Edge cases and boundary conditions
- Error handling and validation
- State transitions
- Integration points (APIs, databases)

**DON'T test:**
- Framework code (it's already tested)
- Simple getters/setters
- Configuration
- Third-party libraries

## Test Data

Use factories or fixtures for consistent test data:

```python
# Factory pattern
def make_user(email="test@example.com", **overrides):
    defaults = {
        "email": email,
        "name": "Test User",
        "is_active": True,
    }
    return User(**{**defaults, **overrides})

# Usage
def test_inactive_user_cannot_login():
    user = make_user(is_active=False)
    result = login(user.email, "password")
    assert result.success is False
```

## Mocking Guidelines

**When to mock:**
- External services (APIs, databases in unit tests)
- Time-dependent operations
- Randomness
- File system operations
- Network calls

**When NOT to mock:**
- The code under test
- Simple data structures
- Pure functions

```python
# Good - Mock external dependency
def test_send_notification(mocker):
    mock_email = mocker.patch("services.email.send")
    notify_user(user_id=1, message="Hello")
    mock_email.assert_called_once()

# Bad - Mocking the thing we're testing
def test_calculate_total(mocker):
    mocker.patch("cart.calculate_total", return_value=100)  # Why?
    assert calculate_total(cart) == 100
```

## Test Maintenance

Keep tests maintainable:

- **DRY for setup, WET for assertions** - Duplicate assertion logic is fine
- **Use descriptive variable names** - `expired_token` not `token2`
- **Delete flaky tests** - Better no test than an unreliable one
- **Review tests in PRs** - Tests are code too
