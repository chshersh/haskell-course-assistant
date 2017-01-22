-- | This module contains some utils to convert student variants into
-- string representation formatted in LaTeX properly with predefined template.

module HaskellRobot.Converter
       ( TexConverter
       , toTexCwVariant
       , toTexFile
       , toTexTheoryMin
       ) where

import           Data.Monoid                      (mconcat, (<>))
import           Data.Text                        (Text)
import           Formatting                       (sformat, stext, (%))

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (Task (..))
import           HaskellRobot.Headers.Common      (cws, documentEnd, documentHeader,
                                                   frameBox, listEnd, listItem, listStart,
                                                   taskPreamble, taskProblemWord,
                                                   theoryMinEnd, theoryMinStart, varEnd,
                                                   varStart)

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
        sformat (stext % stext % stext % stext % "\n")
                (taskPreamble i)
                taskHeader
                taskProblemWord
                taskContent
      where
        taskHeader = currentCw !! (i - 1)

toTexTheoryMin :: TexConverter
toTexTheoryMin ReifiedStudent{..} = theoryMinStart name <> taskList <> theoryMinEnd
  where
    taskList :: Text
    taskList = listStart <> mconcat (zipWith toProblem [1..] tasks) <> listEnd

    toProblem :: Int -> Task -> Text
    toProblem i Task{..} = listItem i <> taskContent <> "\n"

toTexFile :: TexConverter -> [ReifiedStudent Task] -> Text
toTexFile toTex vars = sformat (stext % stext % stext)
                               documentHeader
                               (mconcat $ map toTex vars)
                               documentEnd
