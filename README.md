# UConn thesis template

A community-maintained LaTeX dissertation template for the University of
Connecticut, using the `report` class and `uconnthesis.sty` package.

## Build

Install a TeX distribution (TeX Live, MacTeX, or MiKTeX) with `latexmk`,
pdfLaTeX, BibTeX, and the packages loaded by `preamble.tex`. Then run:

```sh
make
```

The result is `thesis.pdf`. Each build starts a clean rebuild so that an
existing PDF cannot hide deleted source or bibliography files.

On Windows or without Make, run this from the source directory:

```sh
latexmk -gg -bibtex -pdf -interaction=nonstopmode -halt-on-error -file-line-error thesis.tex
```

MiKTeX users may need to install Perl for `latexmk`. Make is optional on Windows;
the command above works without a Unix shell. Windows execution has not yet
been tested directly.

On Overleaf, upload the source files, select `thesis.tex` as the main document,
and use pdfLaTeX. `make clean` removes auxiliary files while preserving the PDF;
`make distclean` removes the PDF too.

## Customize

Edit the title, full name, previous degrees, degree, committee, and graduation
year in `thesis.tex`. The explicit year keeps dates consistent across front
matter and future builds. Comment out `\copyrighttrue` to omit the copyright
page. Add optional committee members using the commented commands.
For two co-major advisors, comment out `\myMajorAdvisor` and uncomment both
`\myCoAdvisorA` and `\myCoAdvisorB`. Each appears as a Co-Major Advisor on the
approval page, with a separate signature line when signature lines are enabled.
The example enables `\signaturelinestrue` for a printed committee copy.
Comment it out for an approval page listing names, following the Registrar sample.

Replace `abs.tex`, `dedication.tex`, and `ack.tex` with your own text. The
dissertation abstract is required, unnumbered, and limited to 350 words.
Use multiple paragraphs when they improve readability; the limit applies to
the whole abstract. In this style, an abstract within the limit may span two pages.
The historical teaching examples are retained and corrected where necessary. `chap3.tex` adds
worked examples of proofs, lists, equations, tables, a drawn figure, pseudocode,
R source code, recorded output, and varied reference types. The listings read
`code/mean.R` and `code/mean-output.txt`; compilation does not execute R.
To refresh the output, run `Rscript --vanilla code/mean.R` and record its
printed output in `code/mean-output.txt`.
Edit `chap1.tex`, `chap2.tex`, `chap3.tex`, and `appendix.tex`; add further
chapters with
`\include{filename}`. Keep packages and shared commands in `preamble.tex` and
references in `thesis.bib`. Bibliography examples cover journal articles, books,
book chapters, edited volumes, technical reports, conference papers, arXiv
preprints, newsletters, manuals, websites, wiki pages, and dissertations.
References use the `apalike` bibliography style with `natbib` citations.
Keep only cited entries in `thesis.bib`, sorted by key. Use keys such as
`adler1965topological`: surname, year, and first title word. Use `nd` for an
undated work and `a`/`b` to distinguish otherwise identical keys. Write field
values directly rather than maintaining `@String` abbreviation definitions.
Classic BibTeX uses `@misc` for online sources. Since `apalike` ignores the
`url` field, the examples also put links in `note` using `\url{...}`.
Include access dates for changing web content
and a permanent revision link for wiki citations in your final dissertation.
The examples demonstrate citations, equations,
theorems, cross-references, a table, and a self-contained vector figure.

To review selected chapters, uncomment one `\includeonly` example in
`thesis.tex`: `\includeonly{chap1}` builds Chapter 1, while
`\includeonly{chap1,chap3}` builds Chapters 1 and 3. Other files loaded with
`\include`, including the appendix, are skipped. Keep the `\include` commands
in place so you can return to a full build without editing the chapter list.
Front matter and files loaded with `\input` are still included, and the
bibliography is generated from the draft's citations.

The result is a partial draft for reviewing those chapters. Comment out
`\includeonly` before building the complete dissertation. Because this
template starts each build clean, numbering and references to omitted
chapters may differ from a full build or remain unresolved. Use a full build
to check final numbering and cross-references.

Comment out `\figurespagetrue` or `\tablespagetrue` if those lists are
unnecessary.

## Formatting status

This starter currently follows the dissertation front-matter sequence. Changing
the degree text alone does not establish support for a master's thesis: its
optional abstract belongs after the table of contents. Consult the official
[dissertation requirements](https://registrar.uconn.edu/graduation/doctoral-degrees/)
and [master's thesis requirements](https://registrar.uconn.edu/graduation/masters-degrees/),
including their sample documents and any department-specific requirements.

The legacy package has not been certified against all current specifications.
Layout has been updated against the Registrar specifications and July 2026
Times New Roman dissertation sample: at least one-inch margins, unnumbered abstract,
Roman preliminary pages, Arabic body pages, and an advisory committee page
with optional signature lines.
Its pdfLaTeX output uses Type 1 fonts and is not a tagged, accessible PDF.
UConn announces WCAG 2.1 accessibility requirements effective Spring 2027 and
specifies embedded TrueType fonts. Accessibility and font modernization remain
future work; a successful build does not verify submission compliance.
The latest layout and source audit is recorded in [REVIEW.md](REVIEW.md).

## Provenance and reuse

Imported from the UConn Thesis archive linked on
[Jun Yan's Miscellaneous page](https://statcomp.org/misc.html). That page credits
Marcos, Xiaojing, and Greg, with the most recent historical update dated
June 8, 2017. The style file credits Marcos O. Prates, March 2011.
The original introduction is retained in `README` for attribution and history;
its build and submission instructions are superseded by this document.

Marcos's version incorporates material from
[Marc Corluy's thesis class](https://math.uconn.edu/wp-content/uploads/sites/3655/2019/01/CorluyClass.zip).
The archive's class header identifies Corluy and Summer 2007; the department's
[template page](https://math.uconn.edu/degree-programs/graduate/thesis-formatting/)
labels the download as 2000. Comparison with the imported Statistics template
shows matching degree/advisor commands, distinctive copyright and approval-page
code, and nearly identical historical `definitions.tex` content. Corluy's header
also credits Marijan Kostrun's earlier class (2001), Keith Gillow's
`ociamthesis.cls` (1997, 2006), and *The LaTeX Companion*, second edition, by
Frank Mittelbach, Michel Goossens et al. (2004).

Gregory Vaughn contributed improvements in May 2017. Jun Yan revised the
template in September 2026 with Codex assistance. The style-file header records
this history and summarizes the current revisions.

The imported archive did not include a license. No license is assigned to the
inherited material until its reuse rights are clarified.

## Contributing

Preserve the teaching examples and keep new examples self-contained. Explain formatting changes with
references to official requirements. Run a clean build, inspect the PDF, and
check for unresolved references or citations before proposing a change.
GitHub Actions builds the sample on pushes and pull requests and retains the
PDF and build logs as artifacts.
