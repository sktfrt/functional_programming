-- sum3 :: Num a => [a] -> [a] -> [a] -> [a]
-- sum3 (x:xs) (y:ys) (z:zs) = helper (0:0:0:[]) (x:xs) (y:ys) (z:zs)
--     where 
--         helper (acc1:acc2:acc3:[]) [] (y:ys) (z:zs)     = helper (acc1 + 0:acc2 + y:acc3 + z:[]) [] ys zs
--         helper (acc1:acc2:acc3:[]) (x:xs) [] (z:zs)     = helper (acc1 + x:acc2 + 0:acc3 + z:[]) xs [] zs
--         helper (acc1:acc2:acc3:[]) (x:xs) (y:ys) []     = helper (acc1 + x:acc2 + y:acc3 + 0:[]) xs ys []
--         helper (acc1:acc2:acc3:[]) [] [] (z:zs)         = helper (acc1 + 0:acc2 + 0:acc3 + z:[]) [] [] zs
--         helper (acc1:acc2:acc3:[]) [] (y:ys) []         = helper (acc1 + 0:acc2 + y:acc3 + 0:[]) [] ys []
--         helper (acc1:acc2:acc3:[]) (x:xs) [] []         = helper (acc1 + x:acc2 + 0:acc3 + 0:[]) xs [] []
--         helper (acc1:acc2:acc3:[]) [] [] []             = [acc1, acc2, acc3]
--         helper (acc1:acc2:acc3:[]) (x:xs) (y:ys) (z:zs) = helper (acc1 + x:acc2 + y:acc3 + z:[]) xs ys zs

sum3 :: Num a => [a] -> [a] -> [a] -> [a]
sum3' xs ys zs = helper [] xs ys zs
    where
        helper acc [] [] [] = acc
        helper acc [] (y:ys) [] = helper (acc ++ [y]) [] ys []
        helper acc [] [] (z:zs) = helper (acc ++ [z]) [] [] zs
        helper acc (x:xs) [] [] = helper (acc ++ [x]) xs [] []
        helper acc [] (y:ys) (z:zs) = helper (acc ++ [y + z]) [] ys zs
        helper acc (x:xs) [] (z:zs) = helper (acc ++ [x + z]) xs [] zs
        helper acc (x:xs) (y:ys) [] = helper (acc ++ [x + y]) xs ys [] 
        helper acc (x:xs) (y:ys) (z:zs) = helper (acc ++ [x + y + z]) xs ys zs

sum3 [] [] [] = []
sum3 (x:xs) [] [] = x : sum3 xs [] []
sum3 [] (y:ys) [] = y : sum3 [] ys []
sum3 [] [] (z:zs) = z : sum3 [] [] zs
sum3 (x:xs) (y:ys) [] = (x + y) : sum3 xs ys []
sum3 (x:xs) [] (z:zs) = (x + z) : sum3 xs [] zs
sum3 [] (y:ys) (z:zs) = (y + z) : sum3 [] ys zs
sum3 (x:xs) (y:ys) (z:zs) = (x + y + z) : sum3 xs ys zs


digits :: Integer -> [Integer]
-- digits 0 = [0]
-- digits x = helper [] x
--     where helper acc abs(x) = 
--             if x > 0
--             then helper (div x 10) : acc (mod x 10)
--             else acc

-- digits 0 = [0]
-- digits x = 
--     if firstDigit x' == 0
--         then [mod x' 10]
--         else firstDigit x : digits (mod x' 10)
--     where
--         firstDigit x'
--             | x' < 10 = x'
--             | otherwise = firstDigit (x' `div` 10)
        
--         x' = abs x

digits x = map (\c -> read [c]) (show (abs x))

containsAllDigits :: Integer -> Bool
containsAllDigits x = 
    if length (unique result) >= 9
        then True
        else False
    where result = [ z | z<-(digits x), y<-[1..9], z == y]
          unique [] = []
          unique (x:xs)
            | elem x xs = unique xs
            | otherwise = x : unique xs


containsAllDigitsOnes :: Integer -> Bool
containsAllDigitsOnes x = 
    if length (result) == 9
        then True
        else False
    where result = [ z | z<-(digits x), y<-[1..9], z == y]
        --   unique [] = []
        --   unique (x:xs)
        --     | elem x xs = unique xs
        --     | otherwise = x : unique xs


sublist :: Int -> Int -> [a] -> [a]
sublist _ _ [] = []
-- sublist' x y (z:zs) = helper [] 0 (z:zs)
--     where
--         helper acc cnt [] = reverse acc 
--         helper acc cnt (z:zs) = 
--             if x <= cnt && cnt < y
--                 then helper (z : acc) (cnt+1) zs
--                 else helper acc (cnt+1) zs

sublist x y (z:zs)
  | y <= 0 = []                     
  | x <= 0 = z : sublist 0 (y - 1) zs
  | otherwise = sublist (x - 1) (y - 1) zs


repeatEveryElem' :: Int -> [a] -> [a]
repeatEveryElem' _ [] = []
repeatEveryElem' cnt (x:xs) = helper [] cnt (x:xs)
    where 
        helper acc cnt [] = reverse acc
        helper acc cnt (z:zs) = helper ((repeater (cnt) [] z) ++ acc) cnt zs
        repeater cnt' acc x = 
                if cnt' <= 0
                    then acc
                    else repeater (cnt'-1) (x : acc) x

repeatEveryElem :: Int -> [a] -> [a]
repeatEveryElem _ [] = []
repeatEveryElem cnt (x:xs) = repeatN cnt x
  where
    repeatN n acc
      | n <= 0    = repeatEveryElem cnt xs
      | otherwise = acc : repeatN (n - 1) acc



-- movingLists :: Int -> [a] -> [[a]]
-- movingLists _ [] = []
-- movingLists num (x:xs) = repeatN num (x:xs) : movingLists num xs
--   where
--     repeatN _ [] = []
--     repeatN num' (z:zs)
--       | num' <= 0 = repeatEveryElem num' xs
--       | otherwise = z : repeatN (num' - 1) zs

movingLists :: Int -> [a] -> [[a]]
movingLists _ [] = []
movingLists num (x:xs)
  | length (repeatN num (x:xs)) == num = repeatN num (x:xs) : movingLists num xs
  | otherwise = []
  where    
    repeatN _ [] = []
    repeatN num' (z:zs)
      | num' <= 0 = []
      | otherwise = z : repeatN (num' - 1) zs