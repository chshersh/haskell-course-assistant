module HaskellRobot.Data.ReifiedStudent
       ( ReifiedStudent (..)
       ) where

-- | This student either contains number of tasks or real tasks
-- for his test.
data ReifiedStudent a = ReifiedStudent
    { variant :: Int
    , name    :: String
    , tasks   :: [a]
    } deriving (Show)
