module HaskellRobot.Data.ReifiedStudent
       ( ReifiedStudent (..)
       ) where

import           Data.Text (Text)

-- | This student either contains number of tasks or real tasks
-- for his test.
data ReifiedStudent a = ReifiedStudent
    { variant :: Int
    , name    :: Text
    , tasks   :: [a]
    } deriving (Show)
