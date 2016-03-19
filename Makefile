all: Resume.pdf

# "-e '" + "' -e '".join(['s/month = {%s},/month = {%d},/g' % (datetime.date(2015, i, 1).strftime('%B'), i) for i in range(1,13)]) + "'"
jason-gross.bib: publications/jason-gross.bib
	sed -e 's/month\s*=\s*{January},/month = {1},/g' -e 's/month\s*=\s*{February},/month = {2},/g' -e 's/month\s*=\s*{March},/month = {3},/g' -e 's/month\s*=\s*{April},/month = {4},/g' -e 's/month\s*=\s*{May},/month = {5},/g' -e 's/month\s*=\s*{June},/month = {6},/g' -e 's/month\s*=\s*{July},/month = {7},/g' -e 's/month\s*=\s*{August},/month = {8},/g' -e 's/month\s*=\s*{September},/month = {9},/g' -e 's/month\s*=\s*{October},/month = {10},/g' -e 's/month\s*=\s*{November},/month = {11},/g' -e 's/month\s*=\s*{December},/month = {12},/g' $< > $@

Resume.pdf: Resume.tex etextools.sty etoolbox.sty res.cls jason-gross.bib
	pdflatex --enable-write18 -synctex=1 Resume.tex
	bibtex Resume
	pdflatex --enable-write18 -synctex=1 Resume.tex
	pdflatex --enable-write18 -synctex=1 Resume.tex

clean:
	rm -f *.pdf Resume-*.tex *.log *.out *.mtx *.aux *.bbl *.blg *.run.xml *.bcf *-blx.bib jason-gross.bib

.PHONY: all clean
