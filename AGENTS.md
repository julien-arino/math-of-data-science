# Project guidelines

## Rule files
Detailed rules live in `.agents/rules/`. Read and follow the applicable files before starting work:
- Authorial voice and writing style (always apply): @.agents/rules/authorial-voice-rules.md
- R and Julia code (`.R`, `.Rnw`, `.Rmd`, `.qmd`, `.jl`): @.agents/rules/code.md
- LaTeX and Sweave/knitr files (`.tex`, `.Rnw`, `.bib`, `.sty`, `.cls`): @.agents/rules/latex.md
- Tests, practice exams and exams: @.agents/rules/test-and-exams.md

## Writing style
- **No em dashes**: Do not use em dashes (`---` or `—`). Use commas, parentheses, colons, semicolons or separate sentences instead.
- **No Oxford commas**: Do not use the Oxford comma (serial comma) before the coordinating conjunction in lists (e.g., write "A, B and C", not "A, B, and C").
- **Sentence case**: Always use sentence case for titles, headings, labels and section headers (capitalising only the first word, proper nouns and acronyms).

## LaTeX in chat responses and markdown artifacts
- The chat UI and markdown artifacts render math using **KaTeX**, which does not load [setup_defs.tex](lecture-notes/setup_defs.tex).
- When editing `.Rnw` or `.tex` files, always use the project's custom macros from `setup_defs.tex` (e.g. `\M`, `\IR`, `\IRplus`, `\II`, `\11`, `\bx`, `\bb`, `\bbm`, `\bw`, `\b0`, `\balpha`, `\tr`, `\diag`, `\rank`, `\Span`, `\nullspace`, `\nullity`). Note: bold $\mathbf{m}$ is `\bbm` (`\bm` is reserved for the `bm` package).
- When writing math inside **chat responses or markdown artifacts** (`$...$` or `$$...$$`), always translate those custom macros into standard KaTeX-compatible LaTeX so they render cleanly:
  - `\A`..`\V` (such as `\M`, `\B`, `\C`, `\E`, `\F`, `\G`, `\H`, `\L`, `\N`, `\P`, `\R`, `\S`, `\T`, `\U`, `\V`) $\to$ `\mathcal{M}`, `\mathcal{B}`, etc.
  - `\IC`, `\IE`, `\IF`, `\II`, `\IJ`, `\IK`, `\IM`, `\IN`, `\IP`, `\IR`, `\IZ` $\to$ `\mathbb{C}`, `\mathbb{E}`, `\mathbb{F}`, `\mathbb{I}`, `\mathbb{J}`, `\mathbb{K}`, `\mathbb{M}`, `\mathbb{N}`, `\mathbb{P}`, `\mathbb{R}`, `\mathbb{Z}`
  - `\IRplus` $\to$ `\mathbb{R}_{\ge 0}`
  - `\11` or `\bone` $\to$ `\mathbf{1}` (or `\mathbb{1}`)
  - `\ba`..`\bz`, `\bA`..`\bZ`, `\b0`, `\bzero` $\to$ `\mathbf{a}`..`\mathbf{z}`, `\mathbf{A}`..`\mathbf{Z}`, `\mathbf{0}`
  - `\bhat{x}`, `\bbar{x}`, `\btilde{x}` $\to$ `\mathbf{\hat{x}}`, `\mathbf{\bar{x}}`, `\mathbf{\tilde{x}}`
  - `\rank`, `\tr`, `\diag`, `\range`, `\nullspace`, `\nullity`, `\cov`, `\Var`, `\Span`, `\sgn` $\to$ `\operatorname{rank}`, `\operatorname{Tr}`, `\mathsf{diag}`, `\operatorname{range}`, `\mathsf{null}`, `\mathsf{nullity}`, `\mathsf{cov}`, `\mathsf{Var}`, `\mathsf{span}`, `\mathsf{sgn}`
  - If referring to the literal macro name in prose, wrap it in backticks (e.g. `` `\M_{np}` ``) rather than `$...$`.

## Beamer slides
- **Prefer more, less-crowded slides over fewer, crowded slides**: When creating or editing Beamer slides (`.Rnw` or `.tex`), split content across multiple frames rather than packing too much onto a single slide.
- **No text overfill**: Always check compiled slides (and the `.log` file for `Overfull \vbox` and `Overfull \hbox` warnings) to verify that no text, equation, table, code chunk or figure overflows the frame vertically or horizontally. If a frame is crowded or overfull, split it into two or more frames.
