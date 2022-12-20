module Day20
  ( day20,
  )
where

import Common
import Control.Monad.State
import Data.Maybe (fromJust)
import Data.Vector qualified as V

day20 :: AOCSolution
day20 input = show . go <$> [(1, i, s), (10, i', s)]
  where
    i = parseInput input
    i' = (* 811589153) <$> i
    s = V.fromList [0 .. pred $ length i]

parseInput :: String -> V.Vector Int
parseInput = V.fromList . map read . lines

removeAtN :: Int -> V.Vector a -> V.Vector a
removeAtN n v = a V.++ V.tail b
  where
    (a, b) = V.splitAt n v

insertAtN :: Int -> a -> V.Vector a -> V.Vector a
insertAtN 0 a v = v V.++ V.fromList [a]
insertAtN n a v = l V.++ V.cons a r
  where
    (l, r) = V.splitAt n v

go :: (Int, V.Vector Int, V.Vector Int) -> Int
go (0, i, s) = solve i s
go (t, i, s) = go (pred t, i, decrypt i s)

decrypt :: V.Vector Int -> V.Vector Int -> V.Vector Int
decrypt i = execState (traverse run zpd)
  where
    l = pred $ V.length i
    inds = V.fromList [0 .. l]
    zpd = V.zip inds i
    run :: (Int, Int) -> State (V.Vector Int) ()
    run (i, n) = do
      inds <- get
      let j = fromJust $ i `V.elemIndex` inds
          inds' = removeAtN j inds
          n' = (l + j + n) `mod` l
      put $ insertAtN n' i inds'
      pure ()

solve :: V.Vector Int -> V.Vector Int -> Int
solve n v = sum $ (n V.!) . (v V.!) . (`mod` V.length v) . (+ z) <$> [1000, 2000, 3000]
  where
    z = fromJust $ V.elemIndex 0 n >>= (`V.elemIndex` v)