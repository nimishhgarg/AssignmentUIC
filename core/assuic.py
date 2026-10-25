
import re
from collections import OrderedDict

_FIELD_RE = re.compile(r'"(.*?)"\s*:\s*\{(.*?)\}\s*(?:,|\](?:\s*$))', re.DOTALL)


def parse_payload(raw: str) -> OrderedDict:
    raw = raw.strip()
    if raw.startswith("assuic="):
        raw = raw[len("assuic="):].strip()
    raw = raw.strip("[]").strip()
    
    raw = "[" + raw + "]"
    fields = OrderedDict()
    for m in _FIELD_RE.finditer(raw):
        key, value = m.group(1).strip(), m.group(2).strip()
        fields[key] = value
    return fields
