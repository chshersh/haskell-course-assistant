-- | This module contains some utils to convert student variants into
-- string representation formatted in LaTeX properly with predefined template.

module HaskellRobot.Converter
       ( TexConverter
       , toTexCwVariant
       , toTexFile
       ) where

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (Task (..))
import           HaskellRobot.Headers.Common      (cws, documentEnd, documentHeader,
                                                   listEnd, listStart, taskPreamble,
                                                   taskProblemWord, varEnd, varStart)

type TexConverter = ReifiedStudent Task -> String

toTexCwVariant :: Int -> TexConverter
toTexCwVariant cwNum ReifiedStudent{..} = varStart cwNum variant name ++ taskList ++ varEnd
  where
    currentCw :: [String]
    currentCw = cws !! (cwNum - 1)

    taskList :: String
    taskList =    listStart
               ++ concat (map toProblem $ zip [1..] tasks)
               ++ listEnd

    toProblem :: (Int, Task) -> String
    toProblem (i, Task{..}) =
           taskPreamble i
        ++ taskHeader
        ++ taskProblemWord
        ++ taskContent
        ++ "\n"
      where
        taskHeader = currentCw !! taskId

--toTexTheoryMin :: TexConverter
--toTexTheoryMin (P i name idx varText) = theoryMinStart i name ++ taskList ++ theoryMinEnd
--  where
--    taskList :: String
--    taskList = listStart ++ concat (zipWith toProblem idx varText) ++ listEnd
--
--    toProblem :: Int -> String -> String
--    toProblem i statement = listItem i ++ statement ++ "\n\n" ++ frameBox ++ "\n"

toTexFile :: TexConverter -> [ReifiedStudent Task] -> String
toTexFile toTex vars = documentHeader ++ (vars >>= toTex) ++ documentEnd

-- readUtfTask :: FilePath -> IO String
-- readUtfTask path = do
--     pathHandle <- openFile ("tasks" </> path) ReadMode
--     hSetEncoding pathHandle utf8_bom
--     hGetContents pathHandle
