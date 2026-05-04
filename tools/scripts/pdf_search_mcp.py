#!/usr/bin/env python3
"""
MCP Server: PDF Search for lp-study
Exposes tools to list and search across PDFs in any directory of the workspace.
Always returns citation info (source file + page number) with every result.
"""

import re
import subprocess
from pathlib import Path
from typing import Optional

from mcp.server.fastmcp import FastMCP

WORKSPACE = Path(__file__).parent.parent.parent  # project root: lp-study/

mcp = FastMCP("pdf-search")

# Page separator inserted by pdftotext between pages
PAGE_SEP = "\f"


def _find_pdfs(directories: Optional[list[str]] = None) -> list[Path]:
    """Recursively find all PDFs in given directories (or whole workspace)."""
    search_roots = []
    if directories:
        for d in directories:
            p = Path(d) if Path(d).is_absolute() else WORKSPACE / d
            search_roots.append(p)
    else:
        search_roots = [WORKSPACE]

    pdfs = []
    for root in search_roots:
        if root.exists():
            pdfs.extend(root.rglob("*.pdf"))
    return sorted(pdfs)


def _pdf_to_pages(pdf_path: Path) -> list[str]:
    """
    Extract text from a PDF and return a list of strings, one per page.
    Uses pdftotext (preserves form-feed page separators) with pdfminer fallback.
    """
    try:
        result = subprocess.run(
            ["pdftotext", str(pdf_path), "-"],
            capture_output=True, text=True, timeout=60
        )
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.split(PAGE_SEP)
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass

    # Fallback: pdfminer page-by-page extraction
    try:
        from pdfminer.high_level import extract_pages
        from pdfminer.layout import LTTextContainer
        pages = []
        for page_layout in extract_pages(str(pdf_path)):
            page_text = ""
            for element in page_layout:
                if isinstance(element, LTTextContainer):
                    page_text += element.get_text()
            pages.append(page_text)
        return pages
    except Exception as e:
        return [f"[Error extracting text: {e}]"]


def _pdf_to_text(pdf_path: Path) -> str:
    """Return full text of a PDF (all pages joined)."""
    return "\n".join(_pdf_to_pages(pdf_path))


def _format_citation(rel_path: Path, page_num: int) -> str:
    """Format a citation string for a match."""
    return f"{rel_path.stem} (p. {page_num}) — [{rel_path}]"


@mcp.tool()
def list_pdfs(directory: str = "") -> str:
    """
    List all PDF files available in the workspace.
    Optionally filter by subdirectory (e.g. 'teoria').
    """
    dirs = [directory] if directory else None
    pdfs = _find_pdfs(dirs)
    if not pdfs:
        return "No PDFs found."
    lines = [f"Found {len(pdfs)} PDF(s):"]
    for p in pdfs:
        lines.append(f"  - {p.relative_to(WORKSPACE)}")
    return "\n".join(lines)


@mcp.tool()
def search_pdfs(
    query: str,
    directory: str = "",
    context_chars: int = 400,
    max_results: int = 10,
) -> str:
    """
    Search for a text query across all PDFs in the workspace (or a subdirectory).
    Results always include the source file name and page number as citation.

    Args:
        query: Text to search for (case-insensitive, supports regex).
        directory: Optional subdirectory to restrict search (e.g. 'teoria').
        context_chars: Number of characters to show around each match.
        max_results: Maximum number of matches to return.
    """
    dirs = [directory] if directory else None
    pdfs = _find_pdfs(dirs)
    if not pdfs:
        return "No PDFs found to search."

    pattern = re.compile(query, re.IGNORECASE)
    results = []
    total_matches = 0

    for pdf in pdfs:
        pages = _pdf_to_pages(pdf)
        rel_path = pdf.relative_to(WORKSPACE)

        for page_idx, page_text in enumerate(pages):
            if total_matches >= max_results:
                break
            matches = list(pattern.finditer(page_text))
            if not matches:
                continue

            page_num = page_idx + 1
            citation = _format_citation(rel_path, page_num)

            for match in matches:
                if total_matches >= max_results:
                    break
                start = max(0, match.start() - context_chars // 2)
                end = min(len(page_text), match.end() + context_chars // 2)
                snippet = page_text[start:end].replace("\n", " ").strip()
                results.append(f"📄 {citation}\n   ...{snippet}...\n")
                total_matches += 1

        if total_matches >= max_results:
            break

    if not results:
        return f"No matches found for '{query}'."

    header = f"Found {total_matches} match(es) for '{query}':\n{'='*60}\n"
    return header + "\n".join(results)


@mcp.tool()
def read_pdf(filename: str, directory: str = "") -> str:
    """
    Extract and return the full text content of a specific PDF.
    Output includes page numbers for easy citation.

    Args:
        filename: PDF filename (e.g. '05-Tipos.pdf') or partial name.
        directory: Optional subdirectory to search in (e.g. 'teoria').
    """
    dirs = [directory] if directory else None
    pdfs = _find_pdfs(dirs)

    matches = [p for p in pdfs if filename.lower() in p.name.lower()]
    if not matches:
        return f"No PDF found matching '{filename}'."
    if len(matches) > 1:
        names = "\n".join(f"  - {p.relative_to(WORKSPACE)}" for p in matches)
        return f"Multiple PDFs match '{filename}', be more specific:\n{names}"

    pdf = matches[0]
    rel_path = pdf.relative_to(WORKSPACE)
    pages = _pdf_to_pages(pdf)

    output = [f"=== {rel_path} ===\n"]
    for i, page_text in enumerate(pages):
        output.append(f"--- Página {i+1} ---\n{page_text}")
    return "\n".join(output)


if __name__ == "__main__":
    mcp.run()
