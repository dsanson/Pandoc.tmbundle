% Pandoc Cheatsheet[^note]
% David Sanson
% March 05, 2010

[^note]: Cobbled together from <http://daringfireball.net/projects/markdown/syntax> and <http://johnmacfarlane.net/pandoc/README.html>.

## Metadata

Metadata can be specified in an optional title block at the beginning of the file:

    % title
    % author(s) (separated by commas)
    % date

## Backslash Escapes 

Except inside a code block or inline code, any punctuation or space character preceded by a backslash will be treated literally, even if it would normally indicate formatting. 

## Span Elements

### Paragraphs and line breaks

+   A paragraph is one or more lines of text separated by a blank line.
+   A line that ends with two spaces indicates a manual line break.

### Italic, bold, superscript, subscript, strikeout

    *italic*, **bold**
    ^superscript^, ~subscript~, ~~strikeout~~
    $TeX math$, `inline code`

Spaces must be escaped inside of subscripts and superscripts.

### Links and Images

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

### Footnotes
    
    Here is an inline note^[the text of the note here]
    Here is a reference note[^id]
    
    [^id]:  Some footnotes have multiple paragraphs.
        
        Subsequent paragraphs must be indented.
        
### Citations

Processing citations requires that pandoc be compiled with citeproc support.

    [geach1970], [geach1970@p. 33]

where 'geach1970' is the citation key for an entry in your database. A bibliography will be appended. Remember to put something like

    # References
    
at the end of your file.

## Block Elements

### Headers

    Header 1
    ========

    Header 2
    --------

    # Header 1 #

    ## Header 2 ##

Closing #s are optional. Blank line required before and after each header.
  
### Lists

Ordered list items may be marked with arabic numerals, uppercase and lowercase letters, or roman numerals. List markers may be enclosed in parentheses or followed by a single right-parentheses or period. They must be separated from the text that follows by at least one space, and, if the list marker is a capital letter with a period, by at least two spaces.

    1. example
    2. example
    
    A) example
    B) example

Note that the *starting* number matters, but subsequent numbers do not:

    4. example
    8. example

will generate a list whose elements are numbered 4 and 5.

Unordered lists items may be marked by '*', '+', or '-'.

    +   example
    -   example
    *   example

Lists may be nested in the usual way:

    +   example
        +   example
    +   example
    
### Definitions

    Term 1
      ~ Definition 1
    Term 2
      ~ Definition 2a
      ~ Definition 2b
    
or

    Term 1
    :   Definition 1
    Term 2
    :   Definition 2
        Second paragraph of definition 2.

### Blockquotes

    >   blockquote
    >>  nested blockquote

Blank lines required before and after blockquotes.

### Tables

Tables are a bit complicated. Here is the simple syntax:

      Right     Left     Center     Default
    -------     ------ ----------   -------
         12     12        12            12
        123     123       123          123
          1     1          1             1

    Table:  Demonstration of simple table syntax.
    
### Code Blocks

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

### Horizontal Rules

3 or more dashes or asterisks on a line (space between okay)

    ---
    * * *
    - - - -

## Inline TeX and HTML

+   TeX commands are passed through to Markdown, LaTeX and ConTeXt output; otherwise they are deleted.
+   HTML is passed through untouched but
    +   Markdown inside HTML blocks is parsed as markdown.



