# ou-tma Package

## Version

v1.21 (2025/09/30)

## Author

Geoff Riley (geoffr@adaso.com)

## License

Released under the LaTeX Project Public License v1.3c or later.

## Description

The `ou-tma` package provides macros and environments to assist in writing and answering Tutor Marked Assessments (TMAs) for Open University courses. It simplifies the formatting of questions, parts, subparts, and includes useful mathematical commands. A `SampleTMA.tex` file is now provided as an example of usage.

## Repository

https://github.com/GeoffRiley/tma/

## Compiling and Installation

If the `ou-tma.sty` file is not provided, and you have, instead, `ou-tma.dtx` and `ou-tma.ins`, then follow this procedure:
- Compile the `ou-tma` package with `pdflatex ou-tma.ins`. This will create the `ou-tma.sty` file.
- Compile the `ou-tma` documentation with:
-  - `pdflatex ou-tma.dtx` (repeated several times)
-  - `makeindex -s gglo.ist -o ou-tma.gls ou-tma.glo`
-  - `makeindex -s gind.ist ou-tma`
-  - `pdflatex ou-tma.dtx` (several times again)

The file `ou-tma.sty` file should be placed in an appropriate location within the TeX directory structure. For example in a directory such as tex/latex/ou-tma.

## Usage

Include the package in your document:

```latex
\usepackage[options]{ou-tma}
```
