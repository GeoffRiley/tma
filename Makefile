# Makefile for a docstrip LaTeX project
# Inputs:  ou-tma.dtx, ou-tma.ins
# Outputs: ou-tma.sty, ou-tma-sup.sty, doc-changes.sty, ou-tma.pdf
#
# Usage:
#   make            # build all styles + documentation PDF
#   make pdf        # (re)build PDF only (assumes .sty exist)
#   make extract    # (re)extract .sty from .ins
#   make clean      # remove aux files
#   make distclean  # clean + remove generated .sty and PDF
#   make watch      # live preview of the documentation

# ---- project names ----------------------------------------------------------

DTX      := ou-tma.dtx
INS      := ou-tma.ins

STYLES   := ou-tma.sty ou-tma-sup.sty doc-changes.sty
DOCPDF   := ou-tma.pdf

# ---- tools -----------------------------------------------------------------

LATEXMK      := latexmk
PDFLATEX     := pdflatex
MAKEINDEX    := makeindex

# latexmk opts: quiet, file:line:error, non-stop
LATEXMK_OPTS := -pdf -interaction=nonstopmode -file-line-error -quiet

# Index style files provided by l3doc/doc
GIND_IST := gind.ist
GGLO_IST := gglo.ist

# A stamp to avoid re-running extraction for each .sty target
EXTRACT_STAMP := .extract.stamp

# ---- default target ---------------------------------------------------------

.PHONY: all
all: $(STYLES) $(DOCPDF)

# ---- extract styles (docstrip) ---------------------------------------------

# Running the .ins usually emits all .sty files at once. We wrap it in a
# single rule that touches a stamp file; the .sty files depend on that stamp.

$(EXTRACT_STAMP): $(INS) $(DTX)
    $(PDFLATEX) -interaction=nonstopmode -halt-on-error $(INS)
    touch $(EXTRACT_STAMP)

# Each .sty is considered updated when the extraction stamp updates.
$(STYLES): $(EXTRACT_STAMP)

extract: $(STYLES)

# ---- build documentation PDF -----------------------------------------------

# We drive the doc build with latexmk, but we also ensure the doc index (.ind)
# and glossary (.gls) are produced using the canonical makeindex calls for
# .dtx docs (gind.ist and gglo.ist). The first latexmk run creates .idx/.glo,
# then we run makeindex (if those files exist), then latexmk again to fold
# them into the final PDF.

$(DOCPDF): $(DTX) $(STYLES)
    $(LATEXMK) $(LATEXMK_OPTS) $(DTX)

pdf: $(DOCPDF)

# ---- dev niceties -----------------------------------------------------------

watch: $(STYLES)
    $(LATEXMK) -pvc $(LATEXMK_OPTS) $(DTX)

# ---- cleaning ---------------------------------------------------------------

# latexmk -c removes typical aux files; we also remove docstrip’s .tmp etc.
clean:
    $(LATEXMK) -c
    rm -f $(basename $(DTX)).glo $(basename $(DTX)).gls \
        $(basename $(DTX)).glg $(basename $(DTX)).idx \
        $(basename $(DTX)).ind $(basename $(DTX)).ilg \
        $(EXTRACT_STAMP)

distclean: clean
    rm -f $(STYLES) $(DOCPDF)

# ---- safety -----------------------------------------------------------------

# Never treat these as files
.PHONY: all extract pdf watch
