module HaskellRobot.Parsers.Common
       ( Parser
       ) where

import           Text.Megaparsec (Parsec)
import           Data.Void       (Void)
import           Data.Text       (Text)

type Parser = Parsec Void Text