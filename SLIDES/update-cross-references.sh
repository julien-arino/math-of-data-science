#!/bin/bash

# Script to update Rnw files with simple cross-reference setup
# This replaces the complex setupcrossref calls with simple setup commands

echo "Updating Rnw files with simplified cross-reference setup..."

# Update each file to use the appropriate setup command
files=(
    "L01-course-organisation-R-setup:setupL01"
    "L02-what-is-data-science-why-math:setupL02"
    "L03-math-preliminaries-1:setupL03"
    "L04-math-preliminaries-2:setupL04"
    "L05-matrix-methods-least-squares-1:setupL05"
    "L06-matrix-methods-least-squares-2:setupL06"
    "L07-matrix-methods-QR-1:setupL07"
    "L08-matrix-methods-QR-2-SVD-1:setupL08"
    "L09-matrix-methods-SVD-2:setupL09"
    "L11-matrix-methods-PCA-1:setupL11"
    "L12-matrix-methods-PCA-2:setupL12"
    "L13-matrix-methods-SVM-1:setupL13"
    "L14-matrix-methods-SVM-2:setupL14"
)

for entry in "${files[@]}"; do
    filename="${entry%:*}.Rnw"
    setupcmd="${entry#*:}"
    
    if [[ -f "$filename" ]]; then
        echo "Processing $filename with $setupcmd..."
        
        # Remove any existing setupcrossref lines
        sed -i '/setupcrossref/d' "$filename"
        
        # Add the simple setup command after \begin{document}
        if grep -q "\\\\begin{document}" "$filename"; then
            sed -i "/\\\\begin{document}/a\\
\\
% Set up cross-references and counter persistence\\
\\\\$setupcmd" "$filename"
            echo "  - Added $setupcmd"
        fi
        
        # Remove existing savecounters and add simple version before \end{document}
        sed -i '/savecounters/d' "$filename"
        if grep -q "\\\\end{document}" "$filename"; then
            sed -i "/\\\\end{document}/i\\
\\
% Save theorem count for next file\\
\\\\savetheoremcount{$filename}" "$filename"
            echo "  - Added theorem count saving"
        fi
    else
        echo "File $filename not found, skipping"
    fi
done

echo ""
echo "Update complete!"
echo ""
echo "Usage:"
echo "- Cross-references: Use \\zref{label} to reference labels from other files"
echo "- Page references: Use \\zpageref{label} for page numbers"
echo "- Theorem numbering continues automatically across files"
echo ""
echo "Examples:"
echo "- Reference QR theorem from L08: \\zref{th:QR_factorisation}"
echo "- Reference SVD theorem from L08: \\zref{th:SVD}"