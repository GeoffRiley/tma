# ou-tma and ou-tma-sup Packages

## Versions

v1.21.3 (2025/11/12)
v0.12 (2025/10/28)

## Author

Geoff Riley (geoffr@adaso.com)

## License

Released under the LaTeX Project Public License v1.3c or later.

## Description

The `ou-tma` and `ou-tma-sup` packages provide macros and environments to assist in writing and answering Tutor Marked Assessments (TMAs) for Open University courses. They simplify the formatting of questions, parts, subparts, and includes useful mathematical commands. A `SampleTMA.tex` file is now provided as an example of usage.

## Repository

https://github.com/GeoffRiley/tma/

## Compiling and Installation

If the `ou-tma.sty` and `ou-tma-sup.sty` files are not provided, and you have, instead, `ou-tma.dtx` and `ou-tma.ins`, then follow this procedure:
- Compile the `ou-tma` package with `pdflatex ou-tma.ins`. This will create the `ou-tma.sty` and `ou-tma-sup.sty` files.
- Compile the `ou-tma` documentation with:
-  - `pdflatex ou-tma.dtx` (repeated several times)
-  - `makeindex -s gglo.ist -o ou-tma-chg-tma.gls ou-tma-chg-tma.glo`
-  - `makeindex -s gglo.ist -o ou-tma-chg-sup.gls ou-tma-chg-sup.glo`
-  - `makeindex -s gglo.ist -o ou-tma-chg-chg.gls ou-tma-chg-chg.glo`
-  - `makeindex -s gind.ist ou-tma`
-  - `pdflatex ou-tma.dtx` (several times again)

The `ou-tma.sty` and `ou-tma-sup.sty` files should be placed in an appropriate location within the TeX directory structure. For example in a directory such as tex/latex/ou-tma. The file `doc-changes.sty` is only used for formatting this documentation and may safely be ignore thereafter.

## Usage

Include the package(s) in your document:

```latex
\usepackage[options]{ou-tma}
```
or
```latex
\usepackage[options]{ou-tma}
\usepackage[options]{ou-tma-sup}
```
