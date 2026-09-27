FILE ?= thesis
LATEXMK ?= latexmk

.PHONY: all clean distclean
# Start a clean rebuild so deleted inputs cannot be masked by an old PDF.
all:
	$(LATEXMK) -gg -bibtex -pdf -interaction=nonstopmode -halt-on-error -file-line-error $(FILE).tex

# Remove auxiliary files; preserve the PDF.
clean:
	$(LATEXMK) -c $(FILE).tex

# Remove auxiliary files and the PDF.
distclean:
	$(LATEXMK) -C $(FILE).tex
