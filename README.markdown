## Work in Progress ##

This bundle is a work in progress. It has many warts, and it is far from complete.

The Language Syntax, for example, has been shamelessly plundered from Fletcher Penney's [MultiMarkdown Bundle](http://fletcherpenney.net/multimarkdown/multimarkdown_bundle_for_textm/), and I haven't tried to fix it to account for differences between pandoc and mmd.

I've scoped pandoc as a flavor of markdown: text.html.markdown.pandoc. This should mean that a pandoc file inherits whatever goodies you have in your markdown bundle.

## Markdown to Markdown ##

The bundle provides several commands that use pandoc as a kind of pretty printer for markdown: pushing markdown through pandoc allows for each conversion between inline and reference links, for example, and soft or hard-wrapped lines.

## Drag and Drop Conversions ##

Open a new document in TextMate, set the language to Pandoc, drag a file onto it, and we'll do our best to convert it to Pandoc Markdown.

Here are the details:

+   HTML, TeX, LaTeX, and RsT files are converted directly by pandoc. Limitations in the conversions are limitations in pandoc. All other files are first converted to HTML, then converted from HTML by pandoc. 
+   ODT, DOC, DOCX, RTF, RTFD, WORDML, and webarchive files are first converted to html using apple's textutil command. This typically destroys footnotes.
+   PDF files are first converted to HTML using [pdftohtml](http://pdftohtml.sourceforge.net/), which you'll need to install for yourself.
+   Support for Mellel files is currently broken. On an old computer somewhere I have a patched version of Malte Rosenau's [mellel2mmd](http://wwwuser.gwdg.de/~mrosena/). It worked from the command line, but since Mellel documents are actually packages, it never worked for dragging and dropping. If you want to convert Mellel documents to Pandoc files, download mellel2mmd and then convert the metadata, either by hand or using the "Convert MMD Metadata to Pandoc Metadata" command provided by this bundle.

## Citations ##

### Processing of Citations ###

Commands for processing citations will only work if you have compiled pandoc with citeproc support. I recommend applying [wazzeb's patch](http://code.google.com/p/citeproc-hs/issues/detail?id=4)  to citeproc-hs.

You must set three variables in Preferences/Advanced/Shell Variables:

+   $TM\_PANDOC\_BIB: the path of the bibliography database you want to use. (If the bundle were smarter it would fall back to $TM\_LATEX\_BIB if this variable was not set.)
+   $TM\_PANDOC\_BIBTYPE: to the type of database: mods or bibtex, for example. 
+   $TM\_PANDOC\_CSL: the path to the CSL style file you want to use.

### Autocompletion of Citations ###

If $TM\_PANDOC\_BIB points to a bibtex or mods xml file, then you can use TextMate's autocompletion (type part of a word then hit the ESCAPE key) to complete citation keys. I have no idea how robust this is: I am just using regexps in ruby to find the citation keys.



