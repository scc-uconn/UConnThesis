if (!requireNamespace("knitr", quietly = TRUE)) {
  stop("Install knitr with install.packages('knitr') before building R chunks.")
}

build <- function(input, output) {
  stem <- tools::file_path_sans_ext(basename(input))
  deps <- paste0(tools::file_path_sans_ext(output), ".d")
  temporary <- tempfile(pattern = ".knit-", tmpdir = ".", fileext = ".tex")
  complete <- FALSE
  on.exit({
    unlink(temporary)
    # A failed attempt must not leave a partial or stale output marked current.
    if (!complete) unlink(c(output, deps))
  })

  knitr::render_latex()
  knitr::opts_chunk$set(
    error = FALSE, cache = FALSE,
    fig.path = paste0("figures/", stem, "/")
  )
  figures <- character()
  default_plot <- knitr::knit_hooks$get("plot")
  knitr::knit_hooks$set(plot = function(x, options) {
    figures <<- unique(c(figures, x))
    default_plot(x, options)
  })
  knitr::knit(input, output = temporary, quiet = TRUE)
  if (!all(file.exists(figures))) stop("A generated figure is missing.")

  # Like compiler dependency files, empty rules allow missing figures to
  # invalidate the tex target without causing a 'no rule to make target' error.
  rules <- c(paste(c(paste0(output, ":"), figures), collapse = " "),
             if (length(figures)) paste0(figures, ":"))
  writeLines(rules, deps)
  if (!file.copy(temporary, output, overwrite = TRUE)) {
    stop("Could not save generated tex: ", output)
  }
  complete <- TRUE
}

args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--preamble")) {
  knitr::render_latex()
  writeLines(knitr::opts_knit$get("header"), "knitr-preamble.tex")
} else {
  if (length(args) != 2L || !file.exists(args[1])) {
    stop("Usage: Rscript --vanilla build.R input.Rnw output.tex")
  }
  build(args[1], args[2])
}
