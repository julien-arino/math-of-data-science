# Cross-Reference and Counter Persistence System for Beamer Slides

This document explains how to set up cross-referencing between your Rnw/LaTeX slide files and how to maintain theorem numbering across multiple files.

## Manual Setup Instructions

### 1. Basic Cross-Referencing Setup

Add this to each Rnw file after `\begin{document}`:

```latex
% Cross-reference setup - add files you want to reference
\zexternaldocument{L01-course-organisation-R-setup}
\zexternaldocument{L02-what-is-data-science-why-math}
% Add more as needed...
```

### 2. Theorem Counter Continuation

To continue theorem numbering from previous files:

```latex
% After \begin{document}, set the theorem counter
\setcounter{theorem}{X}  % Where X is the last theorem number from previous file
```

### 3. Saving Counter State

Add this before `\end{document}` in each file:

```latex
% Save the current theorem count for the next file
% Current theorem count: X (update this comment when you add/remove theorems)
```

## Recommended File-by-File Setup

### L01-course-organisation-R-setup.Rnw
```latex
\begin{document}
% No cross-references needed (first file)
% No counter setup needed (first file)

% ... your content ...

% Save state: 0 theorems in this file
\end{document}
```

### L02-what-is-data-science-why-math.Rnw
```latex
\begin{document}
% Cross-references
\zexternaldocument{L01-course-organisation-R-setup}

% Continue theorem numbering from L01 (which had 0 theorems)
\setcounter{theorem}{0}

% ... your content ...

% Save state: X theorems total after this file
\end{document}
```

### L03-math-preliminaries-1.Rnw
```latex
\begin{document}
% Cross-references
\zexternaldocument{L01-course-organisation-R-setup}
\zexternaldocument{L02-what-is-data-science-why-math}

% Continue theorem numbering from L02
\setcounter{theorem}{X}  % Replace X with actual count from L02

% ... your content ...

% Save state: Y theorems total after this file
\end{document}
```

### L04-math-preliminaries-2.Rnw
```latex
\begin{document}
% Cross-references (include all previous files you might reference)
\zexternaldocument{L01-course-organisation-R-setup}
\zexternaldocument{L02-what-is-data-science-why-math}
\zexternaldocument{L03-math-preliminaries-1}

% Continue theorem numbering from L03
\setcounter{theorem}{Y}  % Replace Y with actual count from L03

% ... your content ...

% Save state: Z theorems total after this file
\end{document}
```

## Usage Examples

### Cross-Referencing Labels

```latex
% To reference a theorem from L08 in L09:
As we proved in Theorem~\zref{th:QR_factorisation}, the QR factorization...

% To reference an equation from L04 in L05:
Using equation~\zref{eq:eigenvalue_equation} from the previous lecture...

% For page references:
See page~\zpageref{th:SVD} for the SVD theorem.
```

### Known Labels Available for Cross-Reference

From **L08-matrix-methods-QR-2-SVD-1**:
- `th:QR_factorisation` - QR Factorization Theorem
- `th:LSQ_with_QR` - Least Squares with QR Factorization
- `th:SVD` - Singular Value Decomposition Theorem
- `th:SVD_outer_product_form` - Outer Product Form of SVD
- `th:eigenvectors_of_symmetric_are_orthogonal` - Orthogonal Eigenvectors Theorem
- `eq:outer-product-form-SVD` - Outer Product Form Equation

## Compilation Notes

1. **Compile Order**: You must compile files in order (L01, L02, L03, ...) for cross-references to work properly
2. **Multiple Passes**: Run pdflatex 2-3 times on each file to resolve all cross-references
3. **Clean Compilation**: If you get "undefined reference" errors, delete .aux files and recompile from scratch

## Automation Script

To compile all files in the correct order with cross-references:

```bash
#!/bin/bash
for f in L??-*.Rnw; do
    echo "Processing $f..."
    Rscript -e "library(knitr); knit('$f')"
done

for f in L??-*.tex; do
    echo "Compiling $f (pass 1)..."
    pdflatex -interaction=nonstopmode "$f" > /dev/null
    echo "Compiling $f (pass 2)..."
    pdflatex -interaction=nonstopmode "$f" > /dev/null
    echo "Compiling $f (pass 3)..."
    pdflatex -interaction=nonstopmode "$f" > /dev/null
done
```

## Tips

1. **Label Naming**: Use descriptive prefixes like `th:`, `eq:`, `fig:`, `def:` for different types of references
2. **Comments**: Keep comments in your files noting the current theorem count for easy reference
3. **Incremental Setup**: Add cross-references only as needed rather than including all files everywhere
4. **Testing**: Test cross-references by compiling a simple example first

## Example Implementation

Here's a minimal working example for L09 referencing L08:

**L09-matrix-methods-SVD-2.Rnw:**
```latex
\begin{document}

% Set up cross-references to previous files
\zexternaldocument{L08-matrix-methods-QR-2-SVD-1}

% Continue theorem numbering (L08 ended with theorem 6)
\setcounter{theorem}{6}

% Your content with cross-references
\begin{frame}{Building on Previous Results}
  Recall from Theorem~\zref{th:SVD} that every matrix has a singular value decomposition.
  
  Using the outer product form from equation~\zref{eq:outer-product-form-SVD}, we can...
\end{frame}

% More content...

% This file ends with theorem 8, so next file should start with \setcounter{theorem}{8}

\end{document}
```