-- | This module contains headers of tasks for CW2.

module HaskellRobot.Headers.CW2
       ( cw2taskHeads
       ) where

import           Text.LaTeX.Base (LaTeXT, texttt, (<>))

cw2head1 :: Monad m => LaTeXT m ()
cw2head1 = "Реализуйте требуемую функциональность из задания.\
\ Запрещается использовать " <> texttt "do" <> "-синтаксис.\n\n"

cw2head2 :: Monad m => LaTeXT m ()
cw2head2 = "Решите задачу, используя трансформеры монад. Можно не использовать трансформеры, но тогда балл будет сильно ниже. \
\Постарайтесь разделить чистый код и код с сайд-эффектами. Разрешается использовать " <> texttt "do" <> "-синтаксис. \
\Реализация также должна быть как можно более короткой и эффективной.\n\n"

-- | Task headers for cw2.
cw2taskHeads :: Monad m => [LaTeXT m ()]
cw2taskHeads = [cw2head1, cw2head2]
