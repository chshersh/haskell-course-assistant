module HaskellRobot.Headers.Common
       ( cws
       , varStart
       , varEnd

       , listItem
       , listOf
       , frameBox

       , taskPreamble
       , taskProblemWord

       , theoryMinStart
       , theoryMinEnd

       , documentOf
       ) where

import           Data.Monoid                  ((<>))
import           Data.Text                    (Text, pack)
import           Formatting                   (int, sformat, (%))
import           Text.LaTeX.Base              (ClassOption (FontSize, Paper), LaTeXT, Measure (Pt),
                                               PaperType (A4), article, center, centering, comment,
                                               document, documentclass, enumerate, item, large2,
                                               large3, pagebreak, pagenumbering, protectText, raw,
                                               textbf, textit, texttt, usepackage)
import           Text.LaTeX.Base.Class        (LaTeXC, fromLaTeX, liftL)
import           Text.LaTeX.Base.Syntax       (LaTeX(TeXComm, TeXEnv, TeXEmpty),
                                               TeXArg(FixArg, MParArg, OptArg))
import           Text.LaTeX.Packages.Inputenc (inputenc, utf8)
import           Text.LaTeX.Packages.Graphicx (IGOption(IGWidth), includegraphics)

import           HaskellRobot.Headers.CW1     (cw1taskHeads)
import           HaskellRobot.Headers.CW2     (cw2taskHeads)

cws :: Monad m => [[LaTeXT m ()]]
cws = [cw1taskHeads, cw2taskHeads]

-- variants begin * end
varStart :: Monad m => Int -> Int -> Text -> LaTeXT m ()
varStart cw i name = do
    comment (sformat ("\n Вариант "%int%"\n\n") i); "\n"
    center $ do
        "\n"
        "  "; textbf $ do
            large3 $ raw $ sformat ("Вариант " % int % " (КР " % int % ")") i cw
            " "; linebreak
        "\n\n  "; raw $ protectText name; "\n"
    "\n\n\
     \Для каждого задания требуется также придумать несколько разумных тестов. \
     \Хорошие тесты могут улучшить оценку задания. Также требуется перед каждой задачей в комментарии писать текст задания \
     \(можно коротко, главное, чтобы было понятно, какое задание). Ваша контрольная работа должна быть \
     \оформлена как stack проект. Тесты пишите в соответствующем Main модуле. Их должно быть возможно запустить \
     \при помощи команды " <> texttt "stack exec" <> ". Требуется соблюдать все замечания к текущим домашним заданиям.\n\
     \\n"
    image "images/bord3.png"

varEnd :: Monad m => LaTeXT m ()
varEnd = image "images/bord4.png" <> pagebreak "4" <> "\n\n"

image :: Monad m => String -> LaTeXT m ()
image path = do
    figureH $ do
        "\n"
        "  "; centering; "\n"
        "  "; includegraphics [IGWidth $ Pt 500] path; "\n"
    "\n\n"
  where
    figureH :: LaTeXC l => l -> l
    figureH = liftL $ \content -> TeXEnv "figure" [ OptArg "H" ] content

listOf :: Monad m => LaTeXT m () -> LaTeXT m ()
listOf content = enumerate (content <> "\n") <> "\n\n"

listItem :: Monad m => Int -> LaTeXT m ()
listItem i = "\n  " <> item (Just $ raw $ pack $ show i <> ".") <> "\n"

taskPreamble :: Monad m => Int -> LaTeXT m ()
taskPreamble i = listItem i <> "  " <> textbf (textit "Условие:") <> "\n\n"

taskProblemWord :: Monad m => LaTeXT m ()
taskProblemWord = "  " <> textbf (textit "Задача:") <> "\n\n"

-- | Theory min specific header
theoryMinStart :: Monad m => Text -> LaTeXT m ()
theoryMinStart name = do
    center $ title name
    "\n\n"
  where
    title :: Monad m => Text -> LaTeXT m ()
    title subtitle = do
        "\n"
        "    "; textbf (large2 "Теоретический минимум" <> " " <> linebreak); "\n\n"
        "    "; raw $ protectText subtitle; "\n"


theoryMinEnd :: Monad m => LaTeXT m ()
theoryMinEnd = pagebreak "4" <> "\n\n"

linebreak :: Monad m => LaTeXT m ()
linebreak = raw "\\\\"

frameBox :: Monad m => LaTeXT m ()
frameBox = fromLaTeX $ TeXComm "framebox" [MParArg ["500", "60"], FixArg TeXEmpty]

documentOf :: Monad m => LaTeXT m () -> LaTeXT m ()
documentOf content = do
    documentclass [FontSize $ Pt 11, Paper A4] article; "\n"
    "\n"
    usepackage [] "fullpage"; "\n"
    usepackage [utf8] inputenc; "\n"
    usepackage ["russian"] "babel"; "\n"
    usepackage [] "graphicx"; "\n"
    usepackage [] "float"; "\n"
    usepackage ["stable"] "footmisc"; "\n"
    usepackage [] "caption"; "\n"
    usepackage [] "subcaption"; "\n"
    usepackage [] "url"; "\n"
    usepackage [] "amsmath"; "\n"
    usepackage [] "amssymb"; "\n"
    usepackage [] "listings"; "\n"
    "\n"
    usepackage ["margin=0.4in"] "geometry"; "\n"
    "\n"
    raw "\\setlength\\parindent{0pt}\n"; "\n"
    pagenumbering "gobble"; "\n"
    "\n"
    document ("\n\n" <> content)
