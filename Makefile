
html: 
	mkdir -p output
	txt2tags -t html -o output/guide.html guide.t2t
	rm -f output/guide.t2t

htmlsep: html
	rm -rf output/htmlsep
	rm -rf output/img
	mkdir -p output/htmlsep
	cp -r img output/
	mogrify -resize '600>' output/img/*.png
	mogrify -resize '600>' output/img/*.jpg
	htmldoc -t htmlsep --outdir output/htmlsep output/guide.html
	cp css/*.css output/htmlsep/
	cp img-css/*.png output/htmlsep/
	sed -i "/<STYLE TYPE=/,/--><\/STYLE>/d" output/htmlsep/*.html
	sed -i "s|^</HEAD>|<link rel=\"stylesheet\" href=\"default.css\" type=\"text/css\">\n</HEAD>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"toc.html\">Contents</A>|<ul class=\"docnav\"><li class=\"home\"><A HREF=\"toc.html\"><strong>Contents</strong></A></li>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Previous</A>|<li class=\"previous\"><A HREF=\"\1\"><strong>Previous</strong></A></li>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Next</A>|<li class=\"Next\"><A HREF=\"\1\"><strong>Next</strong></A></li></ul>|" \
		output/htmlsep/*.html

epub: html
	ebook-convert output/guide.html output/guide.epub \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"

mobi: html
	ebook-convert output/guide.html output/guide.mobi \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"

tex:
	mkdir -p output
	txt2tags --toc -t tex -o output/guide.tex guide.t2t

pdf: tex
	xelatex -output-directory=output output/guide.tex
	xelatex -output-directory=output output/guide.tex
	rm -f output/guide.aux
	rm -f output/guide.log
	rm -f output/guide.out
	rm -f output/guide.toc
	@#rm -f output/guide.tex

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
	rm -rf output
	rm -f guide.html

upload: html
	@echo "Not implemented yet"

.PHONY: html htmlsep epub mobi tex pdf help clean upload
