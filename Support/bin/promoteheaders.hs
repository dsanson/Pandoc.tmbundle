#!/usr/bin/runghc

import Text.Pandoc

promoteheader :: Block -> Block
promoteheader (Header n xs) | n >= 2 = Header (n - 1) xs
promoteheader x = x

transformDoc :: Pandoc -> Pandoc
transformDoc = processWith promoteheader

readDoc :: String -> Pandoc
readDoc = readMarkdown defaultParserState

writeDoc :: Pandoc -> String
writeDoc = writeMarkdown defaultWriterOptions

main :: IO ()
main = interact (writeDoc . transformDoc . readDoc)