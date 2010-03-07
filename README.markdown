## This is a Work in Progress ##

This bundle is a work in progress. It has many warts, and it is far from complete.

The Language Syntax, for example, has been shamelessly plundered from Fletcher Penney's [MultiMarkdown Bundle](http://fletcherpenney.net/multimarkdown/multimarkdown_bundle_for_textm/). I've made a few changes, but I've made no attempt to systematically change it to account for differences between pandoc and mmd.

## Scope ##

I've scoped pandoc as a flavor of markdown: text.html.markdown.pandoc. This should mean that a pandoc file inherits whatever goodies you have in your markdown bundle. 

I guess this makes sense for those who use markdown as an easy way to write HTML. I find I'm more likely to use it as an easy way to write LaTeX or ConTeXt, which suggests changing the scope to something like text.tex.markdown.pandoc.

## Paths ##

You may need to set the PATH variable in TextMates Preferences -> Advanced -> Shell Variables to include the path to pandoc.

## Conversions

The conversion commands should be self-explanatory. The commands in the bundle reflect the conversions I am most likely to do. A more complete set of commands should be included.

### Markdown to Markdown ###

The bundle provides several commands that use pandoc as a kind of pretty printer for markdown: pushing markdown through pandoc allows for each conversion between inline and reference links, for example, and soft or hard-wrapped lines.

### MultiMarkdown ###

I've included a few commands for quickly converting between MMD syntax and Pandoc syntax. There are commands for converting MMD metadata to and from Pandoc metadata (i.e., the Title Block). There is also a command for converting MMD formatted citations, like `[p. 20][#citekey]` to Pandoc formatted citations, like `[citekey@p. 20]`. Are there other conversions

### Converting to PDF ###

The commands to convert to PDF do so via ConTeXt, as described on the [Pandoc examples](http://johnmacfarlane.net/pandoc/examples.html) page. Edit them if you prefer to convert to PDF via LaTeX.

### Converting to ODT ###

The command that converts documents to ODT also automatically opens the generated document. On a newer Mac, this should be fine. On an older Mac, this can take a *long* time. If you are using this on an older Mac, you might want to delete the line that says:

    open "$targetname"

### Drag and Drop Conversions ###

Open a new document in TextMate, set the language to Pandoc, drag a file onto it, and the bundle will try to convert it to Pandoc Markdown.

Here are the details:

+   HTML, TeX, LaTeX, and RsT files are converted directly by pandoc. Limitations in the conversions are limitations in pandoc. All other files are first converted to HTML, then converted from HTML by pandoc. 
+   ODT, DOC, DOCX, RTF, RTFD, WORDML, and webarchive files are first converted to html using apple's textutil command. This typically destroys footnotes.
+   PDF files are first converted to HTML using [pdftohtml](http://pdftohtml.sourceforge.ne,t/), which you'll have to install.

I tried to come up with a command to convert Mellel files on drag and drop, but Mellel files are packages, and TextMate just opens the contents of the folder as a project. To convert Mellel files, try Malte Rosenau's [Mellel2MMD.app](http://wwwuser.gwdg.de/~mrosena/). For some reason, the app doesn't support compressed Mellel files. To fix this, replace Mellel2MMD.app/Contents/Resources/script with this:

    #!/bin/bash

    # You can access your bundled files at the following paths:
    #
    # "$1/Contents/Resources/mellel2mmd.xsl"
    #
    #

    new=`echo "$2" | sed s/mellel$/mmd/g`

    if [ ! -f "$2/main.xml" ]; then 
    	gunzip "$2/main.xml.gz"
    fi

    xsltproc -o "$new" "$1/Contents/Resources/mellel2mmd.xsl" "$2/main.xml"

(This will leave your file uncompressed. If you want to automatically recompress it, add some lines to gzip main.xml back up.) There are a couple of commands in the bundle that make converting (some aspects of) the resulting MMD file to Pandoc markdown easier.

## Citations ##

### Processing of Citations ###

Commands for processing citations will only work if you have compiled pandoc with citeproc support. I recommend applying [wazzeb's patch](http://code.google.com/p/citeproc-hs/issues/detail?id=4)  to citeproc-hs, which fixes a variety of small issues and adds support for multiple bibliography formats (relying on  [bibutils](http://www.scripps.edu/~cdputnam/software/bibutils/)) for those of us who haven't been able to compile citeproc-hs with hs-bibutils support built-in.

You must set three variables in Preferences -> Advanced -> Shell Variables:

+   $TM\_PANDOC\_BIB: the path of the bibliography database you want to use. (If the bundle were smarter it would fall back to $TM\_LATEX\_BIB if this variable was not set. But for now, it doesn't.)
+   $TM\_PANDOC\_BIBTYPE: to the type of database: mods or bibtex, for example. 
+   $TM\_PANDOC\_CSL: the path to the CSL style file you want to use.

### Autocompletion of Citations ###

If $TM\_PANDOC\_BIB points to a bibtex or mods xml file, then you can use TextMate's autocompletion (type part of a word then hit the ESCAPE key) to complete citation keys. I have no idea how robust this is: I am just using regexps in ruby to find the citation keys. It shouldn't be hard to expand support for other bibliography formats.
