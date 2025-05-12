# ------------------------------------------------------------
# Beamer slide Makefile (LuaLaTeX + latexmk)
#   生成物はルート直下に作成
#
# targets
#   make / make build  -> main.pdf
#   make view          -> open pdf
#   make clean         -> remove aux files (keep PDF)
#   make distclean     -> remove aux + PDF
# ------------------------------------------------------------
TEX        = latexmk
ENGINE     = lualatex
EXTRAOPTS  = -shell-escape
SRC        = main.tex
PDF        = main.pdf

# latexmk flags
TEXFLAGS   = -$(ENGINE) $(EXTRAOPTS) \
             -interaction=nonstopmode -file-line-error

# ------------------------------------------------------------
.PHONY: all build view clean distclean help

all: build                     ## (= default)

build: $(PDF)                  ## build pdf

$(PDF): $(SRC)
	@echo "=== Building $@ ==="
	@$(TEX) $(TEXFLAGS) $<

view: build                    ## open pdf
	open $(PDF)

clean:                         ## remove aux (keep pdf)
	latexmk -C                  # -C deletes aux generated in cwd

distclean: clean               ## remove aux + pdf
	rm -f $(PDF)

help:                          ## show help
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
	    awk 'BEGIN {FS = ":.*?##"}; {printf "  %-12s %s\n", $$1, $$2}'
