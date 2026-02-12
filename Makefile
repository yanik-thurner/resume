compile:
	sed -i 's/language = ".*"/language = "de"/' main.typ
	typst compile ./main.typ --font-path ~/.local/share/fonts ./out/yanik-thurner-lebenslauf.pdf
	sed -i 's/language = ".*"/language = "en"/' main.typ
	typst compile ./main.typ --font-path ~/.local/share/fonts ./out/yanik-thurner-resume.pdf

