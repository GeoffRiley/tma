# tma Package

## Version

v1.19 (2025/02/18)

## Author

Geoff Riley (geoffr@adaso.com)

## License

Released under the LaTeX Project Public License v1.3c or later.

## Description

The `tma` package provides macros and environments to assist in writing and answering Tutor Marked Assessments (TMAs) for Open University courses. It simplifies the formatting of questions, parts, subparts, and includes useful mathematical commands.

## Repository

https://github.com/GeoffRiley/tma/

## Compiling and Installation

If the `tma.sty` file is not provided, and you have, instead, `tma.dtx` and `tma.ins`, then follow this procedure:
- Compile the `tma` package with `pdflatex tma.ins`. This will create the `tma.sty` file.
- Compile the `tma` documentation with:
-  - `pdflatex tma.dtx` (repeated several times)
-  - `makeindex -s gglo.ist -o tma.gls tma.glo`
-  - `makeindex -s gind.ist tma`
-  - `pdflatex tma.dtx` (several times again)

The file `tma.sty` file should be placed in an appropriate location within the TeX directory structure. For example in a directory such as tex/latex/tma.

## Usage

Include the package in your document:

```latex
\usepackage[options]{tma}
```
