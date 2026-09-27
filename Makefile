FILE ?= thesis
LATEXMK ?= latexmk

.PHONY: all rnw r-code clean distclean
# Start a clean rebuild so deleted inputs cannot be masked by an old PDF.
all: rnw
	$(LATEXMK) -gg -bibtex -pdf -interaction=nonstopmode -halt-on-error -file-line-error $(FILE).tex

# Discover all Rnw files in the subdirectory and rebuild changed sources.
rnw:
	$(MAKE) -C Rnw

# Force execution of every R chunk and regeneration of its figures.
r-code:
	$(MAKE) -C Rnw rebuild

# Remove auxiliary files; preserve the PDF.
clean:
	$(LATEXMK) -c $(FILE).tex

# Remove LaTeX output and generated R tex, setup, and figures.
distclean:
	$(LATEXMK) -C $(FILE).tex
	$(MAKE) -C Rnw clean
