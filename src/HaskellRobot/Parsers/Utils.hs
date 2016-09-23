-- | This module adds some missing utils to MegaParsec.

module HaskellRobot.Parsers.Utils
       ( many1
       , spaces
       ) where

import           Control.Applicative    (liftA2)

import           Text.Megaparsec        (many, space)
import           Text.Megaparsec.String (Parser)

spaces :: Parser ()
spaces = () <$ many space

many1 :: Parser a -> Parser [a]
many1 p = liftA2 (:) p (many p)
