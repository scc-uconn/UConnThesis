FILE = thesis

TEX = pdflatex
BIBTEX = bibtex

.PHONY: clean

# all: $(FILE).pdf


$(FILE).pdf: $(FILE).tex $(FILE).bib
	$(TEX) $(FILE)
	$(BIBTEX) $(FILE)
	while grep -e 'Rerun to get' -e 'run LaTeX again' *.log ; do $(TEX) $(FILE) ; done


clean:
	rm *.aux *.blg *.out *.bbl *.log *.backup *.lof *.lot *.toc $(FILE).pdf
