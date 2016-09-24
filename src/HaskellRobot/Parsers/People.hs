module HaskellRobot.Parsers.People
       ( peopleParser
       ) where

import           Control.Applicative              ((<|>))

import           Text.Megaparsec                  (eof, letterChar, newline, sepEndBy,
                                                   some, char)
import           Text.Megaparsec.String           (Parser)

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (TaskId)

studentRow :: Parser (ReifiedStudent TaskId)
studentRow = do
    name <- some (letterChar <|> char ' ')
    return ReifiedStudent { variant = -1, tasks = [], .. }

peopleParser :: Parser [ReifiedStudent TaskId]
peopleParser = do
    students <- studentRow `sepEndBy` newline
    eof
    return $ zipWith (\i sample -> sample{ variant = i }) [1..] students
