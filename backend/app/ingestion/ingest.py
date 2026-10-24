import os
import sys
from pathlib import Path
import pdfplumber
from app.config import get_settings
from app.ingestion.chunker import LegalChunker
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.schema import Document

def ingest_documents():
    settings = get_settings()
    raw_dir = Path(settings.corpus_dir)

    if not raw_dir.exists():
        print(f"Error: Raw data directory {raw_dir} does not exist.")
        return

    print(f"Loading documents from {raw_dir}...")

    chunker = LegalChunker()
    embeddings = GoogleGenerativeAIEmbeddings(
        model=settings.gemini_embed_model,
        google_api_key=settings.gemini_api_key
    )

    all_docs = []

    for file_path in raw_dir.glob("*"):
        if file_path.suffix.lower() == ".pdf":
            print(f"Processing PDF: {file_path.name}")
            text = ""
            with pdfplumber.open(file_path) as pdf:
                for page in pdf.pages:
                    text += page.extract_text() + "\n"

            # Use filename as act name for simplicity
            act_name = file_path.stem
            chunks = chunker.chunk_text(text, act_name)

            for c in chunks:
                all_docs.append(Document(
                    page_content=c["content"],
                    metadata=c["metadata"]
                ))

        elif file_path.suffix.lower() in [".txt", ".md"]:
            print(f"Processing Text/MD: {file_path.name}")
            with open(file_path, 'r', encoding='utf-8') as f:
                text = f.read()

            act_name = file_path.stem
            chunks = chunker.chunk_text(text, act_name)

            for c in chunks:
                all_docs.append(Document(
                    page_content=c["content"],
                    metadata=c["metadata"]
                ))

    if not all_docs:
        print("No documents found to ingest.")
        return

    print(f"Ingesting {len(all_docs)} chunks into ChromaDB at {settings.chroma_dir}...")

    vectorstore = Chroma.from_documents(
        documents=all_docs,
        embedding=embeddings,
        persist_directory=settings.chroma_dir
    )

    print("Ingestion complete.")

if __name__ == "__main__":
    ingest_documents()
