all: Resume.pdf

# "-e '" + "' -e '".join(['s/month = {%s},/month = {%d},/g' % (datetime.date(2015, i, 1).strftime('%B'), i) for i in range(1,13)]) + "'"
jason-gross.bib: personal-website/jason-gross.bib
	sed -e 's/month = {January},/month = {1},/g' -e 's/month = {February},/month = {2},/g' -e 's/month = {March},/month = {3},/g' -e 's/month = {April},/month = {4},/g' -e 's/month = {May},/month = {5},/g' -e 's/month = {June},/month = {6},/g' -e 's/month = {July},/month = {7},/g' -e 's/month = {August},/month = {8},/g' -e 's/month = {September},/month = {9},/g' -e 's/month = {October},/month = {10},/g' -e 's/month = {November},/month = {11},/g' -e 's/month = {December},/month = {12},/g' $< > $@

Resume.pdf: Resume.tex etextools.sty etoolbox.sty res.cls plainyr-rev.bst jason-gross.bib
	pdflatex --enable-write18 Resume.tex

clean:
	rm -f *.pdf Resume-*.tex *.log *.out *.mtx *.aux *.bbl *.blg *.run.xml *.bcf *-blx.bib jason-gross.bib

.PHONY: all clean
