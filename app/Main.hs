module Main where

import           Control.Applicative    ((<**>))
import           Data.List              (find, intercalate)
import           Data.Monoid            ((<>))
import           Options.Applicative    (Parser, ParserInfo, ReadM, action, argument, command,
                                         completeWith, eitherReader, execParser, fullDesc, help,
                                         helper, info, metavar, progDesc, str, subparser)

import           HaskellRobot.Converter (TexConverter, toTexCwVariant, toTexTheoryMin)
import           HaskellRobot.Runner    (TaskContext (..), generateTexFile)

data Command =
    Generate GenerateCommand

data GenerateCommand = GenerateCommand
    { documentType     :: GenerationType
    , studentsFileName :: FilePath
    , tasksFileName    :: FilePath
    , outputFolder     :: FilePath
    }

data GenerationType = TheoryMin | Test1 | Test2

generationTypes :: [(String, GenerationType)]
generationTypes =
    [ ("theorymin", TheoryMin)
    , ("test1", Test1)
    , ("test2", Test2)
    ]

documentTypeNames :: String
documentTypeNames = intercalate ", " documentTypeNamesList
documentTypeNamesList :: [String]
documentTypeNamesList = fst <$> generationTypes

generationType :: ReadM GenerationType
generationType = eitherReader $ \arg ->
                     case find (\(name, _) -> name == arg) generationTypes of
                         Just (_, typ) -> Right typ
                         Nothing -> Left $ "No such document type: " ++ arg ++ ", valid types are "
                                           ++ documentTypeNames

parserGenerate :: Parser GenerateCommand
parserGenerate = GenerateCommand
    <$> argument generationType (
            metavar "TYPE" <> help ("type of generated document, one of " <> documentTypeNames)
            <> completeWith documentTypeNamesList
        )
    <*> argument str (
            metavar "STUDENTS_LIST_FILE" <> help "Path to a file with students list"
            <> action "file"
        )
    <*> argument str (
            metavar "TASKS_LIST_FILE" <> help "Path to a file with tasks list"
            <> action "file"
        )
    <*> argument str(
            metavar "OUTPUT_DIR" <> help "Directory where .tex file will be generated"
            <> action "directory"
        )

parserInfoGenerate :: ParserInfo GenerateCommand
parserInfoGenerate = info parserGenerate
    ( fullDesc
   <> progDesc "Generate LaTeX document of type TYPE" )

parserAll :: Parser Command
parserAll = subparser
    (
        command "generate" (info (Generate <$> parserGenerate) (progDesc "Generate LaTeX document"))
    )

parserInfoAll :: ParserInfo Command
parserInfoAll = info (parserAll <**> helper)
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
