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
    if (is.null(file) || file == "") {
      stop("Could not determine input file. Please provide 'file' argument.")
    }
  }
  # From https://stackoverflow.com/questions/36868287/purl-within-knit-duplicate-label-error
  callr::r(
    function(file) {
      out_dir <- "../CODE"
      if (!dir.exists(out_dir)) {
        dir.create(out_dir, recursive = TRUE)
      }
      out_file <- sprintf("%s/%s", out_dir, gsub(".Rnw", ".R", basename(file)))
      knitr::purl(file, output = out_file, documentation = 1)
    },
    args = list(file)
  )
}

###
### CODE
###

# Load required libraries. This is indiscriminate, so it will load all libraries
required_packages <- c(
  "adaptivetau",
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
  "wbstats"
)

for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, dependencies = TRUE)
    require(p, character.only = TRUE)
  }
}

# Are we plotting for a dark background?
plot_blackBG <- FALSE
if (plot_blackBG) {
  bg_colour <- "black"
  fg_colour <- "white"
  input_setup <- "\\input{slides-setup-blackBG.tex}"
  fill_colour <- "lightblue"
} else {
  bg_colour <- "white"
  fg_colour <- "black"
  input_setup <- "\\input{slides-setup-whiteBG.tex}"
  fill_colour <- "lightblue"
}

###
### KNITR OPTIONS
###
if (!exists("lecture_number")) {
  lecture_number <- "01"
}

if (grepl("^[a-zA-Z]", lecture_number)) {
  prefix <- sprintf("FIGS/%s-", lecture_number)
} else {
  prefix <- sprintf("FIGS/L%s-", lecture_number)
}

opts_chunk$set(
  echo = TRUE,
  warning = FALSE,
  message = FALSE,
  dev = c("pdf", "png"),
  fig.width = 6,
  fig.height = 4,
  fig.path = prefix,
  fig.keep = "high",
  fig.show = "hide",
  fig.crop = TRUE
)
knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)
options(knitr.table.format = "latex")
# Date for front title page (if needed)
yyyy <- strsplit(as.character(Sys.Date()), "-")[[1]][1]

###
### RANDOM BACKGROUNDS FOR \SSsection
###

draw_random_style <- function(file_out, width = 16, height = 9) {
  style <- sample(1:6, 1)

  if (style == 1) {
    # Polygons
    pdf(file_out, width = width, height = height)
    bg_cols <- c("#121212", "#1a252c", "#0f0f23", "#221319", "#001a1a")
    par(mar = c(0, 0, 0, 0), bg = sample(bg_cols, 1))
    plot(
      0,
      0,
      type = "n",
      xlim = c(0, 16),
      ylim = c(0, 9),
      axes = FALSE,
      xaxs = "i",
      yaxs = "i"
    )
    palettes <- list(
      rainbow(50),
      heat.colors(50),
      terrain.colors(50),
      topo.colors(50)
    )
    pal <- sample(palettes, 1)[[1]]
    n_polys <- sample(20:80, 1)
    for (j in 1:n_polys) {
      n_verts <- sample(3:6, 1)
      cx <- runif(1, -2, 18)
      cy <- runif(1, -2, 11)
      rx <- runif(n_verts, 1, 6)
      ry <- runif(n_verts, 1, 6)
      angles <- sort(runif(n_verts, 0, 2 * pi))
      px <- cx + rx * cos(angles)
      py <- cy + ry * sin(angles)
      polygon(
        px,
        py,
        col = paste0(sample(pal, 1), sample(sprintf("%02X", 25:125), 1)),
        border = NA
      )
    }
    dev.off()
  } else if (style == 2) {
    # Parametric Math Art with ggplot2
    library(ggplot2)
    a <- runif(1, 1, 15)
    b <- runif(1, 1, 15)
    c <- runif(1, 1, 15)
    d <- runif(1, 1, 15)
    t <- seq(0, 2 * pi, length.out = 15000)
    df <- data.frame(
      x = sin(a * t) * exp(-0.01 * t) + cos(b * t),
      y = sin(c * t) * exp(-0.01 * t) + cos(d * t)
    )
    bg_color <- sample(colors()[!grepl("white|gray|grey", colors())], 1)
    line_color <- sample(colors()[!grepl(bg_color, colors())], 1)

    p <- ggplot(df, aes(x, y)) +
      geom_path(alpha = 0.8, color = line_color, linewidth = 1.2) +
      coord_cartesian(
        xlim = c(-2.5, 2.5),
        ylim = c(-2.5 * (9 / 16), 2.5 * (9 / 16))
      ) +
      theme_void() +
      theme(panel.background = element_rect(fill = bg_color, color = NA))

    pdf(file_out, width = width, height = height)
    print(p)
    dev.off()
  } else if (style == 3) {
    # Random Bokeh
    pdf(file_out, width = width, height = height)
    par(mar = c(0, 0, 0, 0), bg = "#0a0a0a")
    plot(
      0,
      0,
      type = "n",
      xlim = c(0, 16),
      ylim = c(0, 9),
      axes = FALSE,
      xaxs = "i",
      yaxs = "i"
    )
    n_circles <- sample(50:150, 1)
    x <- runif(n_circles, -1, 17)
    y <- runif(n_circles, -1, 10)
    sizes <- runif(n_circles, 1, 15)
    theme_colors <- c("#FF3366", "#00E5FF", "#FFD500", "#B2FF59", "#B388FF")
    base_col <- sample(theme_colors, 1)
    for (i in 1:n_circles) {
      alpha <- sample(sprintf("%02X", 10:80), 1)
      points(
        x[i],
        y[i],
        pch = 16,
        cex = sizes[i],
        col = paste0(base_col, alpha)
      )
      if (runif(1) > 0.7) {
        points(
          x[i],
          y[i],
          pch = 16,
          cex = sizes[i] * 0.1,
          col = paste0("#FFFFFF", alpha)
        )
      }
    }
    dev.off()
  } else if (style == 4) {
    # Clifford Attractor
    pdf(file_out, width = width, height = height)
    bg_col <- sample(c("#0d1117", "#1a1a2e", "#100c14", "#0f172a"), 1)
    par(mar = c(0, 0, 0, 0), bg = bg_col)
    plot(
      0,
      0,
      type = "n",
      xlim = c(-2.5, 2.5),
      ylim = c(-2.5 * (9 / 16), 2.5 * (9 / 16)),
      axes = FALSE,
      xaxs = "i",
      yaxs = "i"
    )
    a <- runif(1, -2, 2)
    b <- runif(1, -2, 2)
    c <- runif(1, -2, 2)
    d <- runif(1, -2, 2)
    n <- 100000
    x <- numeric(n)
    y <- numeric(n)
    x[1] <- 0
    y[1] <- 0
    for (i in 1:(n - 1)) {
      x[i + 1] <- sin(a * y[i]) + c * cos(a * x[i])
      y[i + 1] <- sin(b * x[i]) + d * cos(b * y[i])
    }
    pt_col <- sample(c("#38bdf8", "#34d399", "#fbbf24", "#f472b6"), 1)
    points(x, y, pch = 20, cex = 0.1, col = paste0(pt_col, "08"))
    dev.off()
  } else if (style == 5) {
    # Flow Field
    pdf(file_out, width = width, height = height)
    bg_col <- sample(c("#f8fafc", "#f1f5f9", "#0f172a", "#1e293b"), 1)
    par(mar = c(0, 0, 0, 0), bg = bg_col)
    plot(
      0,
      0,
      type = "n",
      xlim = c(0, width),
      ylim = c(0, height),
      axes = FALSE,
      xaxs = "i",
      yaxs = "i"
    )
    np <- 1500
    px <- runif(np, 0, width)
    py <- runif(np, 0, height)
    steps <- 30
    step_size <- 0.25
    palettes <- list(rainbow(50), heat.colors(50), topo.colors(50))
    pt_col <- sample(palettes, 1)[[1]]

    m1 <- runif(1, 0.1, 0.8)
    m2 <- runif(1, 0.1, 0.8)

    for (s in 1:steps) {
      angles <- sin(px * m1) * cos(py * m2) * 2 * pi
      px_new <- px + cos(angles) * step_size
      py_new <- py + sin(angles) * step_size

      cols <- paste0(sample(pt_col, np, replace = TRUE), "33")
      segments(px, py, px_new, py_new, col = cols, lwd = 1.5)
      px <- px_new
      py <- py_new
    }
    dev.off()
  } else if (style == 6) {
    # Truchet Tiles
    pdf(file_out, width = width, height = height)
    bg_col <- sample(c("#ffffff", "#121212", "#2d3748", "#1e1e2f"), 1)
    line_col <- ifelse(bg_col == "#ffffff", "#1a202c", "#e2e8f0")
    par(mar = c(0, 0, 0, 0), bg = bg_col)
    plot(
      0,
      0,
      type = "n",
      xlim = c(0, width),
      ylim = c(0, height),
      axes = FALSE,
      xaxs = "i",
      yaxs = "i"
    )

    step <- sample(c(0.5, 1, 1.5), 1)
    for (x in seq(0, width, by = step)) {
      for (y in seq(0, height, by = step)) {
        if (runif(1) > 0.5) {
          segments(x, y, x + step, y + step, col = line_col, lwd = 3)
        } else {
          segments(x + step, y, x, y + step, col = line_col, lwd = 3)
        }
      }
    }
    dev.off()
  }
}

generate_sssection_bgs <- function() {
  # Try to infer the current input file
  file <- tryCatch(knitr::current_input(), error = function(e) NULL)

  n_bgs <- 0
  if (!is.null(file) && file.exists(file)) {
    content <- readLines(file, warn = FALSE)
    n_bgs <- sum(grepl("\\\\SS(sub)*section\\{", content))
  }

  # If there are no \SSsection commands, don't do anything
  if (n_bgs == 0) {
    return(invisible(NULL))
  }

  # Add a buffer just in case LaTeX expands things more times than expected
  n_bgs <- n_bgs + 2

  if (!dir.exists("FIGS")) {
    dir.create("FIGS")
  }

  # To prevent latexmk infinite loops, only generate if the file was modified
  # latexmk loops because the PDFs get a new modification time during compilation
  mtime <- as.numeric(file.info(file)$mtime)
  seed_string <- paste0(basename(file), "_", mtime)

  seed_file <- "FIGS/.last_bg_seed"
  if (file.exists(seed_file)) {
    last_seed <- readLines(seed_file, warn = FALSE)[1]
    if (!is.na(last_seed) && last_seed == seed_string) {
      return(invisible(NULL)) # File hasn't changed since last run, skip generation
    }
  }

  # Save the new state
  writeLines(seed_string, seed_file)

  # Ensure randomness changes when file is saved, but is stable during compilation loops
  set.seed(mtime + 3)

  # Generate exactly n_bgs images
  for (i in 1:n_bgs) {
    draw_random_style(sprintf("FIGS/random_bg_%d.pdf", i))
  }
}

# Run generation
generate_sssection_bgs()

###
### RANDOM BACKGROUNDS FOR \SStitlepage AND \SSoutlinepage
###

generate_title_bg <- function() {
  file <- tryCatch(knitr::current_input(), error = function(e) NULL)
  if (is.null(file) || !file.exists(file)) {
    return(invisible(NULL))
  }
  content <- readLines(file, warn = FALSE)
  if (!any(grepl("\\\\SStitlepage", content))) {
    return(invisible(NULL))
  }

  mtime <- as.numeric(file.info(file)$mtime)
  seed_string <- paste0(basename(file), "_title_", mtime)
  seed_file <- "FIGS/.last_title_bg_seed"
  if (file.exists(seed_file)) {
    last_seed <- readLines(seed_file, warn = FALSE)[1]
    if (!is.na(last_seed) && last_seed == seed_string) return(invisible(NULL))
  }
  writeLines(seed_string, seed_file)

  if (!dir.exists("FIGS")) {
    dir.create("FIGS")
  }
  set.seed(mtime + 1)

  draw_random_style("FIGS/random_title_bg.pdf")
}

generate_outline_bg <- function() {
  file <- tryCatch(knitr::current_input(), error = function(e) NULL)
  if (is.null(file) || !file.exists(file)) {
    return(invisible(NULL))
  }
  content <- readLines(file, warn = FALSE)
  if (!any(grepl("\\\\SSoutlinepage", content))) {
    return(invisible(NULL))
  }

  mtime <- as.numeric(file.info(file)$mtime)
  seed_string <- paste0(basename(file), "_outline_", mtime)
  seed_file <- "FIGS/.last_outline_bg_seed"
  if (file.exists(seed_file)) {
    last_seed <- readLines(seed_file, warn = FALSE)[1]
    if (!is.na(last_seed) && last_seed == seed_string) return(invisible(NULL))
  }
  writeLines(seed_string, seed_file)

  if (!dir.exists("FIGS")) {
    dir.create("FIGS")
  }
  set.seed(mtime + 2)

  draw_random_style("FIGS/random_outline_bg.pdf")
}

generate_title_bg()
generate_outline_bg()
