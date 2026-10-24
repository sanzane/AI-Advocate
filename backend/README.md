# AI Advocate Backend (FastAPI Service)

Provides statutory legal information and research endpoints for the AI Advocate mobile application.

## Core Features & Architecture

- **Clean Layered Architecture:**
  - `app/api/routes.py`: FastAPI route handlers for `/health` and `/api/chat`.
  - `app/schemas/chat.py`: Pydantic models for request validation, structured responses, source metadata, and disclaimers.
  - `app/services/provider.py`: `AIProvider` abstraction with `DemoProvider` (structured Indian law demo generator), `OllamaCloudProvider` (HTTP client for remote Gemma models), and lazy-loaded `GeminiRAGProvider`.
  - `app/config.py`: Environment-driven settings (`.env`).
  - `test_backend.py`: Automated tests verifying health checks, input validation, and chat response formats.

## Quick Start

### 1. Activate Environment & Install Dependencies
From the `backend` folder:
```bash
# Windows
.venv\Scripts\activate
pip install -r requirements.txt

# macOS/Linux
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env` if not already present:
```bash
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env
```

Settings in `.env`:
- `DEMO_MODE=true`: Returns structured demonstration responses with sample Indian legal provisions (Transfer of Property Act, BNS, Consumer Protection Act, etc.).
- `AI_PROVIDER=ollama_cloud`: Activates the Ollama Cloud inference provider when credentials are provided.
- `OLLAMA_CLOUD_BASE_URL`: The remote Ollama Cloud base URL (e.g., `https://cloud.ollama.ai` or your team's remote endpoint).
- `OLLAMA_CLOUD_API_KEY`: Your Ollama Cloud bearer token / API key.
- `OLLAMA_MODEL`: Target model identifier, e.g., `gemma4:31b` or `gemma:31b`.

### 3. Run Backend Server
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
Interactive OpenAPI documentation will be accessible at: `http://localhost:8000/docs`

### 4. Run Backend Tests
```bash
python test_backend.py
```

## API Specification

### `GET /health`
Returns server status, current mode, and active provider:
```json
{
  "status": "ok",
  "demo_mode": true,
  "provider": "demo"
}
```

### `POST /api/chat`
Accepts a user question:
```json
{
  "message": "My landlord refuses to return my security deposit.",
  "conversation_id": null
}
```
Returns a structured response adhering to the statutory disclosure rules:
```json
{
  "conversation_id": "90e0b355-6dd8-410e-a6c3-1d02c89f5c40",
  "answer": "### Situation Summary (Demo Mode)...",
  "sources": [
    {
      "id": "sample-tpa-108",
      "title": "Transfer of Property Act, 1882 - Section 108",
      "act": "Transfer of Property Act, 1882",
      "section": "Section 108",
      "excerpt": "Rights and liabilities of lessor and lessee...",
      "date": null,
      "official_url": null,
      "is_sample": true
    }
  ],
  "disclaimer": "This is general legal information, not a substitute for advice from a qualified advocate.",
  "demo": true
}
```
Empty or blank messages are rejected with HTTP 422. Missing credentials for cloud providers return HTTP 503 with helpful configuration diagnostics.
