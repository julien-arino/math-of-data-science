###########################
#### 
#### COMMON-FUNCTIONS.R
####
###########################
#
# This script contains common code used in all lectures of the course.
# It also has all the required libraries across all lectures.
# It is sourced at the beginning of each lecture script.
# 

###
### FUNCTIONS
###

# Convert all the chunks in a file to R code with all TeX stripped out.
# This file is "self-aware", so should be able to infer the name of the file 
# from which is is run.
rmd_chunks_to_r_temp <- function(file = NULL) {
  # Try to infer file if not provided
  if (is.null(file)) {
    # Try knitr context
    file <- tryCatch(knitr::current_input(), error = function(e) NULL)
    # Try commandArgs context
    if (is.null(file)) {
      args <- commandArgs(trailingOnly = FALSE)
      file <- sub("--file=", "", args[grep("--file=", args)])
      if (length(file) == 0) file <- NULL
    }
    # If still NULL, error
    if (is.null(file) || file == "") stop("Could not determine input file. Please provide 'file' argument.")
  }
  # From https://stackoverflow.com/questions/36868287/purl-within-knit-duplicate-label-error
  callr::r(function(file){
    out_dir <- "../CODE"
    if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
    out_file = sprintf("%s/%s", out_dir, gsub(".Rnw", ".R", basename(file)))
    knitr::purl(file, output = out_file, documentation = 1)
  }, args = list(file))
}

###
### CODE
###

# Load required libraries. This is indiscriminate, so it will load all libraries
required_packages = c("adaptivetau",
                      "bmp",
                      "Cairo",
                      "deSolve",
                      "dplyr",
                      "DTMCPack",
                      "e1071",
                      "FactoMineR",
                      "future",
                      "future.apply",
                      "GillespieSSA2",
                      "ggbiplot",
                      "ggplot2",
                      "ggraph",
                      "igraph",
                      "JuliaCall",
                      "knitr",
                      "latex2exp",
                      "lattice",
                      "magick",
                      "markovchain",
                      "Matrix",
                      "openxlsx",
                      "readr",
                      "pixmap",
                      "pracma", 
                      "scales",
                      "tidyr",
                      "viridis",
                      "wbstats")

for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, dependencies = TRUE)
    require(p, character.only = TRUE)
  }
}

# Are we plotting for a dark background?
plot_blackBG = FALSE
if (plot_blackBG) {
  bg_colour = "black"
  fg_colour = "white"
  input_setup = "\\input{slides-setup-blackBG.tex}"
  fill_colour = "lightblue"
} else {
  bg_colour = "white"
  fg_colour = "black"
  input_setup = "\\input{slides-setup-whiteBG.tex}"
  fill_colour = "lightblue"
}

###
### KNITR OPTIONS
###
if (!exists("lecture_number")) {
  lecture_number = "01"
}

opts_chunk$set(echo = TRUE, 
               warning = FALSE, 
               message = FALSE, 
               dev = c("pdf", "png"),
               fig.width = 6, 
               fig.height = 4, 
               fig.path = sprintf("FIGS/L%s-", 
                                  lecture_number),
               fig.keep = "high",
               fig.show = "hide",
               fig.crop = TRUE)
# knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)
options(knitr.table.format = "latex")
# Date for front title page (if needed)
yyyy = strsplit(as.character(Sys.Date()), "-")[[1]][1]
