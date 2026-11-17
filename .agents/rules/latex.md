---
trigger: glob
description: "LaTeX and Sweave/knitr formatting, macro and source-file rules"
globs: "*.tex, *.Rnw, *.bib, *.sty, *.cls"
---

# LaTeX rules

- **Do not edit unprompted**: Never modify `.tex` or `.Rnw` manuscript files unless explicitly instructed to create or edit them.
- **Use local macros and context**: Inspect the file preamble and any loaded macro or style files (such as local definition `.tex`, `.sty` or `.cls` files) before writing mathematics. Always use the locally defined macros (e.g., `\bb`, `\bx`, `\IR` or custom operator commands) instead of raw LaTeX primitives like `\mathbf{b}` or `\mathbb{R}`. When writing math in chat responses or Markdown files where local preambles are not loaded, translate custom macros into standard KaTeX-compatible LaTeX and wrap literal macro names in backticks in prose (e.g., `` `\bb` ``).
- **One sentence per line**: Write each sentence on its own line in `.tex` and `.Rnw` source files. Do not insert blank lines between sentences within the same paragraph; use a single blank line strictly for paragraph breaks, and use single spaces where inline spacing occurs.
- **Inline vs displayed fractions**: Never use `\frac` or `\dfrac` in inline prose. Write inline ratios with a solidus (e.g., `$1/\varepsilon$`, `$(S(0)-S_\infty)/S(0)$`) and reserve `\frac` and `\dfrac` for displayed equations or spacious array/tabular cells.
- **Displayed equations**: Integrate displayed equations grammatically into the surrounding sentence with no preceding colon, and punctuate after the equation according to the sentence grammar.
- **Regime tables in theorems**: When existence or stability conditions (e.g., LAS/GAS) split across multiple parameter inequalities, summarise the regimes with a compact `tabular` inside the `theorem` environment rather than nested prose conditionals.
- **Quotation marks and comments**: Use standard LaTeX quotation marks (`` ``...'' ``) rather than straight quotes (`"..."`). Three-hyphen sequences (`---`) are only permitted inside LaTeX comments (e.g., `% --- section ---`), never in typeset text.
- **Figures and file names**: Store figures in `FIGS/` and use hyphens (`-`), never underscores (`_`), in all `.tex`, `.Rnw`, `.bib` and figure file names.
- **Beamer slides (density and no overfill)**: Prefer more, less-crowded slides over fewer, more-crowded slides. Split distinct definitions, theorems, derivations or examples across separate frames rather than packing multiple blocks onto a single slide. Always inspect compiled `.log` files and rendered slides to ensure there is no vertical (`Overfull \vbox`) or horizontal (`Overfull \hbox`) text overfill.
