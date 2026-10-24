from fastapi import APIRouter, Depends, HTTPException

from app.config import Settings, get_settings
from app.schemas.chat import ChatRequest, ChatResponse, HealthResponse
from app.services.provider import (
    ProviderNotConfiguredError,
    ProviderNotImplementedError,
    get_provider,
)

router = APIRouter()


@router.get("/health", response_model=HealthResponse)
async def health(settings: Settings = Depends(get_settings)) -> HealthResponse:
    return HealthResponse(
        status="ok",
        demo_mode=settings.demo_mode,
        provider="demo" if settings.demo_mode else settings.ai_provider,
    )


@router.post("/api/chat", response_model=ChatResponse)
async def chat(request: ChatRequest, settings: Settings = Depends(get_settings)) -> ChatResponse:
    try:
        provider = get_provider(settings)
        return await provider.generate(request)
    except ProviderNotConfiguredError as e:
        raise HTTPException(
            status_code=503, detail={"code": "provider_not_configured", "message": str(e)}
        )
    except ProviderNotImplementedError as e:
        raise HTTPException(
            status_code=501, detail={"code": "provider_not_implemented", "message": str(e)}
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, detail={"code": "internal_error", "message": str(e)}
        )
