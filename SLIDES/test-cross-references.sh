#!/bin/bash

# Test script to verify cross-referencing and counter persistence works
# This script compiles a couple of files and checks the cross-references

echo "Testing cross-reference and counter persistence system..."
echo "========================================================="

# Test files in order
test_files=("L04-math-preliminaries-2" "L08-matrix-methods-QR-2-SVD-1")

for file in "${test_files[@]}"; do
    echo "Testing $file.Rnw..."
    
    # Knit the Rnw file
    echo "  - Knitting Rnw to tex..."
    if Rscript -e "library(knitr); knit('$file.Rnw')" > /dev/null 2>&1; then
        echo "  - Knit successful"
    else
        echo "  - Knit failed!"
        continue
    fi
    
    # Compile the tex file (3 passes for cross-references)
    echo "  - Compiling tex to pdf (pass 1)..."
    pdflatex -interaction=nonstopmode "$file.tex" > /dev/null 2>&1
    echo "  - Pass 2..."
    pdflatex -interaction=nonstopmode "$file.tex" > /dev/null 2>&1
    echo "  - Pass 3..."
    pdflatex -interaction=nonstopmode "$file.tex" > /dev/null 2>&1
    
    if [[ -f "$file.pdf" ]]; then
        echo "  - PDF generated successfully"
        
        # Check for cross-reference warnings in log
        if grep -q "LaTeX Warning.*undefined" "$file.log" 2>/dev/null; then
            echo "  - WARNING: Some cross-references may be undefined"
        else
            echo "  - Cross-references appear to be working"
        fi
        
        # Check theorem counter in aux file
        if [[ -f "$file.aux" ]]; then
            theorem_count=$(grep "restoredtheorem" "$file.aux" 2>/dev/null | tail -1 | sed 's/.*{\([0-9]*\)}.*/\1/' 2>/dev/null || echo "0")
            echo "  - Final theorem count: $theorem_count"
        fi
    else
        echo "  - PDF generation failed!"
    fi
    
    echo ""
done

echo "Test complete!"
echo ""
echo "To use the cross-reference system:"
echo "1. Reference labels from other files with: \\zref{labelname}"
echo "2. Reference pages with: \\zpageref{labelname}"
echo "3. Theorem numbering continues automatically across files"
echo ""
echo "Example usage:"
echo "- In L09: 'As shown in Theorem~\\zref{th:QR_factorisation} from the previous lecture...'"
echo "- Labels from L08: th:QR_factorisation, th:LSQ_with_QR, th:SVD, etc."