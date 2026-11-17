---
trigger: glob
description: "Rules for organising, writing and running R and Julia code"
globs: "*.R, *.Rnw, *.Rmd, *.qmd, *.jl"
---

# Code rules (R and Julia)

- **Directory structure**: Store scripts in `CODE/`, generated figures in `FIGS/`, external input data in `DATA/` and generated outputs in `OUTPUT/`.
- **Hyphenated file names**: Use hyphens (`-`), never underscores (`_`), in all file names, including scripts, figures and saved data files.
- **Shared definitions**: Place reusable functions in `functions-and-definitions.jl` and `functions-and-definitions.R`. Do not define functions inside main scripts unless they are brief and strictly local to that script.
- **Centralised parameters**: Never hardcode base parameters in individual scripts. Load default parameter sets from `functions-and-definitions.jl` (e.g., via `get_base_p()`) or `functions-and-definitions.R` and define only local overrides in the script.
- **Simulations in Julia**: Run heavy numerical simulations in parallel in Julia (`run-*.jl`) and save results as CSV files in `OUTPUT/`. Allocate workers via `setup_workers(; large_ratio=3/7, min_free_core=2)` from `functions-and-definitions.jl` rather than hardcoding `addprocs` in individual scripts.
- **Plotting in R**: Generate figures in R (`plot-*.R`) using `ggplot2` and the shared theme in `functions-and-definitions.R`. Save every plot in both `.pdf` and `.png` formats in `FIGS/`. Honour `USE_PLOT_TITLE` (`FALSE` by default): when `FALSE`, apply `theme(plot.title = element_blank())` so PDFs embed into LaTeX without duplicate titles. Use sentence case for all plot titles, axis labels and legends.
- **Comments**: Comment the logic and purpose of non-obvious code blocks. Do not comment self-explanatory lines, number code sections or include conversational remarks (e.g., "as requested" or "back to the base case").
- **Missing packages**: If a required R or Julia package is missing when running code, install it directly (system-wide for Julia, not via a local `Project.toml`) rather than rewriting code to work around it. Report back if installation fails.
