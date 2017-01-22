{-# LANGUAGE ViewPatterns #-}

module Main where

import           Data.Text              (Text)
import qualified Data.Text.IO           as TIO
import           Formatting             (int, sformat, (%))
import           System.Environment     (getArgs)

import           HaskellRobot.Converter (TexConverter, toTexCwVariant, toTexTheoryMin)
import           HaskellRobot.Runner    (TaskContext (..), generateTexFile)

chooseTexConverter :: Int -> Either Text TexConverter
chooseTexConverter 0 = Right   toTexTheoryMin
chooseTexConverter 1 = Right $ toTexCwVariant 1
chooseTexConverter 2 = Right $ toTexCwVariant 2
chooseTexConverter n = Left  $ sformat ("Not known cw mode: "%int) n

main :: IO ()
main = do
    -- TODO: use optparse-applicative
    [read -> n, studentsFileName, tasksFileName, outputFolder] <- getArgs
    let converter = chooseTexConverter n
    either
        TIO.putStrLn
        (\tc -> generateTexFile TaskContext{ texConverter = tc, .. })
        converter
