module HaskellRobot.Converter
       (
       ) where

toTexCwVariant :: Int -> TexConverter
toTexCwVariant cwNum (P i name idx varText) = varStart cwNum i name ++ taskList ++ varEnd
  where
    taskList :: String
    taskList = listStart ++ concat (zipWith toProblem (selectByIndices idx (cws !! (cwNum - 1))) varText) ++ listEnd

    toProblem :: (Int, String) -> String -> String
    toProblem (i, preamble) statement = taskPreabmle i ++ preamble ++ taskProblemWord ++ statement ++ "\n" 

--toTexTheoryMin :: TexConverter
--toTexTheoryMin (P i name idx varText) = theoryMinStart i name ++ taskList ++ theoryMinEnd
--  where
--    taskList :: String
--    taskList = listStart ++ concat (zipWith toProblem idx varText) ++ listEnd
--
--    toProblem :: Int -> String -> String
--    toProblem i statement = listItem i ++ statement ++ "\n\n" ++ frameBox ++ "\n"   

toTexFile :: TexConverter -> [Person] -> String
toTexFile toTex vars = header ++ (vars >>= toTex) ++ end

readUtfTask :: FilePath -> IO String
readUtfTask path = do
    pathHandle <- openFile ("tasks" </> path) ReadMode
    hSetEncoding pathHandle utf8_bom
    hGetContents pathHandle
