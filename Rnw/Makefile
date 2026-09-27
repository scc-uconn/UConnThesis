RSCRIPT ?= Rscript
SOURCES := $(wildcard *.Rnw)
OUTPUTS := $(SOURCES:.Rnw=.tex)
DEPS := $(SOURCES:.Rnw=.d)

.DELETE_ON_ERROR:
.PHONY: all rebuild clean
all: $(OUTPUTS) knitr-preamble.tex

%.tex: %.Rnw %.d build.R Makefile
	$(RSCRIPT) --vanilla build.R "$<" "$@"

# Each knit records its figure dependencies. Missing metadata forces a knit;
# empty figure rules in that metadata let deleted figures trigger rebuilding.
%.d: ;
-include $(DEPS)

knitr-preamble.tex: build.R Makefile
	$(RSCRIPT) --vanilla build.R --preamble

# Force execution of every Rnw file, including its generated figures.
rebuild:
	$(MAKE) -B all

# Remove generated tex and figures; preserve all Rnw sources and build scripts.
clean:
	rm -f $(OUTPUTS) $(DEPS) knitr-preamble.tex
	rm -rf figures
