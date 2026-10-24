from pydantic import BaseModel, Field, field_validator

DISCLAIMER = (
    "This is general legal information, not a substitute for advice from a qualified advocate."
)


class ChatRequest(BaseModel):
    message: str = Field(..., max_length=4000)
    conversation_id: str | None = None

    @field_validator("message")
    @classmethod
    def not_blank(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("message must not be empty")
        return v


class Source(BaseModel):
    """Only metadata that was actually retrieved may be set here."""

    id: str
    title: str
    act: str | None = None
    section: str | None = None
    excerpt: str | None = None
    date: str | None = None
    official_url: str | None = None  # verified https URL only
    is_sample: bool = False


class ChatResponse(BaseModel):
    conversation_id: str
    answer: str
    sources: list[Source] = Field(default_factory=list)
    disclaimer: str = DISCLAIMER
    demo: bool = False


class HealthResponse(BaseModel):
    status: str
    demo_mode: bool
    provider: str
