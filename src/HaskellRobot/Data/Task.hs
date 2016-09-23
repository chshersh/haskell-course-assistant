module HaskellRobot.Data.Task
       ( Task (..)
       , TaskId
       , TaskSet
       , TaskBlock
       ) where

type TaskId    = Int
type TaskSet   = [String]
type TaskBlock = [TaskSet]

-- | This data type holds task identificator and content of task itself.
data Task = Task
    { taskId      :: TaskId
    , taskContent :: String
    } deriving (Show)