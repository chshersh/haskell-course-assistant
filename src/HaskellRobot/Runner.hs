module Main where

import Control.Arrow ((&&&))

import Control.Monad.Random
import System.Random

import System.IO
import System.FilePath ((</>))

import ParseUtils
import Text.Parsec (parse)

import VariantHeaders

type TexConverter = Person -> String
type CwContext = (FilePath, FilePath, FilePath, TexConverter)
type TaskClone = ([String], [String])
type Variant   = [String]

data Person = P Int String [Int] Variant
              deriving (Show)

duplicate :: a -> (a, a)
duplicate = id &&& id

parseTasks :: String -> [TaskClone]
parseTasks s = case parse sectionsParser "" s of
                    Left e  -> error $ show e
                    Right v -> map duplicate v

parseNames :: String -> [PersonVars]
parseNames s = case parse namesParser "" s of
                    Left e  -> error $ show e
                    Right v -> v
                    
generateTexFile :: CwContext -> IO ()
generateTexFile (cwTasks, cwOutput, namesFile, toTex) = do
    namesString <- readUtfTask namesFile
    let names = parseNames namesString

    cw <- readUtfTask cwTasks
    let tasks = parseTasks cw
    variants <- evalRandIO (shuffleTasks names tasks)
    let texVariants = toTexFile toTex variants

    -- write result output
    withFile ("vars" </> cwOutput) WriteMode $ \cwVarsHandle -> do
        hSetEncoding cwVarsHandle utf8
        hPutStr cwVarsHandle texVariants
