
import json
import re
from pathlib import Path

from docx.shared import Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

CONFIG_PATH = Path(__file__).resolve().parent.parent / "config" / "config.json"


def load_config(path: Path = None) -> dict:
    path = path or CONFIG_PATH
    with open(path, encoding="utf-8") as f:
        return json.load(f)






def parse_length(value) -> Inches:
    if isinstance(value, (int, float)):
        return Inches(value)
    m = re.match(r"([\d.]+)\s*(in|px|pt|cm)?", str(value).strip())
    num = float(m.group(1))
    unit = m.group(2) or "in"
    if unit == "in":
        return Inches(num)
    if unit == "px":
        return Inches(num / 96.0)
    if unit == "pt":
        return Inches(num / 72.0)
    if unit == "cm":
        return Inches(num / 2.54)
    return Inches(num)


def parse_size_pt(value) -> Pt:
    if isinstance(value, (int, float)):
        return Pt(value)
    m = re.match(r"([\d.]+)\s*(pt|px)?", str(value).strip())
    num = float(m.group(1))
    unit = m.group(2) or "pt"
    if unit == "px":
        return Pt(num * 0.75)
    return Pt(num)


def parse_color(value) -> RGBColor:
    named = {"black": "000000", "white": "FFFFFF"}
    v = str(value).strip().lstrip("#")
    v = named.get(v.lower(), v)
    return RGBColor(int(v[0:2], 16), int(v[2:4], 16), int(v[4:6], 16))


def parse_hex(value) -> str:
    named = {"black": "000000", "white": "FFFFFF"}
    v = str(value).strip().lstrip("#")
    return named.get(v.lower(), v)


def parse_property(value):
    v = str(value).lower()
    return ("bold" in v, "underline" in v)


def parse_align(value):
    v = str(value).lower()
    return {
        "start": WD_ALIGN_PARAGRAPH.LEFT,
        "left": WD_ALIGN_PARAGRAPH.LEFT,
        "center": WD_ALIGN_PARAGRAPH.CENTER,
        "end": WD_ALIGN_PARAGRAPH.RIGHT,
        "right": WD_ALIGN_PARAGRAPH.RIGHT,
        "justify": WD_ALIGN_PARAGRAPH.JUSTIFY,
    }.get(v, WD_ALIGN_PARAGRAPH.LEFT)


class Style:

    def __init__(self, section: dict):
        self._section = section

    def length(self, key, default=None):
        return parse_length(self._section.get(key, default))

    def size(self, key, default=None):
        return parse_size_pt(self._section.get(key, default))

    def color(self, key, default="#000000"):
        return parse_color(self._section.get(key, default))

    def hex(self, key, default="000000"):
        return parse_hex(self._section.get(key, default))

    def font(self, key, default="Times New Roman"):
        return self._section.get(key, default)

    def bold_underline(self, key, default="Regular"):
        return parse_property(self._section.get(key, default))

    def align(self, key, default="start"):
        return parse_align(self._section.get(key, default))

    def raw(self, key, default=None):
        return self._section.get(key, default)


class AppStyles:

    def __init__(self, config: dict = None):
        self._config = config or load_config()
        self.page = Style(self._config.get("page", {}))
        self.logo = Style(self._config.get("logo", {}))
        self.title = Style(self._config.get("title", {}))
        self.student = Style(self._config.get("student_details", {}))
        self.heading = Style(self._config.get("heading_section", {}))
        self.body = Style(self._config.get("body_section", {}))
        self.output = Style(self._config.get("output_section", {}))

    @classmethod
    def from_file(cls, path: Path = None):
        return cls(load_config(path))
