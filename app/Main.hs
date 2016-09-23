module Main where

import HaskellRobot.Runner (generateTexFile)

main :: IO ()
main = mapM_ generateTexFile [ --("cw1.tex", "cw1-variants.tex", "cw1names.txt", toTexCwVariant 1)
                             --, ("cw2.tex", "cw2-variants.tex", "cw2names.txt", toTexCwVariant 2)
                              ("theory-min-2.tex", "theory-min-variants-2.tex", "theory-min-names-2.txt", toTexTheoryMin)
                             ]
