module HaskellRobot.Shuffler
       ( assignRandomTasks
       ) where

import           Control.Monad                    (join)
import           Control.Monad.Random             (Rand, StdGen, getRandomR)

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (Task (..), TaskBlock, TaskId, TaskSet)

data ExhaustingTask = ExhaustingTask
    { remains  :: TaskSet
    , fullCopy :: TaskSet
    } deriving (Show)

type BackupWithNumber = (Int, ExhaustingTask)

selectByIndices :: [Int] -> [ExhaustingTask] -> [BackupWithNumber]
selectByIndices idx = filter ((`elem` idx) . fst) . zip [1..]

restoreBackup :: ExhaustingTask -> ExhaustingTask
restoreBackup et@ExhaustingTask{..} = et { remains = fullCopy }

-- | TODO: rewrite with State transformer
shuffleTasks
    :: [ReifiedStudent TaskId]
    -> [ExhaustingTask]
    -> Rand StdGen [ReifiedStudent Task]
shuffleTasks                                        []         _ = pure []
shuffleTasks (ReifiedStudent variant name taskIds : ss) taskPool = do
    let totalTasks    = if null taskIds then [1..length taskPool] else taskIds
    let selectedTasks = selectByIndices totalTasks taskPool
    let taskLengths   = map (length . remains . snd) selectedTasks

    taskNumbers <- mapM (\i -> getRandomR (0, i - 1)) taskLengths
    let newTasksWithVars = zipWith generateVar taskNumbers selectedTasks

    let (tasks, newSelectedTasks) = unzip newTasksWithVars
    let updatedTasks = foldr updateTaskPool taskPool newSelectedTasks

    (ReifiedStudent{..} :) <$> shuffleTasks ss updatedTasks
  where
    generateVar :: Int -> BackupWithNumber -> (Task, BackupWithNumber)
    generateVar i (taskId, et@ExhaustingTask{..}) =
        let (xs, chosenContent:ys) = splitAt i remains
            chosenTask             = Task i chosenContent
            remTasks               = xs ++ ys
        in if null remTasks  -- TODO: this looks very ugly; need to refactor
           then (chosenTask, (taskId, restoreBackup et))
           else (chosenTask, (taskId, ExhaustingTask{ remains = remTasks, ..}))

    updateTaskPool :: (Int, ExhaustingTask) -> [ExhaustingTask] -> [ExhaustingTask]
    updateTaskPool (taskId, updatedTask) oldTasks =
        let (xs, _:ys) = splitAt (taskId - 1) oldTasks
        in xs ++ (updatedTask:ys)

-- | Select random tasks for each student from given list of tasks.
assignRandomTasks
    :: [ReifiedStudent TaskId]
    -> TaskBlock
    -> Rand StdGen [ReifiedStudent Task]
assignRandomTasks students tasks = do
    let clonedTasks = map (join ExhaustingTask) tasks
    shuffleTasks students clonedTasks
