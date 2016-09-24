module HaskellRobot.Parsers.Tasks
       ( tasksParser
       ) where

import           Control.Applicative        ((<|>))

import           Text.Megaparsec            (anyChar, between, char, digitChar,
                                             letterChar, optional, some, someTill,
                                             spaceChar, string, try, space)
import           Text.Megaparsec.String     (Parser)

import           HaskellRobot.Data.Task     (TaskBlock, TaskSet)

taskExampleParser :: Parser TaskSet
taskExampleParser = some $ space *> string "[[" *> someTill anyChar (try $ string "]]") <* space

tasksParser :: Parser TaskBlock
tasksParser = some $ do
    () <$ optional (some digitChar)
    () <$ optional (between (char '(') (char ')') blockNameParser)
    between (string "{{") (string "}}") taskExampleParser <* space
  where
    blockNameParser = some $ letterChar <|> spaceChar <|> digitChar
