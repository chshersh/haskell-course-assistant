{-# LANGUAGE ViewPatterns #-}

module Main where

import           System.Environment     (getArgs)

import           HaskellRobot.Converter (toTexCwVariant)
import           HaskellRobot.Runner    (TaskContext (..), generateTexFile)

main :: IO ()
main = do
    -- TODO: use optparse-applicative
    [read -> n, studentsFileName, tasksFileName, outputFolder] <- getArgs
    generateTexFile TaskContext{ texConverter = toTexCwVariant n, .. }
