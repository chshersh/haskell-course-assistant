module HaskellRobot.Parses.People
       (
       ) where

nameRow :: Parser (String, [Int])
nameRow = do
    name <- many1 (letter <|> oneOf " ")
    optional $ char ':'
    vars <- digit `sepBy` char ','
    return (name, map digitToInt vars)

namesParser :: Parser [PersonVars]
namesParser = do
    students <- nameRow `sepEndBy` newline
    eof
    return $ zipWith (\i (name, vars) -> (i, name, vars)) [1..] students
