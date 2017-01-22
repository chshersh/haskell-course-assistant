module HaskellRobot.Parsers.Tasks
       ( tasksParser
       ) where

import           Control.Applicative    ((<|>))
import           Data.Monoid            ((<>))
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
    blockName <- optional (between (char '(') (char ')') blockNameParser)
    let prefix = maybe "" (\s -> "(" <> pack s <> ") ") blockName
    taskSet   <- between (string "{{") (string "}}") taskExampleParser <* space
    pure $ map (prefix <>) taskSet
  where
    blockNameParser = some $ letterChar <|> spaceChar <|> digitChar
