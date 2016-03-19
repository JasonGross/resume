.PHONY: all biblatex

all: Resume.pdf

# "-e '" + "' -e '".join(['s/month = {%s},/month = {%d},/g' % (datetime.date(2015, i, 1).strftime('%B'), i) for i in range(1,13)]) + "'"
jason-gross.bib: publications/jason-gross.bib
	sed -e 's/month\s*=\s*{January},/month = {1},/g' -e 's/month\s*=\s*{February},/month = {2},/g' -e 's/month\s*=\s*{March},/month = {3},/g' -e 's/month\s*=\s*{April},/month = {4},/g' -e 's/month\s*=\s*{May},/month = {5},/g' -e 's/month\s*=\s*{June},/month = {6},/g' -e 's/month\s*=\s*{July},/month = {7},/g' -e 's/month\s*=\s*{August},/month = {8},/g' -e 's/month\s*=\s*{September},/month = {9},/g' -e 's/month\s*=\s*{October},/month = {10},/g' -e 's/month\s*=\s*{November},/month = {11},/g' -e 's/month\s*=\s*{December},/month = {12},/g' -e s'/•/\$$\\bullet\$$/g' $< > $@

Resume.pdf: Resume.tex etextools.sty etoolbox.sty res.cls jason-gross.bib
	pdflatex --enable-write18 -synctex=1 Resume.tex
	biber Resume
	pdflatex --enable-write18 -synctex=1 -interaction=nonstopmode Resume.tex 2>\dev\null >\dev\null
	pdflatex --enable-write18 -synctex=1 Resume.tex

clean:
	rm -f *.pdf Resume-*.tex *.log *.out *.mtx *.aux *.bbl *.blg *.run.xml *.bcf *-blx.bib jason-gross.bib

.PHONY: all clean

biblatex: biblatex.sty

FIND_ARGS = -name "*.sty" -o -name "*.tex" -o -name "*.map" -o -name "*.afm" -o -name "*.enc" -o -name "*.mf" -o -name "*.pfm" -o -name "*.pro" -o -name "*.tfm" -o -name "*.pfb" -o -name "*.fd" -o -name "*.def" -o -name "*.csf" -o -name "*.bst" -o -name "*.cfg" -o -name "*.cbx" -o -name "*.bbx" -o -name "*.lbx" -o -name "*.dtx" -o -name "*.ins" -o -name "*.600pk" -o -name "*.cmap" -o -name "*.drv"
biblatex.sty: biblatex/latex/biblatex.sty
	find biblatex $(FIND_ARGS) | xargs cp -t ./

biblatex/latex/biblatex.sty: biblatex.zip
	unzip biblatex.zip

biblatex.zip:
	wget -N "http://mirrors.ctan.org/macros/latex/contrib/biblatex.zip"
