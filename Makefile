
html: 
	txt2tags -t html guide.t2t

epub: html
	ebook-convert guide.html guide.epub \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"

mobi: html
	ebook-convert guide.html guide.mobi \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"

pdf: html
	txt2tags -t tex guide.t2t
	xelatex guide.tex
	rm -f guide.aux
	rm -f guide.log
	rm -f guide.out
	#rm -f guide.tex

help:
	@echo 'Makefile for generating the Salix startup guide                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make                             (re)generate the web site          '
	@echo '   make html                        same as make                       '
	@echo '   make clean                       remove the generated files         '
	@echo '   upload                           upload the web site via rsync+ssh  '
	@echo '                                                                       '

clean:
	rm -f guide.html
	rm -f guide.epub
	rm -f guide.mobi

upload: html
	echo "Not implemented yet"

.PHONY: html epub mobi pdf help clean upload
