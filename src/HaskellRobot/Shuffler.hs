module HaskellRobot.Shuffler
       (
       ) where

selectByIndices :: [Int] -> [a] -> [(Int, a)]
selectByIndices idx = filter ((`elem` idx) . fst) . zip [1..]

shuffleTasks :: [PersonVars] -> [TaskClone] -> Rand StdGen [Person]
shuffleTasks [] _ = return []
shuffleTasks ((pid, name, varNums) : ps) tasks = do
    let resVars = if null varNums then [1..length tasks] else varNums
    let selectedTasks = selectByIndices resVars tasks
    let taskLengths = map (length . fst . snd) selectedTasks

    taskNumbers <- mapM (\i -> getRandomR (0, i - 1)) taskLengths
    let newTasksWithVars = zipWith generateVar taskNumbers selectedTasks

    let (varText, newSelectedTasks) = map fst &&& map snd $ newTasksWithVars
    let updatedTasks = foldr updateTask tasks newSelectedTasks

    (P pid name resVars varText :) <$> shuffleTasks ps updatedTasks
  where
    generateVar :: Int -> (Int, TaskClone) -> (String, (Int, TaskClone))
    generateVar i (pos, (t, backup)) = let (xs, v:ys) = splitAt i t
                                           remVars = xs ++ ys
                                       in if null remVars 
                                          then (v, (pos, duplicate backup)) 
                                          else (v, (pos, (remVars, backup)))

    updateTask :: (Int, TaskClone) -> [TaskClone] -> [TaskClone]
    updateTask (i, newTask) oldTasks = let (xs, _:ys) = splitAt (i - 1) oldTasks
                                       in xs ++ (newTask:ys)
