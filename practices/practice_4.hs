triple' = (3 *)

sign' x = 
    if x == 0
    then 0
    else x / abs x

fibonacci :: Integer -> Integer

fibonacci 1 = 1
fibonacci 2 = 1
fibonacci (-1) = (-1)
fibonacci (-2) = (-1)

fibonacci n
  | n > 0 = helper' 1 1 n
  | n < 0 = helper'' (1) (-1) n
  | otherwise = 0
  where
    helper' f s n =
      if n > 2
        then helper' s (f + s) (n - 1)
        else s

    helper'' f s n =
      if n < (-2)
        then helper'' s (f - s) (n + 1)
        else s


seqB :: Integer -> Integer
seqB n
    | n == 0 = 1
    | n == 1 = 2
    | n == 2 = 3
    | otherwise = helper 1 2 3 n
            where helper f s t n = 
                        if n - 3 >= 0
                        then helper (s) (t) (t - 2 * s + 3 * f) (n - 1)
                        else t


sum'n'count :: Integer -> (Integer, Integer)
sum'n'count x 
  | x == 0 = (0, 1)
  | otherwise = helper (0, 0) (abs x)
            where helper (sum, cnt) x = 
                    if x > 0
                    then helper (sum + (x `rem` 10), cnt + 1) (x `div` 10)
                    else (sum, cnt)


integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b = (h / 2) * helper 0 f (min a b) (max a b)
  where n = 1000*1000
        sign' = if a > b then (-1) else 1
        h = ((max a b) - (min a b)) / n
        helper sum f x limit =
          if x < limit
            then helper (sum + f x) f (x + h) limit
            else (2 * sum + f a + f b) * sign'