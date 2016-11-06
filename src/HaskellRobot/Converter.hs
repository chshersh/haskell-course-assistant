-- | This module contains some utils to convert student variants into
-- string representation formatted in LaTeX properly with predefined template.

module HaskellRobot.Converter
       ( TexConverter
       , toTexCwVariant
       , toTexFile
       ) where

import           Data.Monoid                      (mconcat)
import           Data.Text                        (Text)
import           Formatting                       (sformat, stext, (%))

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (Task (..))
import           HaskellRobot.Headers.Common      (cws, documentEnd, documentHeader,
                                                   listEnd, listStart, taskPreamble,
                                                   taskProblemWord, varEnd, varStart)

type TexConverter = ReifiedStudent Task -> Text

toTexCwVariant :: Int -> TexConverter
toTexCwVariant cwNum ReifiedStudent{..} =
    sformat (stext % stext % stext)
            (varStart cwNum variant name)
            taskList
            varEnd
  where
    currentCw :: [Text]
    currentCw = cws !! (cwNum - 1)

    taskList :: Text
    taskList = sformat (stext % stext % stext)
                       listStart
                       (mconcat $ zipWith toProblem [1..] tasks)
                       listEnd

    toProblem :: Int -> Task -> Text
    toProblem i Task{..} =
        sformat (stext % stext % stext % stext % stext)
                (taskPreamble i)
                taskHeader
                taskProblemWord
                taskContent
                "\n"
      where
        taskHeader = currentCw !! (i - 1)

--toTexTheoryMin :: TexConverter
--toTexTheoryMin (P i name idx varText) = theoryMinStart i name ++ taskList ++ theoryMinEnd
--  where
--    taskList :: String
--    taskList = listStart ++ concat (zipWith toProblem idx varText) ++ listEnd
--
--    toProblem :: Int -> String -> String
--    toProblem i statement = listItem i ++ statement ++ "\n\n" ++ frameBox ++ "\n"

toTexFile :: TexConverter -> [ReifiedStudent Task] -> Text
toTexFile toTex vars = sformat (stext % stext % stext)
                               documentHeader
                               (mconcat $ map toTex vars)
                               documentEnd
