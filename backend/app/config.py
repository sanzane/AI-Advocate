"""Configuration from environment variables (and an optional local .env)."""

import os
from dataclasses import dataclass, field

from pathlib import Path
from dotenv import load_dotenv

BASE_BACKEND_DIR = Path(__file__).resolve().parent.parent
# Load .env from backend directory first, then fallback to current working directory
if (BASE_BACKEND_DIR / ".env").exists():
    load_dotenv(BASE_BACKEND_DIR / ".env")
load_dotenv()


def _bool(name: str, default: bool) -> bool:
    return os.getenv(name, str(default)).strip().lower() in {"1", "true", "yes", "on"}


def _list(name: str, default: str) -> list[str]:
    return [p.strip() for p in os.getenv(name, default).split(",") if p.strip()]


@dataclass(frozen=True)
class Settings:
    demo_mode: bool = field(default_factory=lambda: _bool("DEMO_MODE", True))
    ai_provider: str = field(default_factory=lambda: os.getenv("AI_PROVIDER", "gemini_rag"))
    gemini_api_key: str = field(default_factory=lambda: os.getenv("GEMINI_API_KEY", ""))
    gemini_model: str = field(default_factory=lambda: os.getenv("GEMINI_MODEL", "gemini-3.5-flash-lite"))
    gemini_embed_model: str = field(
        default_factory=lambda: os.getenv("GEMINI_EMBED_MODEL", "text-embedding-004")
    )
    chroma_dir: str = field(
        default_factory=lambda: os.getenv(
            "CHROMA_DIR", str(BASE_BACKEND_DIR / "data" / "chroma")
        )
    )
    corpus_dir: str = field(
        default_factory=lambda: os.getenv(
            "CORPUS_DIR", str(BASE_BACKEND_DIR / "data" / "corpus")
        )
    )
    retrieval_top_k: int = field(
        default_factory=lambda: int(os.getenv("RETRIEVAL_TOP_K", "4"))
    )
    ollama_base_url: str = field(default_factory=lambda: os.getenv("OLLAMA_CLOUD_BASE_URL", ""))
    ollama_api_key: str = field(default_factory=lambda: os.getenv("OLLAMA_CLOUD_API_KEY", ""))
    ollama_model: str = field(default_factory=lambda: os.getenv("OLLAMA_MODEL", ""))
    cors_origins: list[str] = field(default_factory=lambda: _list("CORS_ORIGINS", "*"))


def get_settings() -> Settings:
    return Settings()
