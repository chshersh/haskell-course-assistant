module HaskellRobot.Headers.Common
       ( cws
       , varStart
       , varEnd

       , listStart
       , listItem
       , listEnd

       , taskPreamble
       , taskProblemWord

       , documentHeader
       , documentEnd
       ) where

import           Data.Text                (Text)
import           Formatting               (int, sformat, stext, (%))

import           HaskellRobot.Headers.CW1 (cw1taskHeads)
import           HaskellRobot.Headers.CW2 (cw2taskHeads)

cws :: [[Text]]
cws = [cw1taskHeads, cw2taskHeads]

-- variants begin * end
varStart :: Int -> Int -> Text -> Text
varStart cw i name = sformat ("\
\%\n\
\% Вариант " % int % "\n\
\%\n\
\\n\
\\\begin{center}\n\
\  \\textbf{\\LARGE{Вариант " % int % " (КР " % int % ")} \\\\}\n\
\\n\
\  " % stext % "\n\
\\\end{center}\n\
\\n\
\Для каждого задания требуется также придумать несколько разумных тестов. \
\Хорошие тесты могут улучшить оценку задания. Также требуется перед каждой задачей в комментарии писать текст задания \
\(можно коротко, главное, чтобы было понятно, какое задание). Ваша контрольная работа должна быть \
\оформлена как stack проект. Тесты пишите в соответствующем Main модуле. Их должно быть возможно запустить \
\при помощи команды \\texttt{stack exec}. Требуется соблюдать все замечания к текущим домашним заданиям.\n\
\\n\
\\\begin{figure}[H]\n\
\  \\centering\n\
\  \\includegraphics[width=500pt]{images/bord3.png}\n\
\\\end{figure}\n\n")
    i i cw name

varEnd :: Text
varEnd = "\
\\\begin{figure}[H]\n\
\  \\centering\n\
\  \\includegraphics[width=500pt]{images/bord4.png}\n\
\\\end{figure}\n\
\\n\
\\\pagebreak\n\n"

-- variant list constants
listStart :: Text
listStart = "\\begin{enumerate}\n"

listEnd :: Text
listEnd = "\\end{enumerate}\n\n"

listItem :: Int -> Text
listItem = sformat ("  \\item[" % int % ".]\n")

taskPreamble :: Int -> Text
taskPreamble i = sformat
    (stext % "  \\textbf{\\textit{Условие:}}\n\n")
    (listItem i)

taskProblemWord :: Text
taskProblemWord = "  \\textbf{\\textit{Задача:}}\n\n"

-- theory min specific header
-- theoryMinStart :: Int -> String -> String
-- theoryMinStart i name = "\
-- \\\begin{center}\n\
-- \    \\textbf{\\Large{Теоретический минимум} \\\\}\n\
-- \\n\
-- \    " <> name <> " (вариант " <> show i <> ")\n\
-- \\\end{center}\n\n"
--
-- theoryMinEnd :: String
-- theoryMinEnd = "\\pagebreak\n\n"
--
-- frameBox :: String
-- frameBox = "\\framebox(500,35){}"

-- tex document begin & end
documentHeader :: Text
documentHeader = "\\documentclass[11pt,a4paper]{article}\n\
\\n\
\\\usepackage{fullpage}\n\
\\\usepackage[utf8]{inputenc}\n\
\\\usepackage[russian]{babel}\n\
\\\usepackage{graphicx}\n\
\\\usepackage{float}\n\
\\\usepackage[stable]{footmisc}\n\
\\\usepackage{caption}\n\
\\\usepackage{subcaption}\n\
\\\usepackage{url}\n\
\\\usepackage{amsmath}\n\
\\\usepackage{amssymb}\n\
\\\usepackage{listings}\n\
\\n\
\\\usepackage[margin=0.3in]{geometry}\n\
\\n\
\\\setlength\\parindent{0pt}\n\
\\n\
\\\pagenumbering{gobble}\n\
\\n\
\\\begin{document}\n\n"

documentEnd :: Text
documentEnd = "\\end{document}"
