## This is a Work in Progress ##

This bundle is a work in progress. It has many warts, and it is far from complete. It is idiosyncratic in ways that it shouldn't be. Some commands are probably broken.

I suspect anyone who uses Pandoc with Textmate will want a bundle tweaked to suit their own needs, and that many of us have already rolled our own sets of simple commands. I have two goals for this bundle, which aren't entirely compatible:

1.  To provide a reasonable set of commands and options to help get new users started.
2.  To provide a way for users to share commands and options that they've come up with.

This probably means that the bundle should eventually be organized into "basic" and "advanced" sections.

Fixes, forks, improvements, ideas, complete overhauls, all welcome.

## Language ##

For the Language syntax, I shamelessly stole Fletcher Penney's [MultiMarkdown Bundle](http://fletcherpenney.net/multimarkdown/multimarkdown_bundle_for_textm/), which is a slightly modified version of the syntax file from the original Markdown plugin. Since several of the MMD extensions are the same as the Pandoc extensions, this works okay. I've made a few changes, but I've made no attempt to systematically change it to account for differences between Pandoc's extensions to Markdown and MMD's extensions to Markdown. 

I find that Fletcher Penney's [MultiMarkdown Theme](http://files.fletcherpenney.net/MultiMarkdown.tmTheme.zip)  works reasonably well with the modified language file.

It would be better to have a clean and complete Language specification for Pandoc's extended Markdown. I just haven't bothered to do it.

## Scope ##

I've scoped Pandoc as a flavor of markdown: text.html.markdown.pandoc. So if you have a markdown bundle installed, those commands should also work in this bundle.

I guess this makes sense for those who use markdown as an easy way to write HTML. I find I'm more likely to use it as an easy way to write LaTeX or ConTeXt, which suggests changing the scope to something like text.tex.markdown.pandoc, so as to inherit commands and syntax from the LaTeX bundle instead of the HTML bundle. Those with greater TextMate fu might have a better sense of how to think about this. 

## Paths ##

You may need to set the PATH variable in TextMates Preferences -> Advanced -> Shell Variables to include the path to pandoc.

## Citations ##

### Processing of Citations ###

Commands for processing citations will only work if you have compiled pandoc with citeproc support. I recommend applying [wazzeb's patch](http://code.google.com/p/citeproc-hs/issues/detail?id=4)  to citeproc-hs, which fixes a variety of small issues and adds support for multiple bibliography formats (relying on  [bibutils](http://www.scripps.edu/~cdputnam/software/bibutils/)) for those of us who haven't been able to compile citeproc-hs with hs-bibutils support built-in.

You must set three variables in Preferences -> Advanced -> Shell Variables:

+   $TM\_PANDOC\_BIB: the path of the bibliography database you want to use. (If the bundle were smarter it would fall back to $TM\_LATEX\_BIB if this variable was not set. But for now, it doesn't.)
+   $TM\_PANDOC\_BIBTYPE: to the type of database: mods or bibtex, for example. 
+   $TM\_PANDOC\_CSL: the path to the CSL style file you want to use.

### Autocompletion of Citations ###

If $TM\_PANDOC\_BIB points to a bibtex or mods xml file, then you can use TextMate's autocompletion (type part of a word then hit the ESCAPE key) to complete citation keys. I have no idea how robust this is: I am just using regexps in ruby to find the citation keys. It shouldn't be hard to expand support for other bibliography formats.

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

### Mellel

I tried to come up with a command to convert Mellel files on drag and drop, but Mellel files are directories. If you drag a directory into a window, TextMate just prints the directory tree to the window. If you drag it to the TextMate icon, TextMate opens the directory as a project. To convert Mellel files, try Malte Rosenau's [Mellel2MMD.app](http://wwwuser.gwdg.de/~mrosena/). In principle, it should be possible to modify Rosenau's mellel2mmd.xsl to produce Pandoc markdown, but in practice it is probably more sensible to convert Mellel files to MMD, and then convert the MMD to Pandoc Markdown.

For smoother integration with TextMate, one can replace Mellel2MMD.app/Contents/Resources/script with

    #!/bin/bash
    
    # You can access your bundled files at the following paths:
    #
    # "$1/Contents/Resources/mellel2mmd.xsl"
    #
    #
    
    mdext="markdown"
    
    new=`echo "$2" | sed s/mellel$/$mdext/g`
    
    if [ -f "$2/main.xml" ]; then 
        xsltproc -o "$new" "$1/Contents/Resources/mellel2mmd.xsl" "$2/main.xml"
    else
        gunzip -c "$2/main.xml.gz" | xsltproc -o "$new" "$1/Contents/Resources/mellel2mmd.xsl" -
    fi
    mate -r "$new"

If you don't have the 'mate' command installed (if you are reading this, you should!), make that last line

    open -a "TextMate" "$new"

instead. This will alter the behavior of Mellel2MMD.app in three ways:

+   <s>it will handle compressed Mellel files without complaint</s> (Mellel2MMD.app now does this.)
+   it will save the new file with the .markdown extension rather than the .mmd extension. (Set $mdext to your preferred extension.)
+   it will automatically open the new file in TextMate.
