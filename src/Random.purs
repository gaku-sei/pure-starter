module Random where

import Control.Monad.Eff (Eff)
import Data.Int (ceil, hexadecimal, toNumber, toStringAs)
import Prelude ((*), (<$>), (<<<), (<>))

foreign import data RANDOM :: !

type RandomEff a = forall fx. Eff (random :: RANDOM | fx) a

foreign import random :: RandomEff Number

randomInt :: Int -> RandomEff Int
randomInt n = ceil <<< (*) (toNumber n) <$> random

randomColor :: RandomEff String
randomColor = (<>) "#" <<< toStringAs hexadecimal <$> randomInt 0x1000000
