
import subprocess
from pathlib import Path


class PdfConversionError(RuntimeError):
    pass


def convert_docx_to_pdf(docx_path: Path, output_dir: Path) -> Path:
    docx_path = Path(docx_path)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    result = subprocess.run(
        [
            "soffice",
            "--headless",
            "--convert-to", "pdf",
            "--outdir", str(output_dir),
            str(docx_path),
        ],
        capture_output=True,
        text=True,
        timeout=60,
    )

    pdf_path = output_dir / (docx_path.stem + ".pdf")

    if result.returncode != 0 or not pdf_path.exists():
        raise PdfConversionError(
            f"LibreOffice conversion failed (code {result.returncode}).\n"
            f"stdout: {result.stdout}\nstderr: {result.stderr}"
        )

    return pdf_path
