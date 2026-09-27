if (!requireNamespace("knitr", quietly = TRUE)) {
  stop("Install knitr with install.packages('knitr') before building R chunks.")
}

args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--preamble")) {
  knitr::render_latex()
  writeLines(knitr::opts_knit$get("header"), "knitr-preamble.tex")
} else {
  if (length(args) != 2L || !file.exists(args[1])) {
    stop("Usage: Rscript --vanilla build.R input.Rnw output.tex")
  }
  stem <- tools::file_path_sans_ext(basename(args[1]))
  knitr::render_latex()
  knitr::opts_chunk$set(
    error = FALSE, cache = FALSE,
    fig.path = paste0("figures/", stem, "/")
  )
  knitr::knit(args[1], output = args[2], quiet = TRUE)
}
