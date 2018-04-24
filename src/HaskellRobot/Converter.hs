-- | This module contains some utils to convert student variants into
-- string representation formatted in LaTeX properly with predefined template.

module HaskellRobot.Converter
       ( TexConverter
       , toTexCwVariant
       , toTexFile
       , toTexTheoryMin
       ) where

import           Data.Functor.Identity            (Identity)
import           Data.Monoid                      (mconcat, (<>))
import           Text.LaTeX.Base                  (LaTeX, LaTeXT, execLaTeXM, raw)

import           HaskellRobot.Data.ReifiedStudent (ReifiedStudent (..))
import           HaskellRobot.Data.Task           (Task (..))
import           HaskellRobot.Headers.Common      (cws, listOf, listItem, taskPreamble,
                                                   taskProblemWord, theoryMinEnd, theoryMinStart,
                                                   varEnd, varStart, documentOf)


type TexConverter = ReifiedStudent Task -> LaTeXT Identity ()

toTexCwVariant :: Int -> TexConverter
toTexCwVariant cwNum ReifiedStudent{..} = do
    varStart cwNum variant name
    taskList
    varEnd
  where
    currentCw :: Monad m => [LaTeXT m ()]
    currentCw = cws !! (cwNum - 1)

    taskList :: Monad m => LaTeXT m ()
    taskList = listOf (mconcat $ zipWith toProblem [1..] tasks)

    toProblem :: Monad m => Int -> Task -> LaTeXT m ()
    toProblem i Task{..} = do
        taskPreamble i
        taskHeader
        taskProblemWord
        raw taskContent
      where
        taskHeader = currentCw !! (i - 1)

toTexTheoryMin :: TexConverter
toTexTheoryMin ReifiedStudent{..} = do
    theoryMinStart name
    taskList
    theoryMinEnd
  where
    taskList :: Monad m => LaTeXT m ()
    taskList = listOf (mconcat (zipWith toProblem [1..] tasks))

    toProblem :: Monad m => Int -> Task -> LaTeXT m ()
    toProblem i Task{..} = listItem i <> raw taskContent

toTexFile :: TexConverter -> [ReifiedStudent Task] -> LaTeX
toTexFile toTex vars = execLaTeXM $ documentOf (mconcat $ map toTex vars)
