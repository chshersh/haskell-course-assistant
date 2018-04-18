module HaskellRobot.Parsers.Tasks
       ( tasksParser
       ) where

import           Control.Applicative         ((<|>))
import           Data.Monoid                 ((<>))
import           Data.Text                   (pack)

import           Text.Megaparsec             (between, optional, some, someTill, try)
import           Text.Megaparsec.Char        (anyChar, char, digitChar, letterChar,
                                              space, spaceChar, string)

import           HaskellRobot.Data.Task      (TaskBlock, TaskSet)
import           HaskellRobot.Parsers.Common (Parser)

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
