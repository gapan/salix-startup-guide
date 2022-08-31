SSH_HOST=salixos.org
SSH_PORT=22
SSH_USER=web
SSH_TARGET_DIR=/srv/www/guide.salixos.org

html: htmltmp fix-anchors prepare-worktree
	rm -rf output/img
	mkdir -p output/htmlsep
	cp -r img output/
	mogrify -resize '760>' output/img/*.png
	htmldoc -t htmlsep --outdir output/htmlsep output/guide.html
	cp css/*.css output/htmlsep/
	cp img-css/*.png output/htmlsep/
	rm -rf output/img
	sed -i "/<STYLE TYPE=/,/--><\/STYLE>/d" output/htmlsep/*.html
	sed -i "s|^</HEAD>|<link rel=\"stylesheet\" href=\"default.css\" type=\"text/css\">\n</HEAD>|" \
		output/htmlsep/*.html
	sed -i "s|^</HEAD>|<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n</HEAD>|" \
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
	rm -f output/guide.html
	cp -f output/htmlsep/toc.html output/htmlsep/index.html
	echo "guide.salixos.org" > output/htmlsep/CNAME

prepare-worktree:
	rm -rf output/htmlsep
	git worktree prune
	rm -rf .git/worktree/htmlsep
	git worktree add -B public output/htmlsep origin/public
	rm -rf output/htmlsep/*

fix-anchors:
	perl -i -p -e 's/<\/A>\n/<\/A>/' output/guide.html
	sed -i 's/^\(<A NAME=.*<\/A>\)\(<H.*<\/H[0-9]>\)/\2\n\1/' output/guide.html

htmltmp: 
	mkdir -p output
	txt2tags -t html -C config.t2t -o output/guide.html guide.t2t

publish: html
	cd output/htmlsep && \
	git add --all && \
	git commit -m "Publish on `date`" && \
	git push -f -u origin public

ebook-prepare: htmltmp fix-anchors
	sed -i 's/^NOTESTART/<B><I>/' output/guide.html
	sed -i 's/ NOTESTART$$/<\/B>/' output/guide.html
	sed -i 's/NOTEEND/<\/I>/' output/guide.html
	sed -i 's/^IMPORTANTSTART/<B><I>/' output/guide.html
	sed -i 's/ IMPORTANTSTART$$/<\/B>/' output/guide.html
	sed -i 's/IMPORTANTEND/<\/I>/' output/guide.html
	sed -i 's/^WARNINGSTART/<B><I>/' output/guide.html
	sed -i 's/ WARNINGSTART$$/<\/B>/' output/guide.html
	sed -i 's/WARNINGEND/<\/I>/' output/guide.html
	cp -r img output/
	convert -density 150 -resize 600 1stpage.pdf 1stpage.jpg

epub: ebook-prepare
	ebook-convert output/guide.html output/guide.epub \
		--title="Salix Startup Guide" \
		--authors="Salix" \
		--language=en \
		--cover=1stpage.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"
	rm -rf output/img

mobi: ebook-prepare
	ebook-convert output/guide.html output/guide.mobi \
		--title="Salix Startup Guide" \
		--authors="Salix" \
		--language=en \
		--cover=1stpage.jpg \
		--chapter "//h:h1" \
		--chapter "//h:h2" \
		--chapter "//h:h3" \
		--level1-toc "//h:h1" \
		--level2-toc "//h:h2" \
		--level3-toc "//h:h3"
	rm -rf output/img

tex:
	mkdir -p output
	txt2tags --toc -t tex -C config.t2t -o output/guide.tex guide.t2t
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
	rm -f output/guide.tex
	qpdf --empty --pages 1stpage.pdf output/guide.pdf -- output/SalixStartupGuide.pdf

all: html pdf epub mobi

help:
	@echo 'Makefile for generating the Salix startup guide                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make                             (re)generate the web site          '
	@echo '   make html                        same as make                       '
	@echo '   make pdf                         generate pdf file                  '
	@echo '   make epub                        generate epub file                 '
	@echo '   make mobi                        generate mobi file                 '
	@echo '   make clean                       remove the generated files         '
	@echo '   upload                           upload the web site via rsync+ssh  '
	@echo '                                                                       '

clean:
	rm -rf output
	rm -f guide.html
	rm -f 1stpage.jpg

upload: html
	rsync -e "ssh -p $(SSH_PORT)" \
		-avz \
		--exclude "*.t2t" \
		--exclude ".git" \
		--exclude ".gitignore" \
		--exclude "files" \
		--delete ./output/htmlsep/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

upload-pdf: pdf
	scp output/SalixStartupGuide.pdf $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)/files/

upload-ebooks:
	scp output/guide.epub $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)/files/SalixStartupGuide.epub
	scp output/guide.mobi $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)/files/SalixStartupGuide.mobi

.PHONY: all html htmltmp epub mobi tex pdf help clean upload upload-pdf upload-ebooks ebook-prepare fix-anchors
