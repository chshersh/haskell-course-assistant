module ParseUtils (PersonVars, sectionsParser, namesParser) where

import Data.Char (digitToInt)

import Text.Parsec
import Text.Parsec.String

type Section    = [String]
type PersonVars = (Int, String, [Int])

taskParser :: Parser Section
taskParser = many1 $ spaces *> string "[[" *> manyTill anyChar (try $ string "]]") <* spaces

sectionsParser :: Parser [Section]
sectionsParser = many1 $ do
    optional $ many1 digit
    optional $ between (char '(') (char ')') (many1 $ letter <|> space <|> digit)
    between (string "{{") (string "}}") taskParser <* spaces


