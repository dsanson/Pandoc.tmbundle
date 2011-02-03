# Pandoc TextMate Bundle README

This is a TextMate bundle for use with John MacFarlane's [pandoc][].
Pandoc is a command line tool that converts files from one markup format
to another. It is a powerful tool that can be used in many ways for many
purposes.

I write most documents in Pandoc's extended Markdown syntax. This bundle
was put together to serve the needs of someone doing that. It focuses on
commands for converting existing documents into Pandoc's markdown format
and commands for exporting documents written in Pandoc's markdown format
to HTML, LaTeX, ConTeXt, PDF, and ODT.

## This is a Work in Progress

This bundle is a work in progress. It has many warts, and it is far from
complete. It is idiosyncratic in ways that it shouldn't be. Some
commands are probably broken. It makes use of hackish regexs when it
should use [elegant haskell scripts][].

I suspect anyone who uses Pandoc with Textmate will want a bundle
tweaked to suit their own needs, and that many of us have already rolled
our own sets of simple commands. I have two goals for this bundle, which
aren't entirely compatible:

1.  To provide a reasonable set of commands and options to help get new
    users started.
2.  To provide a way for users to share commands and options that
    they've come up with.

This probably means that the bundle should eventually be organized into
"basic" and "advanced" sections.

Fixes, forks, improvements, ideas, complete overhauls, all welcome.

## Highlights

### Citations

Pandoc 1.8 added support for processing citations using hs-citeproc.
This bundle supports this: most conversion commands have a "(citations)"
variant that will process ciations.

You must set the following variable in Preferences -\> Advanced -\>
Shell Variables:

-   $TM\_PANDOC\_BIB: the path of the bibliography database you want to
    use. (If the bundle were smarter it would fall back to
    $TM\_LATEX\_BIB if this variable was not set. But for now, it
    doesn't.)

### Autocompletion of Citation Keys

If $TM\_PANDOC\_BIB points to a bibtex or mods xml file, then you can
use TextMate's autocompletion (type part of a word then hit the ESCAPE
key) to complete citation keys. I have no idea how robust this is: I am
just using regexps in ruby to find the citation keys. It shouldn't be
hard to expand support for other bibliography formats.

### Markdown Tidy

The bundle provides several commands that use pandoc as a kind of pretty
printer for markdown: pushing markdown through pandoc allows for each
conversion between inline and reference links, for example, and soft or
hard-wrapped lines. It also cleans up bullets and lists nicely.

### MultiMarkdown

I've included a few commands for quickly converting some aspects of MMD
syntax to Pandoc syntax. There are commands for converting MMD metadata
to and from Pandoc Title Blocks. There is also a command for converting
MMD formatted citations, like `[p. 20][#citekey]` to Pandoc formatted
citations, like `[citekey@p. 20]`.

### Drag and Drop Conversions

Open a new document in TextMate, set the language to Pandoc, drag a file
onto it, and the bundle will try to convert it to Pandoc Markdown.

Here are the details:

-   HTML, TeX, LaTeX, and RsT files are converted directly by pandoc.
    Limitations in the conversions are limitations in pandoc. All other
    files are first converted to HTML, then converted from HTML by
    pandoc.
-   ODT, DOC, DOCX, RTF, RTFD, WORDML, and webarchive files are first
    converted to html using apple's textutil command. This typically
    destroys footnotes. YMMV.
-   PDF files are first converted to HTML using [pdftohtml][], which
    you'll have to install.

## Language

For the Language syntax, I shamelessly stole Fletcher Penney's
[MultiMarkdown Bundle][], which is a slightly modified version of the
syntax file from the original Markdown plugin. Since several of the MMD
extensions are the same as the Pandoc extensions, this works okay. I've
made a few changes, but I've lost track of what they were, and I've made
no attempt to systematically change it to account for differences
between Pandoc's extensions to Markdown and MMD's extensions to
Markdown.

I find that Fletcher Penney's [MultiMarkdown Theme][] works reasonably
well with the modified language file.

It would be better to have a clean and complete Language specification
for Pandoc's extended Markdown. I just haven't bothered to do it.

## Scope

I've scoped Pandoc as a flavor of markdown: text.html.markdown.pandoc.
So if you have a markdown bundle installed, those commands should also
work in this bundle.

I guess this makes sense for those who use markdown as an easy way to
write HTML. I find I'm more likely to use it as an easy way to write
LaTeX or ConTeXt, which suggests changing the scope to something like
text.tex.markdown.pandoc, so as to inherit commands and syntax from the
LaTeX bundle instead of the HTML bundle. Those with greater TextMate fu
might have a better sense of how to think about this.

## Paths

You may need to set the PATH variable in TextMate's Preferences -\>
Advanced -\> Shell Variables to include the path to pandoc.

## Locale

If you get a "hGetContents: invalid argument (Illegal byte sequence)"
error, you need to set the LANG variable in TextMate's Preferences -\>
Advanced -\> Shell Variables to something like "en\_US.UTF-8". See [this
thread][] for details.

## Converting to ODT

The command that converts documents to ODT also automatically opens the
generated document. On a newer Mac, this should be fine. On an older
Mac, this can take a *long* time. If you are using this on an older Mac,
you might want to delete/comment out the line that says:

    open "$targetname"

## Mellel

I tried to come up with a command to convert Mellel files on drag and
drop, but Mellel files are directories. If you drag a directory into a
window, TextMate just prints the directory tree to the window. If you
drag it to the TextMate icon, TextMate opens the directory as a project.
So to convert Mellel files, try Malte Rosenau's [Mellel2MMD.app][]. In
principle, it should be possible to modify Rosenau's mellel2mmd.xsl to
produce Pandoc markdown, but in practice it is probably more sensible to
convert Mellel files to MMD, and then convert the MMD to Pandoc
Markdown.

  [pandoc]: http://johnmacfarlane.net/pandoc
  [elegant haskell scripts]: http://johnmacfarlane.net/pandoc/scripting.html
  [pdftohtml]: http://pdftohtml.sourceforge.net/
  [MultiMarkdown Bundle]: http://fletcherpenney.net/multimarkdown/multimarkdown_bundle_for_textm/
  [MultiMarkdown Theme]: http://files.fletcherpenney.net/MultiMarkdown.tmTheme.zip
  [this thread]: https://groups.google.com/group/pandoc-discuss/browse_thread/thread/3c5c156ac60a3f5a
  [Mellel2MMD.app]: http://wwwuser.gwdg.de/~mrosena/
