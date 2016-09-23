-- | This module contains headers of tasks for CW1.

module HaskellRobot.Headers.CW1
       ( cw1taskHeads
       ) where

cw1task1 :: String
cw1task1 = "Написать функцию в две строки: тип в наиболее общем виде и реализация. \
\Реализация должна быть максимально короткой. Нельзя использвать другие пакеты кроме \
\\\texttt{Prelude}, \\texttt{Data.List}, \\texttt{Data.Char}, \\texttt{Data.Map}, \\texttt{Data.Tree}.\n\n"

cw1task2 :: String
cw1task2 = "Как в прошлом задании, только реализация может занимать произвольное число строк, \
\хотя для максимального балла требуется наиболее короткая (форматирование и длина имён переменных не учитывается). \
\Решение должно быть асимптотически эффективным, причём скрытую константу в асимптотике \
\тоже желательно уменьшить, насколько это возможно.\n\n"

cw1task3 :: String
cw1task3 = "Реализовать структуру данных.\n\n"

cw1task4 :: String
cw1task4 = "Придумать и реализовать заданный тайпкласс.\n\n"

cw1taskHeads :: [String]
cw1taskHeads = [ cw1task1
               , cw1task2
               , cw1task3
               , cw1task4
               ]
