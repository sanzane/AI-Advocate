"""Backend API tests without external test runner dependency."""

import sys
from pathlib import Path

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent))

import asyncio
from httpx import AsyncClient, ASGITransport
from app.main import app


async def test_health():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        res = await client.get("/health")
        assert res.status_code == 200, f"Expected 200, got {res.status_code}"
        data = res.json()
        assert data["status"] == "ok"
        assert "demo_mode" in data
        assert "provider" in data


async def test_chat_valid():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        payload = {
            "message": "My landlord is not returning my security deposit.",
            "conversation_id": None,
        }
        res = await client.post("/api/chat", json=payload)
        assert res.status_code == 200, f"Expected 200, got {res.status_code}"
        data = res.json()
        assert "conversation_id" in data
        assert "answer" in data
        assert "disclaimer" in data
        assert "demo" in data
        assert len(data["sources"]) >= 0


async def test_chat_empty_validation():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        payload = {"message": "   "}
        res = await client.post("/api/chat", json=payload)
        assert res.status_code == 422, f"Expected 422, got {res.status_code}"


async def main():
    print("Running backend tests...")
    await test_health()
    print("  - test_health PASSED")
    await test_chat_valid()
    print("  - test_chat_valid PASSED")
    await test_chat_empty_validation()
    print("  - test_chat_empty_validation PASSED")
    print("All backend tests PASSED successfully!")


if __name__ == "__main__":
    asyncio.run(main())
