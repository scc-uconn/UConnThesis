RSCRIPT ?= Rscript
SOURCES := $(wildcard *.Rnw)
OUTPUTS := $(SOURCES:.Rnw=.tex)

.PHONY: all rebuild clean
all: $(OUTPUTS) knitr-preamble.tex

%.tex: %.Rnw build.R Makefile
	$(RSCRIPT) --vanilla build.R "$<" "$@"

knitr-preamble.tex: build.R Makefile
	$(RSCRIPT) --vanilla build.R --preamble

# Force execution of every Rnw file, including its generated figures.
rebuild:
	$(MAKE) -B all

# Remove generated tex and figures; preserve all Rnw sources and build scripts.
clean:
	rm -f $(OUTPUTS) knitr-preamble.tex
	rm -rf figures
