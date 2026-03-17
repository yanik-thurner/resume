LANGS := en de
VARIANTS := public private
THEMES := classic1 github2024

TARGETS := $(foreach l,$(LANGS),$(foreach v,$(VARIANTS),$(foreach t,$(THEMES),compile-$l-$v-$t)))

.PHONY: compile clean

compile: $(TARGETS)

compile-%:
	$(eval lang := $(word 1,$(subst -, ,$*)))
	$(eval variant := $(word 2,$(subst -, ,$*)))
	$(eval theme := $(word 3,$(subst -, ,$*)))
	echo "=> GENERATING $(theme) / $(lang) / $(variant)"
	cat data/data-$(lang)-$(variant).yaml data/data-$(lang)-common.yaml | yq eval 'explode(.)' --yaml-fix-merge-anchor-to-spec > data/data-$(lang).yaml
	typst compile \
		--input datafile=data/data-$(lang).yaml \
		--input lang=$(lang) \
		--input variant=$(variant) \
		--input theme=$(theme) \
		main.typ /tmp/raw.pdf

	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -sOutputFile=out/yanik-thurner-resume-$(theme)-$(lang)-$(variant).pdf /tmp/raw.pdf
	@if [ "$(variant)" = "public" ] && [ "$(lang)" = "en" ]; then \
		pdftoppm -png -r 300 -singlefile \
			out/yanik-thurner-resume-$(theme)-$(lang)-$(variant).pdf \
			out/yanik-thurner-resume-$(theme)-$(lang)-$(variant); \
	fi

	rm -f data/data-$(lang).yaml

clean:
	rm -f data/data-??.yaml
