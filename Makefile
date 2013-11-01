
html: 
	txt2tags -t html guide.t2t

htmlsep: html
	rm -rf htmlsep
	mkdir -p htmlsep
	htmldoc -t htmlsep --outdir htmlsep guide.html
	cp css/*.css htmlsep/
	sed -i "/<STYLE TYPE=/,/--><\/STYLE>/d" htmlsep/*.html
	sed -i "s|^</HEAD>|<link rel=\"stylesheet\" href=\"default.css\" type=\"text/css\">\n</HEAD>|" htmlsep/*.html
	sed -i "s|^<A HREF=\"toc.html\">Contents</A>|<ul class=\"docnav\"><li class=\"home\"><A HREF=\"toc.html\"><strong>Contents</strong></A></li>|" htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Previous</A>|<li class=\"previous\"><A HREF=\"\1\"><strong>Previous</strong></A></li>|" htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Next</A>|<li class=\"Next\"><A HREF=\"\1\"><strong>Next</strong></A></li></ul>|" htmlsep/*.html


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

tex:
	txt2tags --toc -t tex guide.t2t

pdf: tex
	xelatex guide.tex
	xelatex guide.tex
	rm -f guide.aux
	rm -f guide.log
	rm -f guide.out
	rm -f guide.toc
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
	rm -f guide.pdf

upload: html
	@echo "Not implemented yet"

.PHONY: html htmlsep epub mobi tex pdf help clean upload
