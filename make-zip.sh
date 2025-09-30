#!/usr/bin/env bash
# make-zip.sh
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say() { printf '%s\n' "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }

# 1) Build ou-tma.pdf if missing
if [[ ! -f "./ou-tma.pdf" ]]; then
  say "No ou-tma.pdf found; compiling from .ins and .dtx..."
  for c in pdflatex makeindex; do
    if ! need_cmd "$c"; then
      say "Error: '$c' not found in PATH. Please install TeX Live/MiKTeX tools."
      exit 1
    fi
  done

  pdflatex "./ou-tma.ins"
  pdflatex "./ou-tma.dtx"
  pdflatex "./ou-tma.dtx"
  makeindex -s gglo.ist -o "ou-tma.gls" "ou-tma.glo" || true
  makeindex -s gind.ist "ou-tma" || true
  pdflatex "./ou-tma.dtx"
  pdflatex "./ou-tma.dtx"
  pdflatex "./ou-tma.dtx"
fi

# 2) Clean old directory
[[ -d "./ou-tma" ]] && rm -rf "./ou-tma"

# 3) Create new directory
mkdir -p "./ou-tma"

# 4) Copy required files
cp "./ou-tma.dtx" "./ou-tma/"
cp "./ou-tma.ins" "./ou-tma/"
cp "./ou-tma.pdf" "./ou-tma/"
cp "./README.md"  "./ou-tma/"
cp "./examples/SampleTMA.tex" "./ou-tma/"

# 5) Normalize line endings (CRLF -> LF) for text files
normalize_file() {
  local f="$1"
  if need_cmd dos2unix; then
    dos2unix -q "$f" || true
  else
    local tmp="${f}.tmp.$$"
    # Try Python first
    if python3 - "$f" "$tmp" 2>/dev/null <<'PY'
import sys, io
src, dst = sys.argv[1], sys.argv[2]
with io.open(src, 'rb') as r:
    data = r.read().replace(b'\r\n', b'\n').replace(b'\r', b'\n')
with io.open(dst, 'wb') as w:
    w.write(data)
PY
    then
      : # success, nothing else to do
    else
      # Fallback: remove CRs with tr
      tr -d '\r' < "$f" > "$tmp"
    fi
    mv "$tmp" "$f"
  fi
}

normalize_file "./ou-tma/ou-tma.dtx"
normalize_file "./ou-tma/ou-tma.ins"
normalize_file "./ou-tma/README.md"
normalize_file "./ou-tma/SampleTMA.tex"

# 6) Zip the subdirectory into ou-tma.zip
say "Zipping files into ou-tma.zip..."

if need_cmd zip; then
  zip -rq "./ou-tma.zip" "./ou-tma"
else
  # Portable fallback: Python's zipfile
  python3 - <<'PY'
import os, zipfile
root = "ou-tma"
with zipfile.ZipFile("ou-tma.zip", "w", zipfile.ZIP_DEFLATED) as z:
    for dp, _, fns in os.walk(root):
        for fn in fns:
            p = os.path.join(dp, fn)
            z.write(p, p)
PY
fi

say ""
say "All done! The file 'ou-tma.zip' is ready."

