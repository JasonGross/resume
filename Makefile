V = 0

Q_0 := @
Q_1 :=
Q = $(Q_$(V))

VECHO_0 := @echo
VECHO_1 := @true
VECHO = $(VECHO_$(V))

QECHO_0 := @true
QECHO_1 := @echo
QECHO = $(QECHO_$(V))

.PHONY: all dependencies

WGET ?= wget

all: Resume.pdf

# "-e '" + "' -e '".join(['s/month = {%s},/month = {%d},/g' % (datetime.date(2015, i, 1).strftime('%B'), i) for i in range(1,13)]) + "'"
jason-gross.bib: publications/jason-gross.bib
	sed -e 's/month\s*=\s*{January},/month = {1},/g' -e 's/month\s*=\s*{February},/month = {2},/g' -e 's/month\s*=\s*{March},/month = {3},/g' -e 's/month\s*=\s*{April},/month = {4},/g' -e 's/month\s*=\s*{May},/month = {5},/g' -e 's/month\s*=\s*{June},/month = {6},/g' -e 's/month\s*=\s*{July},/month = {7},/g' -e 's/month\s*=\s*{August},/month = {8},/g' -e 's/month\s*=\s*{September},/month = {9},/g' -e 's/month\s*=\s*{October},/month = {10},/g' -e 's/month\s*=\s*{November},/month = {11},/g' -e 's/month\s*=\s*{December},/month = {12},/g' -e s'/•/\$$\\bullet\$$/g' $< > $@

Resume.pdf: Resume.tex res.cls jason-gross.bib
	pdflatex --enable-write18 -synctex=1 Resume.tex
	biber Resume
	pdflatex --enable-write18 -synctex=1 -interaction=nonstopmode Resume.tex 2>\dev\null >\dev\null
	pdflatex --enable-write18 -synctex=1 Resume.tex

clean:
	rm -f *.pdf Resume-*.tex *.log *.out *.mtx *.aux *.bbl *.blg *.run.xml *.bcf *-blx.bib jason-gross.bib

.PHONY: all clean

UNIS-LARGE = #$(patsubst %,uni-%.def,$(shell seq 0 762))
UNIS = #uni-global.def
INS_STY = #ifmtarg.sty
DTX_STY =
ALL_DTX_STY = $(DTX_STY)
DTX_LATEX_STY =
ALL_DTX_LATEX_STY = $(DTX_LATEX_STY) #stmaryrd.sty
DTX_INS_STY = #filecontents.sty polytable.sty xcolor.sty minted.sty ifplatform.sty
SIMPLE_TEX = #ifmtarg.tex
SIMPLE_DEPENDENCIES = etoolbox.sty etextools.sty #ucs.sty xifthen.sty lazylist.sty lineno.sty upquote.sty logreq.sty slashbox.sty
SIMPLE_DEFS = #logreq.def
GENERIC_STY = #xstring.sty
GENERIC_TEX = #xstring.tex
SIMPLE_CONTRIB_ZIPS = biblatex.zip #cmap.zip mmap.zip
CONTRIB_ZIPS = $(SIMPLE_CONTRIB_ZIPS)
SIMPLE_ZIPS = $(SIMPLE_CONTRIB_ZIPS) #tipa.zip
SIMPLE_DTX_ZIPS = #stmaryrd.zip
ZIPS = $(SIMPLE_ZIPS) $(SIMPLE_DTX_ZIPS)
OBERDIEK_DTX_STY = #accsupp.sty
PRE_DEPENDENCIES = $(INS_STY:.sty=.ins) $(ALL_DTX_STY:.sty=.dtx) $(ALL_DTX_LATEX_STY:.sty=.dtx) $(ZIPS) $(ZIPS:.zip=/) $(OBERDIEK_DTX_STY:.sty=.dtx) # boxchar.sty codelist.sty exaccent.sty extraipa.sty tipaman.sty tipaman.tex tipaman0.tex tipaman1.tex tipaman2.tex tipaman3.tex tipaman4.tex tipx.sty tone.sty vowel.sty vowel.tex
DEPENDENCIES = $(GENERIC_STY) $(GENERIC_TEX) $(DTX_INS_STY) $(INS_STY) $(ALL_DTX_STY) $(ALL_DTX_LATEX_STY) $(SIMPLE_DEPENDENCIES) $(SIMPLE_TEX) $(SIMPLE_DEFS) $(OBERDIEK_DTX_STY) $(UNIS) # utf8x.def ucsencs.def ifmtarg.sty uni-34.def uni-33.def uni-3.def uni-32.def uni-37.def uni-35.def uni-0.def uni-32.def uni-39.def tipa.sty biblatex.sty uni-29.def uni-37.def uni-2.def uni-3.def cmap.sty mmap.sty

FIND_ARGS = -name "*.sty" -o -name "*.tex" -o -name "*.map" -o -name "*.afm" -o -name "*.enc" -o -name "*.mf" -o -name "*.pfm" -o -name "*.pro" -o -name "*.tfm" -o -name "*.pfb" -o -name "*.fd" -o -name "*.def" -o -name "*.csf" -o -name "*.bst" -o -name "*.cfg" -o -name "*.cbx" -o -name "*.bbx" -o -name "*.lbx" -o -name "*.dtx" -o -name "*.ins" -o -name "*.600pk" -o -name "*.cmap" -o -name "*.drv"

$(SIMPLE_ZIPS:.zip=.sty) : %.sty : %.zip
	unzip $< && (find $(<:.zip=) $(FIND_ARGS) | xargs touch && find $(<:.zip=) $(FIND_ARGS) | xargs mv -t ./)

$(SIMPLE_DTX_ZIPS:.zip=.dtx) : %.dtx : %.zip
	unzip $< && (find $(<:.zip=) $(FIND_ARGS) | xargs touch && find $(<:.zip=) $(FIND_ARGS) | xargs mv -t ./)

$(OBERDIEK_DTX_STY:.sty=.dtx):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/oberdiek/$@"

tipa.zip:
	$(WGET) -N "http://mirrors.ctan.org/fonts/$(@:.zip=)/$@"

stmaryrd.zip:
	$(WGET) -N "http://mirrors.ctan.org/fonts/$@"

$(CONTRIB_ZIPS):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$@"

utf8x.def ucsencs.def:
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/ucs/$@"

$(GENERIC_STY):
	$(WGET) -N "http://mirrors.ctan.org/macros/generic/$(@:.sty=)/$@"

$(GENERIC_TEX):
	$(WGET) -N "http://mirrors.ctan.org/macros/generic/$(@:.tex=)/$@"

$(UNIS) $(UNIS-LARGE):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/ucs/data/$@"

ifmtarg.sty: ifmtarg.tex filecontents.sty

$(SIMPLE_TEX):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$(@:.tex=)/$@"

$(INS_STY:.sty=.ins) $(DTX_INS_STY:.sty=.ins):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$(@:.ins=)/$@"

$(INS_STY) : %.sty : %.ins
	latex $<

$(DTX_INS_STY) : %.sty : %.dtx

$(DTX_INS_STY) : %.sty : %.ins
	latex $<

$(DTX_STY:.sty=.dtx) $(DTX_INS_STY:.sty=.dtx):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$(@:.dtx=)/$@"

$(ALL_DTX_STY) $(OBERDIEK_DTX_STY) : %.sty : %.dtx
	tex $<

$(ALL_DTX_LATEX_STY) : %.sty : %.dtx
	latex $<

$(SIMPLE_DEPENDENCIES):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$(@:.sty=)/$@"

$(SIMPLE_DEFS):
	$(WGET) -N "http://mirrors.ctan.org/macros/latex/contrib/$(@:.def=)/$@"

dependencies:: $(DEPENDENCIES)

clean-all:: clean
	$(VECHO) "RM *.PFM *.MF *.TFM *.PFB *.MAP *.DEF *.FD *.PRO *.LOX *.CSF *.BST *.CFG *.CBX *.BBX *.LBX *.600PK *.CMAP *.DRV"
	$(Q)rm -f *.pfm *.mf *.tfm *.pfb *.map *.def *.fd *.pro *.lox *.csf *.bst *.cfg *.cbx *.bbx *.lbx *.600pk *.cmap *.drv
	rm -rf $(DEPENDENCIES) $(PRE_DEPENDENCIES)
