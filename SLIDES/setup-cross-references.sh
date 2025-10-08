#!/bin/bash

# Script to automatically add cross-reference setup to Rnw files
# This script adds the necessary \setupcrossref commands to each Rnw file

# Array of lecture files in order
lectures=(
    "L01-course-organisation-R-setup"
    "L02-what-is-data-science-why-math"
    "L03-math-preliminaries-1"
    "L04-math-preliminaries-2"
    "L05-matrix-methods-least-squares-1"
    "L06-matrix-methods-least-squares-2"
    "L07-matrix-methods-QR-1"
    "L08-matrix-methods-QR-2-SVD-1"
    "L09-matrix-methods-SVD-2"
    "L11-matrix-methods-PCA-1"
    "L12-matrix-methods-PCA-2"
    "L13-matrix-methods-SVM-1"
    "L14-matrix-methods-SVM-2"
)

echo "Setting up cross-references for lecture files..."

for i in "${!lectures[@]}"; do
    file="${lectures[$i]}.Rnw"
    
    if [[ -f "$file" ]]; then
        echo "Processing $file..."
        
        # Check if already has setupcrossref
        if grep -q "setupcrossref" "$file"; then
            echo "  - Already has cross-reference setup, skipping"
            continue
        fi
        
        # Find the line after \begin{document}
        if grep -q "\\\\begin{document}" "$file"; then
            # Create the cross-reference setup command
            if [[ $i -eq 0 ]]; then
                # First file - no previous references
                crossref_cmd="% Set up cross-references and counter persistence\n\\\\setupcrossref{}{}"
            elif [[ $i -eq 1 ]]; then
                # Second file - reference first file
                prev_file="${lectures[$((i-1))]}"
                crossref_cmd="% Set up cross-references and counter persistence\n\\\\setupcrossref{$prev_file}{$prev_file}"
            else
                # Later files - reference all previous files
                prev_files=""
                for j in $(seq 0 $((i-1))); do
                    if [[ $j -eq 0 ]]; then
                        prev_files="${lectures[$j]}"
                    else
                        prev_files="$prev_files,${lectures[$j]}"
                    fi
                done
                prev_file="${lectures[$((i-1))]}"
                crossref_cmd="% Set up cross-references and counter persistence\n\\\\setupcrossref{$prev_files}{$prev_file}"
            fi
            
            # Insert after \begin{document}
            sed -i "/\\\\begin{document}/a\\
\\
$crossref_cmd" "$file"
            
            echo "  - Added cross-reference setup"
        else
            echo "  - No \\begin{document} found, skipping"
        fi
        
        # Add counter saving at the end (before \end{document})
        if grep -q "\\\\end{document}" "$file"; then
            if ! grep -q "savecounters" "$file"; then
                sed -i "/\\\\end{document}/i\\
\\
% Save counters for next file\\
\\\\savecounters{${lectures[$i]}}" "$file"
                echo "  - Added counter saving"
            fi
        fi
    else
        echo "File $file not found, skipping"
    fi
done

echo "Cross-reference setup complete!"
echo ""
echo "Usage in your Rnw files:"
echo "- Use \\zref{label} instead of \\ref{label} for cross-file references"
echo "- Use \\zpageref{label} for page references"
echo "- Theorem numbering will continue across files automatically"
echo ""
echo "Example: To reference theorem th:QR_factorisation from L08 in later files:"
echo "  As we saw in Theorem~\\zref{th:QR_factorisation}..."