#!/usr/bin/runghc

import Text.Pandoc

demoteheader :: Block -> Block
demoteheader (Header n xs) | n <= 5 = Header (n + 1) xs
demoteheader x = x

transformDoc :: Pandoc -> Pandoc
transformDoc = processWith demoteheader

readDoc :: String -> Pandoc
readDoc = readMarkdown defaultParserState

writeDoc :: Pandoc -> String
writeDoc = writeMarkdown defaultWriterOptions

main :: IO ()
main = interact (writeDoc . transformDoc . readDoc)