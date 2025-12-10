# Integration Testing

Integration tests verify that components work together correctly. Use real dependencies (database, cache) when possible.

## When to Write Integration Tests

- API endpoints that interact with databases
- Service-to-service communication
- Database operations (transactions, cascades)
- External API integrations

## Python (FastAPI + SQLAlchemy)

### API Integration Test

```python
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session
import pytest

from app.main import app
from app.database import Base, get_db

@pytest.fixture
def db():
    """Create test database with rollback."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    session = Session(engine)
    yield session
    session.rollback()
    session.close()

@pytest.fixture
def client(db):
    """Test client with database override."""
    def override_get_db():
        yield db
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()

def test_create_and_retrieve_user(client, db):
    # Create user via API
    response = client.post("/users", json={
        "email": "test@example.com",
        "name": "Test User"
    })
    assert response.status_code == 201
    user_id = response.json()["id"]

    # Verify in database
    from app.models import User
    user = db.query(User).filter_by(id=user_id).first()
    assert user.email == "test@example.com"

    # Retrieve via API
    response = client.get(f"/users/{user_id}")
    assert response.status_code == 200
    assert response.json()["name"] == "Test User"
```

### Database with Transaction Rollback

```python
@pytest.fixture(scope="session")
def engine():
    return create_engine("postgresql://test:test@localhost/testdb")

@pytest.fixture(scope="session")
def tables(engine):
    Base.metadata.create_all(engine)
    yield
    Base.metadata.drop_all(engine)

@pytest.fixture
def db(engine, tables):
    """Per-test session with automatic rollback."""
    connection = engine.connect()
    transaction = connection.begin()
    session = Session(bind=connection)

    yield session

    session.close()
    transaction.rollback()
    connection.close()
```

## TypeScript (Vitest + Prisma)

### API Integration Test

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { createServer } from '../src/server';
import { prisma } from '../src/database';

describe('User API', () => {
  let server: ReturnType<typeof createServer>;

  beforeAll(async () => {
    server = createServer();
    await server.listen(0);
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
  });
});
```

### Database Cleanup Pattern

```typescript
import { beforeEach } from 'vitest';
import { prisma } from '../src/database';

beforeEach(async () => {
  await prisma.order.deleteMany();
  await prisma.user.deleteMany();
});
```

## Guidelines

- **Use real dependencies** - Avoid mocking databases in integration tests
- **Isolate with transactions** - Rollback after each test
- **Test contracts** - Verify the interface between components
- **Be selective** - Slower than unit tests, test critical paths
