# Python Testing with pytest

pytest conventions, fixtures, mocking, and coverage.

## Directory Structure

```
project/
├── src/
│   ├── auth.py
│   └── api.py
└── tests/
    ├── conftest.py        # Shared fixtures
    ├── test_auth.py
    └── test_api.py
```

**Conventions:**
- Test directory: `tests/` (no `__init__.py` needed)
- Test files: `test_*.py` or `*_test.py`
- Test functions: `test_*`
- No `__init__.py` in test directories (pytest best practice)

## Basic Test Structure

```python
import pytest
from src.auth import login, AuthError

def test_login_with_valid_credentials():
    # Arrange
    user = create_user("test@example.com", "password123")

    # Act
    session = login("test@example.com", "password123")

    # Assert
    assert session is not None
    assert session.user_id == user.id

def test_login_with_invalid_password():
    create_user("test@example.com", "password123")

    with pytest.raises(AuthError) as exc_info:
        login("test@example.com", "wrong_password")

    assert "Invalid credentials" in str(exc_info.value)
```

## Fixtures

Fixtures provide reusable test data and setup:

```python
# conftest.py - Shared across all tests in directory
import pytest

@pytest.fixture
def user():
    """Create a test user."""
    return create_user("test@example.com", "password123")

@pytest.fixture
def authenticated_client(user):
    """Create an authenticated API client."""
    client = TestClient()
    client.login(user)
    return client

# test_api.py
def test_get_profile(authenticated_client):
    response = authenticated_client.get("/profile")
    assert response.status_code == 200
```

### Factory Fixtures

For flexible test data:

```python
@pytest.fixture
def make_user():
    """Factory for creating users with custom attributes."""
    def _make_user(email="test@example.com", **kwargs):
        defaults = {"name": "Test User", "is_active": True}
        return User(**{**defaults, **kwargs, "email": email})
    return _make_user

def test_inactive_user(make_user):
    user = make_user(is_active=False)
    assert user.can_login() is False
```

### Fixture Scopes

```python
@pytest.fixture(scope="function")  # Default - runs for each test
def user(): ...

@pytest.fixture(scope="class")     # Once per test class
def db_connection(): ...

@pytest.fixture(scope="module")    # Once per test file
def api_client(): ...

@pytest.fixture(scope="session")   # Once per test run
def database(): ...
```

## Mocking with monkeypatch

pytest's built-in mocking fixture:

```python
def test_send_email(monkeypatch):
    sent_emails = []

    def mock_send(to, subject, body):
        sent_emails.append({"to": to, "subject": subject})

    monkeypatch.setattr("src.email.send", mock_send)

    notify_user(user_id=1, message="Hello")

    assert len(sent_emails) == 1
    assert sent_emails[0]["to"] == "user@example.com"
```

### Environment Variables

```python
def test_uses_production_url(monkeypatch):
    monkeypatch.setenv("API_URL", "https://api.example.com")

    client = APIClient()
    assert client.base_url == "https://api.example.com"
```

## Mocking with unittest.mock

For more complex mocking:

```python
from unittest.mock import Mock, patch, MagicMock

def test_api_call():
    with patch("src.api.requests.get") as mock_get:
        mock_get.return_value.json.return_value = {"data": "test"}
        mock_get.return_value.status_code = 200

        result = fetch_data()

        assert result == {"data": "test"}
        mock_get.assert_called_once_with("https://api.example.com/data")
```

### Mock as Fixture

```python
@pytest.fixture
def mock_db(mocker):
    """Mock database connection."""
    mock = mocker.patch("src.db.connect")
    mock.return_value.query.return_value = []
    return mock

def test_empty_query(mock_db):
    result = get_all_users()
    assert result == []
```

## Parametrized Tests

Run same test with multiple inputs:

```python
@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("PyTest", "PYTEST"),
])
def test_uppercase(input, expected):
    assert input.upper() == expected

@pytest.mark.parametrize("email,valid", [
    ("user@example.com", True),
    ("invalid", False),
    ("", False),
    ("user@.com", False),
])
def test_email_validation(email, valid):
    assert is_valid_email(email) == valid
```

## Coverage with pytest-cov

### Running Coverage

```bash
# Basic coverage report
pytest --cov=src

# With missing lines shown
pytest --cov=src --cov-report=term-missing

# Generate HTML report
pytest --cov=src --cov-report=html

# Fail if coverage below threshold
pytest --cov=src --cov-fail-under=80
```

### Configuration (pyproject.toml)

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing"

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
```

## Async Testing

```python
import pytest

@pytest.mark.asyncio
async def test_async_fetch():
    result = await fetch_data_async()
    assert result is not None
```

Requires `pytest-asyncio`:
```bash
pip install pytest-asyncio
```

## Common Patterns

### Testing Exceptions

```python
def test_raises_value_error():
    with pytest.raises(ValueError, match="must be positive"):
        calculate(-1)
```

### Testing Logs

```python
def test_logs_warning(caplog):
    with caplog.at_level(logging.WARNING):
        process_invalid_data()

    assert "Invalid data" in caplog.text
```

### Temporary Files

```python
def test_file_processing(tmp_path):
    test_file = tmp_path / "data.txt"
    test_file.write_text("test content")

    result = process_file(test_file)
    assert result == "processed"
```

## Running Tests

```bash
# Run all tests
pytest

# Run specific file
pytest tests/test_auth.py

# Run specific test
pytest tests/test_auth.py::test_login_with_valid_credentials

# Run tests matching pattern
pytest -k "login"

# Verbose output
pytest -v

# Stop on first failure
pytest -x

# Run last failed tests
pytest --lf
```
