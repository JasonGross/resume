all: Resume.pdf

Resume.pdf: Resume.tex etextools.sty etoolbox.sty res.cls
	pdflatex --enable-write18 Resume.tex

clean:
	rm *.pdf

.PHONY: all clean
