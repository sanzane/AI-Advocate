import re
from typing import List, Dict, Any

class LegalChunker:
    """
    Splits Indian legal texts by Section and Chapter to ensure
    statutory boundaries are preserved.
    """

    # Matches patterns like "Section 302.", "Section 126 of BNS", "Sec. 498A"
    SECTION_PATTERN = re.compile(
        r'(?m)^(?:Section|Sec\.)\s+(\d+[A-Z]?)(?:\s+of\s+[\w\s]+)?[:\.\s\-]+',
        re.IGNORECASE
    )

    def chunk_text(self, text: str, act_name: str, official_url: str = "") -> List[Dict[str, Any]]:
        """
        Chunks text by legal section.
        Returns a list of dicts containing chunk content and metadata.
        """
        chunks = []

        # Split text by section boundaries
        # We use a regex split that keeps the delimiter
        parts = self.SECTION_PATTERN.split(text)

        # parts[0] is text before first section
        if parts[0].strip():
            chunks.append({
                "content": parts[0].strip(),
                "metadata": {
                    "act": act_name,
                    "section": "Introduction",
                    "title": "Introduction",
                    "official_url": official_url
                }
            })

        # The split returns (delimiter, content, delimiter, content...)
        # Since our regex has a capturing group (\d+[A-Z]?), it returns the section number
        for i in range(1, len(parts), 2):
            section_num = parts[i]
            section_content = parts[i+1] if (i+1) < len(parts) else ""

            # Try to extract a title (first line of the section)
            lines = section_content.strip().split('\n')
            title = lines[0][:100] if lines else "Legal Provision"

            chunks.append({
                "content": f"Section {section_num}: {section_content.strip()}",
                "metadata": {
                    "act": act_name,
                    "section": section_num,
                    "title": title,
                    "official_url": official_url
                }
            })

        return chunks
