
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
	rm -rf output/img
	sed -i "/<STYLE TYPE=/,/--><\/STYLE>/d" output/htmlsep/*.html
	sed -i "s|^</HEAD>|<link rel=\"stylesheet\" href=\"default.css\" type=\"text/css\">\n</HEAD>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"toc.html\">Contents</A>|<ul class=\"docnav\"><li class=\"home\"><A HREF=\"toc.html\"><strong>Contents</strong></A></li>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Previous</A>|<li class=\"previous\"><A HREF=\"\1\"><strong>Previous</strong></A></li>|" \
		output/htmlsep/*.html
	sed -i "s|^<A HREF=\"\(.*\)\">Next</A>|<li class=\"Next\"><A HREF=\"\1\"><strong>Next</strong></A></li></ul>|" \
		output/htmlsep/*.html
	sed -i ':a;{N;s/Previous<\/strong><\/A><\/li>\n<HR NOSHADE>/Previous<\/strong><\/A><\/li><\/ul>\n<HR NOSHADE>/};ba' \
		output/htmlsep/*.html
	sed -i ':a;{N;s/Previous<\/strong><\/A><\/li>\n<\/BODY>/Previous<\/strong><\/A><\/li><\/ul>\n<\/BODY>/};ba' \
		output/htmlsep/*.html
	sed -i 's|<BODY>|<BODY>\n<p id="title"><a class="left" href="http://www.salixos.org"><img src="salix-logo.png" alt="Salix Website"></a><a class="right" href="http://docs.salixos.org"><img src="documentation.png" alt="Documentation Site"></a></p>|' \
		output/htmlsep/*.html
	sed -i \
		's|NOTESTART \(.*\) NOTESTART|<div class="note"><div class="admonition_header"><h2>\1</h2></div><div class="admonition"><div class="para">|' \
		output/htmlsep/*.html
	sed -i 's|NOTEEND|</div></div></div>|' \
		output/htmlsep/*.html
	sed -i \
		's|IMPORTANTSTART \(.*\) IMPORTANTSTART|<div class="important"><div class="admonition_header"><h2>\1</h2></div><div class="admonition"><div class="para">|' \
		output/htmlsep/*.html
	sed -i 's|IMPORTANTEND|</div></div></div>|' \
		output/htmlsep/*.html
	sed -i \
		's|WARNINGSTART \(.*\) WARNINGSTART|<div class="warning"><div class="admonition_header"><h2>\1</h2></div><div class="admonition"><div class="para">|' \
		output/htmlsep/*.html
	sed -i 's|WARNINGEND|</div></div></div>|' \
		output/htmlsep/*.html

html: 
	mkdir -p output
	txt2tags -t html -o output/guide.html guide.t2t

epub: html
	cp -r img output/
	ebook-convert output/guide.html output/guide.epub \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"
	rm -rf output/img

mobi: html
	cp -r img output/
	ebook-convert output/guide.html output/guide.mobi \
		--cover=img/screenshots_rotated.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"
	rm -rf output/img

tex:
	mkdir -p output
	txt2tags --toc -t tex -o output/guide.tex guide.t2t
	sed -i -e "/begin{tabular}/s/l/L/g" -e "/begin{tabuLar}/s/tabuLar/tabulary}{\\\textwidth/" \
		output/guide.tex
	sed -i "/end{tabular}/s/end{tabular}/end{tabulary}/" \
		output/guide.tex

pdf: tex
	xelatex -output-directory=output output/guide.tex
	xelatex -output-directory=output output/guide.tex
	rm -f output/guide.aux
	rm -f output/guide.log
	rm -f output/guide.out
	rm -f output/guide.toc
	@#rm -f output/guide.tex

all: htmlsep pdf epub mobi

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

.PHONY: all html htmlsep epub mobi tex pdf help clean upload
