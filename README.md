# AI Advocate (Mobile Android App)

**AI Advocate** is a mobile-first legal information and research assistant tailored for Indian citizens. It explains complex statutory provisions, rights, and legal procedures in plain, accessible language with verifiable sources, structured case briefs, and localized matter workspaces.

> **Statutory Notice & Disclaimer:** AI Advocate provides general educational legal information, not formal legal advice or representation. It does not promise legal outcomes and never fabricates citations or official URLs. Users are always encouraged to consult a registered advocate licensed by the State Bar Council.

---

## What AI Advocate Does

- **Plain-Language Legal Research:** Ask questions in everyday language regarding tenancy disputes, cyber fraud, consumer grievances, labor rights, and civil claims.
- **Statutory Source Attribution:** Inspect source provisions (e.g., Bharatiya Nyaya Sanhita, Consumer Protection Act, Transfer of Property Act) with excerpts and statutory identifiers.
- **Interactive Case Workspaces (My Cases):** Create, edit, and organize matters with summary notes and attached evidence/documents.
- **Structured Case Briefs:** Review situation summaries, key facts, applicable provisions, missing information, and precise questions to discuss with an advocate.
- **Saved Research & Bookmarks:** Save research answers and statutory references for offline recall and quick access.

---

## Current Architecture

The project follows a clean, decoupled client-server architecture:

```
ai_advocate/
├── lib/
│   ├── main.dart                  # App bootstrap with Riverpod ProviderScope
│   ├── app.dart                   # MaterialApp with M3 Judicial Clarity theme & GoRouter
│   ├── core/
│   │   ├── config/app_config.dart # Single source of truth for API base URL & runtime flags
│   │   ├── routing/               # GoRouter with bottom navigation shell & subroutes
│   │   ├── theme/                 # Judicial Clarity theme tokens (Navy, Cobalt, Ivory)
│   │   └── widgets/               # Reusable cards, empty states, error banners, badges
│   ├── data/
│   │   ├── models/                # Pydantic-compatible ChatRequest, ChatResponse, SourceRef
│   │   ├── repositories/          # ApiChatRepository & LocalDemoChatRepository
│   │   └── services/              # Dio HTTP client with network error mapping
│   ├── features/
│   │   ├── auth/                  # Phone onboarding & user profile management
│   │   ├── home/                  # Legal question composer, quick actions, recent research
│   │   ├── chat/                  # Message bubbles, markdown answers, waiting & retry states
│   │   ├── cases/                 # Case workspace list, create/edit/delete, documents
│   │   ├── case_brief/            # Structured case brief screen
│   │   ├── research/              # Detailed answer view with modular sections
│   │   ├── saved/                 # Searchable bookmarked answers and legal provisions
│   │   └── sources/               # Source metadata modal sheet with official link launcher
│   └── shared/                    # Riverpod providers and relative time formatting
├── backend/
│   ├── app/
│   │   ├── main.py                # FastAPI app with CORS middleware
│   │   ├── config.py              # Pydantic & environment settings
│   │   ├── api/routes.py          # GET /health and POST /api/chat
│   │   ├── schemas/chat.py        # Validated data contracts
│   │   └── services/provider.py   # AIProvider, DemoProvider, OllamaCloudProvider
│   ├── test_backend.py            # Backend automated test suite
│   ├── requirements.txt           # Python backend dependencies
│   └── .env.example               # Environment variables template
├── android/                       # Native Android scaffold (SDK 36, Internet & Cleartext enabled)
└── test/                          # Flutter unit & widget test suites
```

---

## What Works Now vs. What Is Demo-Only

| Feature | Status | Notes |
|---|---|---|
| **Flutter Android Build** | Working | Compiles debug APK cleanly with Material 3 |
| **Tab Navigation & Subroutes** | Working | Bottom bar (Home, Ask AI, Cases, Saved) + nested detail routes |
| **Interactive Chat** | Working | Communicates with FastAPI backend or local fallback |
| **Markdown Rendering** | Working | Rich formatting for legal answers and bullet lists |
| **Case Workspaces (CRUD)** | Working | Create, edit, delete with confirmation, and mock document attachments |
| **Saved Items & Search** | Working | Real-time filtering and bookmark toggling |
| **FastAPI Backend (`/health`, `/api/chat`)** | Working | Returns structured responses with sample Indian legal sources |
| **Ollama Cloud / Gemma Abstraction** | Working | Clean HTTP client ready in `provider.py` |
| **Document OCR & Cloud Sync** | Demo / Roadmap | UI previews files locally; server-side OCR is planned |
| **Full RAG Corpus Retrieval** | Future | Interface prepared in backend service layer |

---

## Prerequisites

1. **Flutter SDK:** Stable channel (3.24+ or 3.47+ recommended). Run `flutter doctor` to verify.
2. **Android Setup:**
   - Android Studio with Android SDK Command-line Tools and Android SDK Platform 34+.
   - USB debugging enabled on your physical phone or an Android Virtual Device (AVD).
3. **Python:** Python 3.10 to 3.12 for the FastAPI backend.

---

## Step-by-Step Setup Guide

### 1. Set Up the Flutter App

From the project root:
```bash
# Fetch Flutter packages
flutter pub get

# Verify static analysis (0 errors)
flutter analyze

# Run unit and widget test suite
flutter test
```

### 2. Set Up and Run the Backend

Open a terminal window and navigate to `backend`:
```bash
cd backend

# Create and activate virtual environment (Windows)
python -m venv .venv
.venv\Scripts\activate

# macOS / Linux
# python3 -m venv .venv
# source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run backend tests to verify
python test_backend.py

# Start the FastAPI server on port 8000
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
Verify the server in your browser or curl:
- Health check: `http://localhost:8000/health`
- Swagger documentation: `http://localhost:8000/docs`

---

## How to Run on an Android Device

### Option A: Physical Android Phone via USB (Recommended)

1. **Enable Developer Options & USB Debugging:**
   - Open **Settings** → **About phone** on your Android device.
   - Tap **Build Number** 7 times until you see *"You are now a developer!"*.
   - Go to **Settings** → **System / Developer options** → Turn on **USB Debugging**.
2. **Connect Device:**
   - Connect your phone to your PC via USB and tap **Allow USB debugging** when prompted.
   - Check that Flutter detects your device:
     ```bash
     flutter devices
     ```
3. **Set Up Port Forwarding:**
   Because a physical phone's `localhost` points to the phone itself, run ADB reverse so port 8000 redirects to your PC:
   ```bash
   adb reverse tcp:8000 tcp:8000
   ```
4. **Launch AI Advocate:**
   ```bash
   flutter run
   ```

### Option B: Android Emulator

1. Start your Android Emulator from Android Studio or via CLI:
   ```bash
   flutter emulators --launch <emulator_id>
   ```
2. The Android emulator reaches your computer's `localhost` via the special IP alias `10.0.2.2`:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
   ```

### Option C: Standalone Offline Demo Mode

To test or demo the app without starting the Python backend at all:
```bash
flutter run --dart-define=USE_BACKEND=false
```
In this mode, `LocalDemoChatRepository` generates structured answers and source references entirely within the app.

---

## Building a Debug APK

To produce a standalone `.apk` installer:
```bash
flutter build apk --debug
```
The output file is generated at:
`build/app/outputs/flutter-apk/app-debug.apk`

You can install it directly onto any connected phone using:
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

## Ollama Cloud & Gemma 4 31B Integration

The backend is pre-configured with a provider abstraction in `backend/app/services/provider.py`.

To connect to Ollama Cloud:
1. In `backend/.env`, set:
   ```env
   DEMO_MODE=false
   AI_PROVIDER=ollama_cloud
   OLLAMA_CLOUD_BASE_URL=https://<your-ollama-cloud-endpoint>
   OLLAMA_CLOUD_API_KEY=<your_ollama_cloud_api_key>
   OLLAMA_MODEL=gemma4:31b
   ```
2. Restart the FastAPI server.
3. The provider automatically formats prompts for Indian legal grounding and streams responses to the Flutter app.

---

## Open Source & Model Attribution

- **License:** The source code of this application is released under the [MIT License](LICENSE).
- **Model Attribution:** Gemma is an open-weights model developed by Google. Use of Gemma is subject to the [Gemma Terms of Use](https://ai.google.dev/gemma/terms).
- **Statutory Data:** Indian statutes (Bharatiya Nyaya Sanhita, Consumer Protection Act, Transfer of Property Act, Constitution of India) are public legal domain instruments.
