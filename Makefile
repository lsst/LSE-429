DOCTYPE = LSE
DOCNUMBER = 429
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)
JOBNAME = $(DOCNAME)
TEX = $(filter-out $(wildcard *acronyms.tex) , $(wildcard *.tex))

#export TEXMFHOME = lsst-texmf/texmf

# Version information extracted from git.
GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

#Traditional acronyms are better in this document, instead of glossary
$(DOCNAME).pdf: $(DOCNAME).tex meta.tex acronyms.tex
	latexmk -bibtex -xelatex -f $(DOCNAME).tex

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	echo '% GENERATED FILE -- edit this in the Makefile' >>$@
	/bin/echo '\newcommand{\lsstDocType}{$(DOCTYPE)}' >>$@
	/bin/echo '\newcommand{\lsstDocNum}{$(DOCNUMBER)}' >>$@
	/bin/echo '\newcommand{\vcsrevision}{$(GITVERSION)$(GITDIRTY)}' >>$@
	/bin/echo '\newcommand{\vcsdate}{$(GITDATE)}' >>$@

#Traditional acronyms are better in this document
acronyms.tex : ${TEX} myacronyms.txt skipacronyms.txt
	echo ${TEXMFHOME}
	python3 ${TEXMFHOME}/../bin/generateAcronyms.py    $(TEX)

myacronyms.txt :
	touch myacronyms.txt

skipacronyms.txt :
	touch skipacronyms.txt
