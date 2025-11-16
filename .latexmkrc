# .latexmkrc — drive a .dtx build with index & glossary

# Build PDF with pdflatex (adjust if you prefer lualatex/xelatex).
$pdf_mode = 1;
# $pdflatex  = 'pdflatex %O -interaction=nonstopmode -file-line-error %S';
set_tex_cmds('-shell-escape -synctex=1 -file-line-error %O %S');
$max_repeat = 5;

# Quiet(er) logs if you like:
#$silent = 1;                   # comment out if you prefer chatter

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
my @clean_ext = qw(
  %R-blx.aux
  %R-blx.bib
  acn
  acr
  alg
  aux
  bbl
  bcf
  blg
  brf
  cb
  cb2
  cpt
  cut
  dvi
  fdb_latexmk
  fls
  fmt
  fot
  glg
  glo
  gls
  glsdefs
  idx
  ilg
  ind
  ist
  lb
  listing
  loa
  loe
  lof
  log
  lol
  lot
  lox
  nav
  out
  pdfsync
  pre
  run.xml
  snm
  soc
  synctex
  synctex(busy)
  synctex.gz
  synctex.gz(busy)
  tdo
  thm
  toc
  upa
  upb
  vrb
  xcp
  xdv
  xmpi
  xyc
  *-converted-to.*
  */*-converted-to.*
  */*/*-converted-to.*
  */*/*/*-converted-to.*
);
$clean_ext = join ' ', @clean_ext;

no warnings 'redefine';

# Overwrite `cleanup1` functions to support more general pattern in $clean_ext.
# Ref: https://github.com/e-dschungel/latexmk-config/blob/master/latexmkrc
sub cleanup1 {
    my $dir = fix_pattern( shift );
    my $root_fixed = fix_pattern( $root_filename );
    foreach (@_) {
        (my $name = (/%R/ || /[\*\?]/) ? $_ : "%R.$_") =~ s/%R/$dir$root_fixed/;
        unlink_or_move( glob( "$name" ) );
    }
}
