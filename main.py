import uuid
from pathlib import Path
from typing import Literal, Optional

from docx import Document
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from pydantic import BaseModel, ConfigDict

from core import assuic, converter
from core.styles import AppStyles
from modules import body, header, heading, output_box, student_section

BASE_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = BASE_DIR / "output"

app = FastAPI(title="AssignmentUIC")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

STYLES = AppStyles.from_file()


class StudentDetails(BaseModel):
    model_config = ConfigDict(extra="forbid")
    left: dict[str, str]
    right: dict[str, str]


class WorksheetMeta(BaseModel):
    model_config = ConfigDict(extra="forbid")
    title: str
    output: Literal["Terminal", "Written", "Image"] = "Terminal"
    generate: Literal["PDF", "DOCX"] = "PDF"


class GenerateRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")
    student_details: StudentDetails
    worksheet: WorksheetMeta
    content: str
    output_image_path: Optional[str] = None


class GenerateResponse(BaseModel):
    docx: Optional[str] = None
    pdf: Optional[str] = None


def _render_section(
    document: Document,
    key: str,
    raw: str,
    output_mode: str,
    image_path: Optional[str],
    is_first: bool,
) -> None:
    heading.add_heading(document, key, STYLES, is_first=is_first)
    key_lower = key.strip().lower()

    if key_lower.startswith("source code"):
        body.add_assuic_code(document, raw, STYLES)
    elif key_lower.startswith("output"):
        mode = output_mode.lower()
        if mode == "image":
            output_box.add_image_output(document, image_path, STYLES)
        elif mode == "written":
            output_box.add_assuic_written_output(document, raw, STYLES)
        else:
            output_box.add_assuic_output(document, raw, STYLES)
    elif key_lower in {"objective", "learning outcomes", "learning outcome"}:
        body.add_assuic_bullets(
            document,
            raw,
            STYLES,
            keep_together=key_lower.startswith("learning"),
        )
    elif key_lower == "aim":
        if "&assuicbullet" in raw:
            body.add_assuic_bullets(document, raw, STYLES)
        else:
            body.add_bullets(document, [raw.strip()], STYLES)
    elif key_lower == "theory":
        body.add_assuic_paragraph(document, raw, STYLES)
    elif "&assuicbullet" in raw:
        body.add_assuic_bullets(document, raw, STYLES)
    else:
        body.add_assuic_paragraph(document, raw, STYLES)


def _build_document(req: GenerateRequest) -> Document:
    document = Document()
    header.setup_page(document, STYLES)
    header.build_header(document, STYLES)
    student_section.build_student_section_lr(
        document,
        req.worksheet.title,
        req.student_details.left,
        req.student_details.right,
        STYLES,
    )

    fields = assuic.parse_payload(req.content)
    if not fields:
        raise HTTPException(
            status_code=422,
            detail="Could not parse any sections from content.",
        )

    for index, (key, raw) in enumerate(fields.items()):
        _render_section(
            document,
            key,
            raw,
            req.worksheet.output,
            req.output_image_path,
            index == 0,
        )

    return document


@app.post("/graphql", response_model=GenerateResponse)
def generate(req: GenerateRequest) -> GenerateResponse:
    document = _build_document(req)
    job_id = uuid.uuid4().hex[:10]
    docx_name = f"worksheet_{job_id}.docx"
    pdf_name = f"worksheet_{job_id}.pdf"

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    docx_path = OUTPUT_DIR / docx_name
    document.save(str(docx_path))

    if req.worksheet.generate == "DOCX":
        return GenerateResponse(docx=docx_name)

    try:
        converter.convert_docx_to_pdf(docx_path, OUTPUT_DIR)
    except converter.PdfConversionError as exc:
        docx_path.unlink(missing_ok=True)
        raise HTTPException(status_code=500, detail=str(exc)) from exc
    except Exception as exc:
        docx_path.unlink(missing_ok=True)
        raise HTTPException(
            status_code=500,
            detail="PDF conversion failed.",
        ) from exc

    docx_path.unlink(missing_ok=True)
    pdf_path = OUTPUT_DIR / pdf_name
    if not pdf_path.is_file():
        raise HTTPException(status_code=500, detail="PDF output was not created.")

    return GenerateResponse(pdf=pdf_name)


@app.get("/download/{filename}")
def download(filename: str) -> FileResponse:
    if "/" in filename or "\\" in filename or ".." in filename:
        raise HTTPException(status_code=400, detail="Invalid filename.")

    file_path = OUTPUT_DIR / filename
    if not file_path.is_file():
        raise HTTPException(status_code=404, detail="File not found.")

    if filename.lower().endswith(".pdf"):
        media_type = "application/pdf"
    elif filename.lower().endswith(".docx"):
        media_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    else:
        raise HTTPException(status_code=400, detail="Unsupported file type.")

    return FileResponse(
        str(file_path),
        media_type=media_type,
        filename=filename,
    )


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
