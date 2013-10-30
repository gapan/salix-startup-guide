
html: 
	txt2tags -t html guide.t2t

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
	find ./ -name "*.html"  -delete

upload: html
	echo "Not implemented yet"

.PHONY: html help clean upload
