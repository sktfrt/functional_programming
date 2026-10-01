import GHC.Internal.Data.Tuple (swap)
numsFrom n = n : numsFrom(n + 1)

countEvens [] = 0
countEvens (x:xs) 
    | even x = 1 + countEvens xs
    | otherwise = countEvens xs


odds [] = 0
odds (x:xs) 
    | odd x = 1 + odds xs
    | otherwise = odds xs


-- swapPairs [] = []
-- swapPairs (x:xs) = 
--     if ((length (x:xs)) `mod` 2 == 0)
--     then swap (take 2 (x:xs))
--     else take 1 (x:xs)

swapPairs [] = []
swapPairs [x] = [x]
swapPairs (x:y:xs) = y : x : swapPairs(xs)

reverse'' []     = []
reverse'' (x:xs) = reverse'' xs ++ [x]

reverse' = helper [] where
    helper acc [] = acc
    helper acc (x:xs) = helper (x:acc) xs