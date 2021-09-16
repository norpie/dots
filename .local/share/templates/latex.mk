all: compile clean

open: compile clean
	zathura document.pdf

compile:
	pdflatex document.tex
	pdflatex document.tex

clean:
	rm -f document.aux document.dvi document.fls  document.log document.bbl document.blg document.out document.toc document.fdb_latexmk
