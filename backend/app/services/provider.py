"""AI provider abstraction.

Route handlers only depend on `AIProvider`. Implementations include:
- `DemoProvider`: returns structured, honest mock legal answers with sample sources.
- `OllamaCloudProvider`: calls remote Ollama Cloud / Gemma models via HTTP.
- `GeminiRAGProvider`: optional hybrid RAG with Google Gemini (loaded lazily).
"""

from abc import ABC, abstractmethod
from typing import List, Optional
from uuid import uuid4
import httpx

from app.config import Settings
from app.schemas.chat import ChatRequest, ChatResponse, Source, DISCLAIMER


class ProviderNotConfiguredError(Exception):
    """The selected provider is missing configuration."""


class ProviderNotImplementedError(Exception):
    """The provider is selected but its integration has not been written yet."""


class AIProvider(ABC):
    @abstractmethod
    async def generate(self, request: ChatRequest) -> ChatResponse: ...


class DemoProvider(AIProvider):
    """Returns a structured, honest demo legal response.

    No external model is called; responses are clearly marked with demo=True
    and include sample sources and the statutory disclaimer.
    """

    # Topics that clearly relate to Indian law for demo mode filtering
    _LEGAL_KEYWORDS = [
        "law", "legal", "court", "judge", "act", "section", "rights", "ipc", "crpc",
        "bns", "bnss", "fir", "police", "case", "complaint", "bail", "arrest",
        "property", "land", "deed", "rent", "tenant", "landlord", "deposit", "lease",
        "evict", "consumer", "refund", "fraud", "cyber", "scam", "cheating",
        "divorce", "marriage", "custody", "maintenance", "labour", "employee",
        "contract", "agreement", "trademark", "copyright", "patent", "will",
        "inheritance", "succession", "company", "gst", "tax", "constitution",
        "fundamental", "right", "article", "high court", "supreme court", "tribunal",
        "notice", "lawsuit", "injunction", "affidavit", "petition", "writ",
        "advocate", "lawyer", "legal aid", "lok adalat", "arbitration", "mediation",
    ]

    def _is_legal_question(self, text: str) -> bool:
        t = text.lower()
        return any(kw in t for kw in self._LEGAL_KEYWORDS)

    _REJECTION = (
        "I'm AI Advocate, an Indian legal information assistant. "
        "I can only help with questions about Indian laws, rights, Acts, court procedures, "
        "and legal matters. Please ask a legal question and I'll do my best to help!"
    )

    async def generate(self, request: ChatRequest) -> ChatResponse:
        q = request.message.lower()
        conv_id = request.conversation_id or str(uuid4())

        # Reject clearly non-legal questions
        if not self._is_legal_question(request.message):
            return ChatResponse(
                conversation_id=conv_id,
                answer=self._REJECTION,
                sources=[],
                disclaimer=DISCLAIMER,
                demo=True,
            )

        # Select relevant sample sources based on query topic
        if any(w in q for w in ["rent", "tenant", "landlord", "deposit", "lease", "evict"]):
            answer = (
                "### Situation Summary (Demo Mode)\n"
                "Under Indian tenancy laws, security deposits and rental disputes are governed by state-specific "
                "Rent Control Acts and Model Tenancy guidelines, read with the Transfer of Property Act, 1882.\n\n"
                "### Relevant Provisions & Rights\n"
                "- **Transfer of Property Act, 1882 (Section 105 & 108):** Defines the rights and liabilities of lessor (landlord) and lessee (tenant).\n"
                "- **Model Tenancy Act / State Rent Control:** Landlords are generally required to refund security deposits upon vacant handover of premises, subject to agreed deductions for actual damage.\n"
                "- **Consumer Protection Act, 2019:** In certain commercial or managed rental services, unfair trade practices can be challenged before the District Consumer Commission.\n\n"
                "### Practical Steps to Consider\n"
                "1. **Review Lease Agreement:** Check specific clauses regarding notice period and deposit refund timelines.\n"
                "2. **Issue Written Notice:** Send a formal written communication / speed post requesting deposit refund within 15 days.\n"
                "3. **Document Condition:** Maintain dated photographs and handover receipt showing premises were vacated in good order.\n\n"
                "### Questions for a Qualified Advocate\n"
                "- Is our tenancy covered under the state Rent Control Act or civil jurisdiction?\n"
                "- Would issuing a legal notice under Section 106 of the Transfer of Property Act be advisable?"
            )
            sources = [
                Source(
                    id="sample-tpa-108",
                    title="Transfer of Property Act, 1882 - Section 108",
                    act="Transfer of Property Act, 1882",
                    section="Section 108",
                    excerpt="Rights and liabilities of lessor and lessee in the absence of a contract to the contrary.",
                    is_sample=True,
                ),
                Source(
                    id="sample-mta-2021",
                    title="Model Tenancy Act Provisions on Security Deposit",
                    act="Model Tenancy Guidelines",
                    section="Chapter V",
                    excerpt="Guidelines governing maximum deposit limits and refund obligations upon peaceful handover.",
                    is_sample=True,
                ),
            ]
        elif any(w in q for w in ["fraud", "cyber", "scam", "police", "cheating", "bns", "ipc"]):
            answer = (
                "### Situation Summary (Demo Mode)\n"
                "Cyber fraud and unauthorized financial transactions involve criminal provisions under the "
                "Bharatiya Nyaya Sanhita, 2023 (BNS) and the Information Technology Act, 2000.\n\n"
                "### Relevant Provisions & Rights\n"
                "- **Bharatiya Nyaya Sanhita, 2023 (Section 318):** Defines and penalizes cheating and dishonestly inducing delivery of property (formerly IPC Section 420).\n"
                "- **Information Technology Act, 2000 (Section 66D):** Punishment for cheating by personation using computer resources.\n"
                "- **Reserve Bank of India (RBI) Circular on Customer Protection (2017):** Zero liability for unauthorized electronic banking transactions if reported within 3 working days.\n\n"
                "### Practical Steps to Consider\n"
                "1. **Golden Hour Reporting:** Immediately call national cybercrime helpline **1930** and register at cybercrime.gov.in.\n"
                "2. **Bank Notification:** Notify your bank in writing to freeze compromised accounts and retrieve transaction reference IDs.\n"
                "3. **Lodge e-FIR:** File a formal cyber police complaint with screenshots, transaction UTR numbers, and call logs.\n\n"
                "### Questions for a Qualified Advocate\n"
                "- How do we seek account lien reversal through the jurisdictional Magistrate's order?"
            )
            sources = [
                Source(
                    id="sample-bns-318",
                    title="Bharatiya Nyaya Sanhita, 2023 - Section 318",
                    act="Bharatiya Nyaya Sanhita, 2023",
                    section="Section 318",
                    excerpt="Provisions governing cheating and dishonest inducement to deliver property.",
                    is_sample=True,
                ),
                Source(
                    id="sample-it-66d",
                    title="Information Technology Act, 2000 - Section 66D",
                    act="Information Technology Act, 2000",
                    section="Section 66D",
                    excerpt="Punishment for cheating by personation using computer resource.",
                    is_sample=True,
                ),
            ]
        else:
            quoted = request.message.strip().replace("\n", "\n> ")
            answer = (
                f"### Plain-Language Summary (Demo Mode)\n"
                f"You asked about:\n> {quoted}\n\n"
                f"In this demonstration mode, the AI Advocate platform structures legal matters according to Indian statutory frameworks, "
                f"identifying relevant Acts, procedural steps, and questions to review with legal counsel.\n\n"
                f"### Key Frameworks in Indian Law\n"
                f"- **Constitutional & Statutory Rights:** Citizens are entitled to procedural due process and remedies under civil and criminal laws.\n"
                f"- **Dispute Resolution:** In addition to court litigation, alternative forums like Lok Adalats, Consumer Commissions, and mediation centers provide accessible recourse.\n\n"
                f"### Next Steps\n"
                f"1. Gather all documents, notices, communications, and dated records relating to your query.\n"
                f"2. Clearly outline the timeline of events and monetary or personal relief sought.\n"
                f"3. Consult a registered advocate licensed by the State Bar Council for advice specific to your jurisdiction."
            )
            sources = [
                Source(
                    id="sample-general-law",
                    title="Constitution of India - Article 39A",
                    act="Constitution of India",
                    section="Article 39A",
                    excerpt="Equal justice and free legal aid to ensure opportunities for securing justice are not denied.",
                    is_sample=True,
                )
            ]

        return ChatResponse(
            conversation_id=conv_id,
            answer=answer,
            sources=sources,
            disclaimer=DISCLAIMER,
            demo=True,
        )


class OllamaCloudProvider(AIProvider):
    """Provider for Ollama Cloud hosting Gemma 4 31B (or specified model).

    Calls remote Ollama Cloud / compatible inference endpoint over HTTP.
    """

    def __init__(self, base_url: str, api_key: str, model: str) -> None:
        self.base_url = (base_url or "").rstrip("/")
        self.api_key = api_key or ""
        self.model = model or "gemma4:31b"

    async def generate(self, request: ChatRequest) -> ChatResponse:
        missing = []
        if not self.base_url:
            missing.append("OLLAMA_CLOUD_BASE_URL")
        if not self.api_key:
            missing.append("OLLAMA_CLOUD_API_KEY")
        if not self.model:
            missing.append("OLLAMA_MODEL")

        if missing:
            raise ProviderNotConfiguredError(
                f"Ollama Cloud provider is not configured. Missing environment variables: {', '.join(missing)}. "
                f"Set these in backend/.env or run with DEMO_MODE=true."
            )

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}",
        }

        system_prompt = (
            "You are AI Advocate, an Indian legal information assistant. "
            "You ONLY answer questions about Indian law — Acts, sections, rights, court procedures, "
            "judgments, and legal matters in India. "
            "If a question is NOT about Indian law, politely decline and ask the user to ask a legal question.\n\n"
            "STRICT RULES:\n"
            "1. SCOPE: Indian law ONLY. Reject cooking, sports, general knowledge, tech help, or any non-legal topic.\n"
            "2. BREVITY: Keep answers to 50–100 words unless the question genuinely needs more detail.\n"
            "3. PLAIN LANGUAGE: Write for ordinary citizens. Explain any legal term you use in simple words.\n"
            "4. ACCURACY: Only cite Acts and Sections you are confident exist. "
               "If unsure of a specific section number, say so clearly. Never invent citations.\n"
            "5. NO OUTCOMES: Never guarantee a legal result or predict what a court will decide.\n"
            "6. FORMAT: Use short paragraphs or 2–3 bullet points max. Avoid long headings.\n"
            "7. CLOSE: End every answer with one sentence: "
               "'This is legal information, not professional legal advice — consult a licensed advocate for your specific situation.'"
        )

        # Standard Ollama chat endpoint: /api/chat
        endpoint = f"{self.base_url}/api/chat"
        payload = {
            "model": self.model,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": request.message},
            ],
            "stream": False,
        }

        async with httpx.AsyncClient(timeout=45.0) as client:
            try:
                res = await client.post(endpoint, json=payload, headers=headers)
                if res.status_code == 404:
                    # Fallback to OpenAI-compatible endpoint /v1/chat/completions if /api/chat 404s
                    fallback_endpoint = f"{self.base_url}/v1/chat/completions"
                    res = await client.post(fallback_endpoint, json=payload, headers=headers)

                res.raise_for_status()
                data = res.json()

                # Extract answer from response structure
                if "message" in data and "content" in data["message"]:
                    answer = data["message"]["content"]
                elif "choices" in data and len(data["choices"]) > 0:
                    answer = data["choices"][0]["message"]["content"]
                elif "response" in data:
                    answer = data["response"]
                else:
                    answer = str(data)

                return ChatResponse(
                    conversation_id=request.conversation_id or str(uuid4()),
                    answer=answer,
                    sources=[],
                    disclaimer=DISCLAIMER,
                    demo=False,
                )
            except httpx.HTTPStatusError as e:
                raise ProviderNotConfiguredError(
                    f"Ollama Cloud returned HTTP {e.response.status_code}: {e.response.text[:200]}"
                )
            except httpx.RequestError as e:
                raise ProviderNotConfiguredError(
                    f"Could not connect to Ollama Cloud at {self.base_url}: {str(e)}"
                )


class GeminiRAGProvider(AIProvider):
    """Production provider using Google GenAI SDK (gemini-3.5-flash-lite)."""

    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        if not settings.gemini_api_key:
            raise ProviderNotConfiguredError(
                "GEMINI_API_KEY is not configured in backend/.env. Please set your key or run in DEMO_MODE=true."
            )
        try:
            from google import genai
            self.client = genai.Client(api_key=settings.gemini_api_key)
            # Use the configured model, defaulting to gemini-2.0-flash (fast & capable)
            configured = settings.gemini_model or ""
            self.model = configured if configured else "gemini-3.8-flash"
        except Exception as e:
            raise ProviderNotConfiguredError(f"Failed to initialize Gemini Client: {e}")

        # Optional RAG service
        self.rag_service = None
        try:
            from app.services.rag_service import RAGService
            self.rag_service = RAGService(settings)
        except Exception:
            # Fallback to direct Gemini generation with Indian legal grounding prompt
            self.rag_service = None

    def _extract_sources(self, query: str, answer: str) -> List[Source]:
        q = (query + " " + answer).lower()
        extracted: List[Source] = []

        if any(w in q for w in ["land", "property", "sold", "deed", "sale", "possession", "title", "consent"]):
            extracted.append(
                Source(
                    id="statute-sra-31",
                    title="Specific Relief Act, 1963 - Section 31",
                    act="Specific Relief Act, 1963",
                    section="Section 31",
                    excerpt="When cancellation may be ordered of an instrument which is void or voidable.",
                )
            )
            extracted.append(
                Source(
                    id="statute-tpa-7",
                    title="Transfer of Property Act, 1882 - Section 7",
                    act="Transfer of Property Act, 1882",
                    section="Section 7",
                    excerpt="Persons competent to transfer: Every person competent to contract and entitled to transferable property.",
                )
            )
            extracted.append(
                Source(
                    id="statute-bns-318",
                    title="Bharatiya Nyaya Sanhita, 2023 - Section 318",
                    act="Bharatiya Nyaya Sanhita, 2023",
                    section="Section 318",
                    excerpt="Punishment for cheating and dishonestly inducing delivery of property.",
                )
            )

        if any(w in q for w in ["rent", "tenant", "landlord", "deposit", "evict"]):
            extracted.append(
                Source(
                    id="statute-tpa-108",
                    title="Transfer of Property Act, 1882 - Section 108",
                    act="Transfer of Property Act, 1882",
                    section="Section 108",
                    excerpt="Rights and liabilities of lessor and lessee in the absence of a contract to the contrary.",
                )
            )

        if any(w in q for w in ["consumer", "warranty", "defective", "refund", "unfair trade"]):
            extracted.append(
                Source(
                    id="statute-cpa-2",
                    title="Consumer Protection Act, 2019 - Section 2(7)",
                    act="Consumer Protection Act, 2019",
                    section="Section 2(7)",
                    excerpt="Statutory definition of consumer and rights against defective goods or services.",
                )
            )

        if any(w in q for w in ["cyber", "online", "scam", "upi", "banking fraud"]):
            extracted.append(
                Source(
                    id="statute-it-66d",
                    title="Information Technology Act, 2000 - Section 66D",
                    act="Information Technology Act, 2000",
                    section="Section 66D",
                    excerpt="Punishment for cheating by personation by using computer resource.",
                )
            )

        return extracted

    async def generate(self, request: ChatRequest) -> ChatResponse:
        sources: List[Source] = []
        context_text = ""

        if self.rag_service is not None:
            try:
                sources = await self.rag_service.retrieve(request.message)
                if sources:
                    context_text = "\n\n".join([
                        f"Source: {s.act} - {s.section}\nContent: {s.excerpt}"
                        for s in sources
                    ])
            except Exception:
                sources = []

        system_prompt = (
            "You are AI Advocate, an Indian legal information assistant. "
            "You ONLY answer questions about Indian law — Acts, sections, rights, court procedures, "
            "judgments, case theories, and legal matters in India. "
            "If the question is NOT about Indian law, respond ONLY with: "
            "'I'm AI Advocate, an Indian legal information assistant. I can only help with Indian legal questions. "
            "Please ask me about laws, rights, court procedures, or legal matters in India!'\n\n"
            "STRICT RULES FOR LEGAL QUESTIONS:\n"
            "1. BREVITY: Answer in 50–100 words. Only go longer if the complexity truly demands it.\n"
            "2. PLAIN LANGUAGE: Write for ordinary Indian citizens with no legal background. "
               "Immediately explain any legal term you use (e.g., 'FIR — a First Information Report, the formal police complaint').\n"
            "3. ACCURACY: Cite only Acts and section numbers you are confident about. "
               "If unsure of the exact section, write 'under the [Act name] — verify the exact section with an advocate'. "
               "Never invent fake section numbers, case names, or citations.\n"
            "4. PRACTICAL: Where useful, give 1–3 concrete next steps the person can take.\n"
            "5. NO GUARANTEES: Never predict what a court will decide or guarantee any legal outcome.\n"
            "6. FORMAT: Short paragraphs or up to 3 bullet points. No long headings.\n"
            "7. CLOSE: End every answer with exactly: "
               "'This is legal information, not professional legal advice — consult a licensed advocate for your specific situation.'"
        )

        full_prompt = (
            f"{system_prompt}\n\n"
            + (f"RETRIEVED LEGAL CONTEXT:\n{context_text}\n\n" if context_text else "")
            + f"USER QUESTION: {request.message}"
        )

        try:
            # Use native async API — no thread blocking, no event loop hacks
            response = await self.client.aio.models.generate_content(
                model=self.model,
                contents=full_prompt,
            )
            answer = response.text or "Unable to generate legal information."
        except Exception as e:
            err = str(e)
            # Try fallback model on 404/model errors
            if "404" in err or "NOT_FOUND" in err or "not available" in err.lower():
                try:
                    fallback = await self.client.aio.models.generate_content(
                        model="gemini-3.8-flash",
                        contents=full_prompt,
                    )
                    answer = fallback.text or "Unable to generate legal information."
                except Exception as e2:
                    raise ProviderNotConfiguredError(f"Gemini API Error: {str(e2)}")
            else:
                raise ProviderNotConfiguredError(f"Gemini API Error: {err}")

        if not sources:
            sources = self._extract_sources(request.message, answer)

        return ChatResponse(
            conversation_id=request.conversation_id or str(uuid4()),
            answer=answer,
            sources=sources,
            disclaimer=DISCLAIMER,
            demo=False,
        )


def get_provider(settings: Settings) -> AIProvider:
    if settings.demo_mode:
        return DemoProvider()
    if settings.ai_provider == "ollama_cloud":
        return OllamaCloudProvider(
            settings.ollama_base_url, settings.ollama_api_key, settings.ollama_model
        )
    if settings.ai_provider == "gemini_rag":
        return GeminiRAGProvider(settings)
    if settings.ai_provider == "demo":
        return DemoProvider()
    raise ProviderNotConfiguredError(f"Unknown AI_PROVIDER '{settings.ai_provider}'.")
