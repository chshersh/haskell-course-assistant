module HaskellRobot.Data.Task
       ( Task (..)
       , TaskId
       , TaskSet
       , TaskBlock
       ) where

import           Data.Text (Text)

type TaskId    = Int
type TaskSet   = [Text]
type TaskBlock = [TaskSet]

-- | This data type holds task identificator and content of task itself.
data Task = Task
    { taskId      :: TaskId
    , taskContent :: Text
    } deriving (Show)
