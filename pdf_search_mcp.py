#!/usr/bin/env python3
"""
MCP Server: PDF Search for lp-study
Exposes tools to list and search across PDFs in any directory of the workspace.
"""

import os
import re
import subprocess
from pathlib import Path
from typing import Optional

from mcp.server.fastmcp import FastMCP

WORKSPACE = Path(__file__).parent

mcp = FastMCP("pdf-search")


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


def _pdf_to_text(pdf_path: Path) -> str:
    """Extract text from a PDF using pdftotext (fast) or pdfminer fallback."""
    try:
        result = subprocess.run(
            ["pdftotext", str(pdf_path), "-"],
            capture_output=True, text=True, timeout=30
        )
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass

    # Fallback: pdfminer
    try:
        from pdfminer.high_level import extract_text
        return extract_text(str(pdf_path))
    except Exception as e:
        return f"[Error extracting text: {e}]"


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
        text = _pdf_to_text(pdf)
        matches = list(pattern.finditer(text))
        if not matches:
            continue

        rel_path = pdf.relative_to(WORKSPACE)
        for match in matches:
            if total_matches >= max_results:
                break
            start = max(0, match.start() - context_chars // 2)
            end = min(len(text), match.end() + context_chars // 2)
            snippet = text[start:end].replace("\n", " ").strip()
            results.append(f"[{rel_path}]\n...{snippet}...\n")
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
    text = _pdf_to_text(pdf)
    return f"=== {pdf.relative_to(WORKSPACE)} ===\n\n{text}"


if __name__ == "__main__":
    mcp.run()
