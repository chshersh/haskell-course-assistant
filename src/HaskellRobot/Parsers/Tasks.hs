module HaskellRobot.Parsers.Tasks
       ( tasksParser
       ) where

import           Control.Applicative        ((<|>))

import           Text.Megaparsec            (anyChar, between, char, digitChar,
                                             letterChar, manyTill, optional, spaceChar,
                                             string, try)
import           Text.Megaparsec.String     (Parser)

import           HaskellRobot.Data.Task     (TaskBlock, TaskSet)
import           HaskellRobot.Parsers.Utils (many1, spaces)

taskExampleParser :: Parser TaskSet
taskExampleParser = many1 $ spaces *> string "[[" *> manyTill anyChar (try $ string "]]") <* spaces

tasksParser :: Parser TaskBlock
tasksParser = many1 $ do
    () <$ optional (many1 digitChar)
    () <$ optional (between (char '(') (char ')') blockNameParser)
    between (string "{{") (string "}}") taskExampleParser <* spaces
  where
    blockNameParser = many1 $ letterChar <|> spaceChar <|> digitChar