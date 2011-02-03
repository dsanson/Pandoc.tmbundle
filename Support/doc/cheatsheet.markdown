% Pandoc Cheatsheet[^1]
% David Sanson
% January 31, 2011

This is incomplete and possibly incorrect. It is intended for quick reference purposes only.

# Backslash Escapes

Except inside a code block or inline code, **any punctuation or space
character** preceded by a backslash will be treated literally, even if
it would normally indicate formatting.

# Title Block

    % title
    % author(s) (separated by semicolons)
    % date

# Inline TeX and HTML

-   TeX commands are passed through to Markdown, LaTeX and ConTeXt
    output; otherwise they are deleted.
-   HTML is passed through untouched but
    -   Markdown inside HTML blocks is parsed as markdown.

# Paragraphs and line breaks

-   A paragraph is one or more lines of text separated by a blank line.
-   A line that ends with two spaces, or a line that ends with an escaped new-line (a backslash followed by a carriage return) indicates a
    manual line break.

# Italics, bold, superscript, subscript, strikeout

    *Italics* and **bold** are indicated with asterisks. 
    
    To ~~strikeout~~ text use double tildas. 
    
    Superscripts use carats, like so: 2^nd^. 
    
    Subscripts use single tildas, like so: H~2~O. 
    
    Spaces inside subscripts and superscripts must be escaped, 
    e.g., H~this\ is\ a\ long\ subscript~.

# Inline TeX math and Inline Code

    Inline TeX math goes inside dollar signs: $2 + 2$. 
    
    Inline code goes between backticks: `echo 'hello'`.

# Links and images

    <http://example.com>
    <foo@bar.com>
    [inline link](http://example.com "Title")
    ![inline image](/path/to/image, "alt text")

    [reference link][id]
    [implicit reference link][]
    ![reference image][id2]

    [id]: http://example.com "Title"
    [implicit reference link]: http://example.com
    [id2]: /path/to/image "alt text"

# Footnotes

    Inline notes are like this.^[Note that inline notes cannot contain multiple paragraphs.] Reference notes are like this.[^id]

    [^id]:  Reference notes can contain multiple paragraphs.

        Subsequent paragraphs must be indented.

# Citations

    Blah blah [see @doe99, pp. 33-35; also @smith04, ch. 1].

    Blah blah [@doe99, pp. 33-35, 38-39 and *passim*].

    Blah blah [@smith04; @doe99].

    Smith says blah [-@smith04].

    @smith04 says blah.

    @smith04 [p. 33] says blah.

# Headers

    Header 1
    ========

    Header 2
    --------

    # Header 1 #

    ## Header 2 ##

Closing \#s are optional. Blank line required before and after each
header.

# Lists

## Ordered lists

    1. example
    2. example

    A) example
    B) example

## Unordered lists

Items may be marked by '\*', '+', or '-'.

    +   example
    -   example
    *   example

Lists may be nested in the usual way:

    +   example
        +   example
    +   example

## Definition lists

    Term 1
      ~ Definition 1
    Term 2
      ~ Definition 2a
      ~ Definition 2b

    Term 1
    :   Definition 1
    Term 2
    :   Definition 2
        Second paragraph of definition 2.

# Blockquotes

    >   blockquote
    >>  nested blockquote

Blank lines required before and after blockquotes.

# Tables

      Right     Left     Center     Default
    -------     ------ ----------   -------
         12     12        12            12
        123     123       123          123
          1     1          1             1

    Table:  Demonstration of simple table syntax.

(For more complex tables, see the pandoc documentation.)

# Code Blocks

Begin with three or more tildes; end with at least as many tildes:

    ~~~~~~~
    {code here}
    ~~~~~~~

Optionally, you can specify the language of the code block:

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.haskell .numberLines}
    qsort []     = []
    qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
                   qsort (filter (>= x) xs) 
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Horizontal Rules

3 or more dashes or asterisks on a line (space between okay)

    ---
    * * *
    - - - -

[^1]: Cobbled together from
    <http://daringfireball.net/projects/markdown/syntax> and
    <http://johnmacfarlane.net/pandoc/README.html>.

  [`http://daringfireball.net/projects/markdown/syntax`{.url}]: http://daringfireball.net/projects/markdown/syntax
  [`http://johnmacfarlane.net/pandoc/README.html`{.url}]: http://johnmacfarlane.net/pandoc/README.html
