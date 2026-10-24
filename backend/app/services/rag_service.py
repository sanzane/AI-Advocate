import numpy as np
from typing import List, Dict, Any
from rank_bm25 import BM25Okapi
from langchain_community.vectorstores import Chroma
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from app.config import Settings
from app.schemas.chat import Source

class RAGService:
    """
    Handles Hybrid Search (Semantic + Keyword) using ChromaDB and BM25.
    """

    def __init__(self, settings: Settings):
        self.settings = settings
        self.embeddings = GoogleGenerativeAIEmbeddings(
            model=settings.gemini_embed_model,
            google_api_key=settings.gemini_api_key
        )
        self.vectorstore = Chroma(
            persist_directory=settings.chroma_dir,
            embedding_function=self.embeddings
        )

        # BM25 state
        self.bm25 = None
        self.all_docs = []
        self._initialize_bm25()

    def _initialize_bm25(self):
        """Load all documents from Chroma to build the BM25 index."""
        # This is a simplified load. For huge datasets, we'd store BM25 separately.
        data = self.vectorstore.get()
        self.all_docs = data.get("documents", [])
        if not self.all_docs:
            return

        tokenized_corpus = [doc.lower().split() for doc in self.all_docs]
        self.bm25 = BM25Okapi(tokenized_corpus)

    def _rrf_rank(self, semantic_results: List[int], keyword_results: List[int], k=60):
        """Reciprocal Rank Fusion to merge results."""
        scores = {}
        for rank, idx in enumerate(semantic_results):
            scores[idx] = scores.get(idx, 0) + 1 / (rank + k)
        for rank, idx in enumerate(keyword_results):
            scores[idx] = scores.get(idx, 0) + 1 / (rank + k)

        # Sort by score descending
        sorted_indices = sorted(scores.keys(), key=lambda x: scores[x], reverse=True)
        return sorted_indices

    async def retrieve(self, query: str) -> List[Source]:
        """
        Perform Hybrid Search and return a list of Source objects.
        """
        # 1. Semantic Search
        semantic_docs = self.vectorstore.similarity_search_with_score(query, k=self.settings.retrieval_top_k * 2)
        # Chroma returns (Document, score). Convert to indices relative to all_docs if possible,
        # but Chroma similarity_search_with_score returns Documents.
        # Let's simplify: use the content to find indices for RRF.
        semantic_indices = []
        for doc, score in semantic_docs:
            try:
                semantic_indices.append(self.all_docs.index(doc.page_content))
            except ValueError:
                continue

        # 2. Keyword Search (BM25)
        keyword_indices = []
        if self.bm25:
            tokenized_query = query.lower().split()
            # Get top K indices
            scores = self.bm25.get_scores(tokenized_query)
            keyword_indices = np.argsort(scores)[::-1][:self.settings.retrieval_top_k * 2].tolist()

        # 3. Merge results with RRF
        merged_indices = self._rrf_rank(semantic_indices, keyword_indices)

        # 4. Format into Sources
        sources = []
        final_indices = merged_indices[:self.settings.retrieval_top_k]

        # Retrieve full metadata for the winners
        # We need to match indices back to metadata.
        # In our simplified setup, all_docs is just strings.
        # We'll query Chroma again for the specific texts to get metadata.
        for idx in final_indices:
            text = self.all_docs[idx]
            # Get metadata from vectorstore for this specific text
            results = self.vectorstore.similarity_search(text, k=1)
            if results:
                meta = results[0].metadata
                sources.append(Source(
                    id=str(idx),
                    title=meta.get("title", "Legal Document"),
                    act=meta.get("act"),
                    section=meta.get("section"),
                    excerpt=text[:500],
                    official_url=meta.get("official_url")
                ))

        return sources
