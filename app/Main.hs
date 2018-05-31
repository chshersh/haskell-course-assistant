{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Data.Monoid ((<>))
import Options.Applicative (Parser, ParserInfo, action, argument, command, execParser, flag',
                            fullDesc, help, helper, hsubparser, info, long, metavar, progDesc, str,
                            (<|>))

import HaskellRobot.Converter (TexConverter, toTexCwVariant, toTexTheoryMin)
import HaskellRobot.Runner (TaskContext (..), generateTexFile)

data Command =
    Generate GenerateCommand

data GenerateCommand = GenerateCommand
    { documentType     :: GenerationType
    , studentsFileName :: FilePath
    , tasksFileName    :: FilePath
    , outputFolder     :: FilePath
    }

data GenerationType = TheoryMin | Test1 | Test2

generationType :: Parser GenerationType
generationType =
        flag' TheoryMin (long "theorymin" <> help "Generate theoretical minimum")
    <|> flag' Test1 (long "test1" <> help "Generate test 1")
    <|> flag' Test2 (long "test2" <> help "Generate test 2")

parserGenerate :: Parser GenerateCommand
parserGenerate = do
    documentType <- generationType
    studentsFileName <- argument str (
            metavar "STUDENTS_LIST_FILE" <> help "Path to a file with students list"
            <> action "file"
        )
    tasksFileName <- argument str (
            metavar "TASKS_LIST_FILE" <> help "Path to a file with tasks list"
            <> action "file"
        )
    outputFolder <- argument str (
            metavar "OUTPUT_DIR" <> help "Directory where .tex file will be generated"
            <> action "directory"
        )
    return GenerateCommand{..}

parserInfoGenerate :: ParserInfo GenerateCommand
parserInfoGenerate = info parserGenerate
    ( fullDesc
   <> progDesc "Generate LaTeX document of type TYPE" )

parserAll :: Parser Command
parserAll = hsubparser
    (
        command "generate" (info (Generate <$> parserGenerate) (progDesc "Generate LaTeX document"))
    )

parserInfoAll :: ParserInfo Command
parserInfoAll = info (helper <*> parserAll)
    ( fullDesc
   <> progDesc "Tools for simplifying FP-course maintenance and automate teaching processes" )

chooseTexConverter :: GenerationType -> TexConverter
chooseTexConverter TheoryMin = toTexTheoryMin
chooseTexConverter Test1     = toTexCwVariant 1
chooseTexConverter Test2     = toTexCwVariant 2

runCommand :: Command -> IO ()
runCommand (Generate GenerateCommand{ .. }) = do
    let converter = chooseTexConverter documentType
    generateTexFile TaskContext{ texConverter = converter, .. }

main :: IO ()
main = runCommand =<< execParser parserInfoAll
