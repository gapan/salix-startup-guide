salix-startup-guide
===================

These are the source files for the Salix Startup Guide. The guide is
available on the [Salix website](http://salixos.org/guide.html).

The guide is written using [txt2tags](http://txt2tags.org/) and
post-processed with [htmldoc](https://www.msweet.org/projects.php?Z1).
Both need to be installed to create the HTML documentation. Once you do
have them installed, you can create the HTML documentation with:

  make html

To output
the guide as a PDF file a [TeXLive](https://www.tug.org/texlive/)
installation is required as well as
[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/).
You can then create the PDF file by running:

  make pdf

To output the guide as EPUB and MOBI e-book
files, ebook-convert from the
[Calibre](http://calibre-ebook.com/) project is needed. You can run:

  make epub

and

  make mobi

to create the EPUB and MOBI files respectively.
