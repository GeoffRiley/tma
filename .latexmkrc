# .latexmkrc — drive a .dtx build with index & glossary

# Build PDF with pdflatex (adjust if you prefer lualatex/xelatex).
$pdf_mode = 1;
$pdflatex  = 'pdflatex %O -interaction=nonstopmode -file-line-error %S';

# Quiet(er) logs if you like:
$silent = 1;                   # comment out if you prefer chatter

# --- Let latexmk call make for missing files --------------------------------
$use_make = 1;          # same as passing -use-make on the CLI
$make     = 'make';     # or 'gmake' on BSDs, 'mingw32-make' on some Windows setups

# --- Custom dependencies -------------------------------------------------
# .idx → .ind using gind.ist (standard for .dtx docs)
add_cus_dep( 'idx', 'ind', 0, 'makeindex_gind' );

sub makeindex_gind {
  my ($base) = @_;             # e.g., "ou-tma.idx"
  system("makeindex -s gind.ist \"$base\"") == 0
    or die "makeindex (gind.ist) failed on $base\n";
}

# .glo → .gls using gglo.ist (glossary/changes for .dtx)
add_cus_dep( 'glo', 'gls', 0, 'makeindex_gglo' );

sub makeindex_gglo {
  my ($glo) = @_;
  (my $root = $glo) =~ s/\.glo$//;  # "ou-tma"
  system("makeindex -s gglo.ist -o \"$root.gls\" \"$root.glo\"") == 0
    or die "makeindex (gglo.ist) failed on $glo\n";
}

# --- Housekeeping --------------------------------------------------------
# Teach latexmk which generated files to clean as auxiliaries
$clean_ext = ' %R.glo %R.gls %R.glg %R.idx %R.ind %R.ilg';

# Optional: continuous preview default (you can still call -pvc explicitly)
# $preview_continuous_mode = 1;

# Optional: if your doc uses biblatex/biber, latexmk auto-detects it.
# If you want to force biber:
# $bibtex_use = 2;
