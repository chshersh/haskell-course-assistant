module HaskellRobot.Parsers.Tasks
       ( tasksParser
       ) where

import           Control.Applicative    ((<|>))
import           Data.Text              (pack)

import           Text.Megaparsec        (anyChar, between, char, digitChar, letterChar,
                                         optional, some, someTill, space, spaceChar,
                                         string, try)
import           Text.Megaparsec.Text   (Parser)

import           HaskellRobot.Data.Task (TaskBlock, TaskSet)

taskExampleParser :: Parser TaskSet
taskExampleParser =
    map pack
    <$>
    some
        (   space
         *> string "[["
         *> someTill anyChar (try $ string "]]")
         <* space)

tasksParser :: Parser TaskBlock
tasksParser = some $ do
    () <$ optional (some digitChar)
    () <$ optional (between (char '(') (char ')') blockNameParser)
    between (string "{{") (string "}}") taskExampleParser <* space
  where
    blockNameParser = some $ letterChar <|> spaceChar <|> digitChar
