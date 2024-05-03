compile:
	mkdir ".cache" -p
	pdflatex -jobname=output -halt-on-error -output-directory=.cache document.tex
	pdflatex -jobname=output -halt-on-error -output-directory=.cache document.tex
	cp .cache/output.pdf .

open:
	zathura output.pdf

clean:
	rm -f document.aux document.dvi document.fls  document.log document.bbl document.blg document.out document.toc document.fdb_latexmk
