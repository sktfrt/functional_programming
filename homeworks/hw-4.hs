import Data.Complex

-- Task 1
newtype Matrix a = Matrix [[a]]

instance Show a => Show (Matrix a) where
    showsPrec _ (Matrix []) = showString "EMPTY"
    showsPrec _ (Matrix [x]) = showList x
    showsPrec _ (Matrix (x:xs)) = (showList x) . showString "\n" . (helper (Matrix xs))
        where helper (Matrix []) = id
              helper (Matrix [x]) = showList x
              helper (Matrix (x:xs)) = showList x . showString "\n" . helper (Matrix xs)


-- Task 2
newtype Cmplx = Cmplx (Complex Double) deriving Eq

instance Show Cmplx where
    showsPrec _ (Cmplx (r :+ i)) = shows r . (if signum i == -1 then showString "-" else showString "+") . showString "i*" . shows (abs i)

instance Read Cmplx where
    readsPrec _ num =
        case reads num of
            [(r, '+' : 'i' : '*' : rest)] ->
                case reads rest of
                    [(i, trash)] -> [(Cmplx (r :+ i), trash)]
                    _ -> []
            [(r, '-' : 'i' : '*' : rest)] ->
                case reads rest of
                    [(i, trash)] -> [(Cmplx (r :+ (-i)), trash)]
                    _ -> []
            _ -> []


-- Task 3
class (Eq a, Enum a, Bounded a) => SafeEnum a where
    ssucc :: a -> a
    spred :: a -> a

    ssucc x = if x == maxBound then minBound else succ x
    spred x = if x == minBound then maxBound else pred x

instance SafeEnum Bool
instance SafeEnum Char


-- Task 4
rotate :: Int -> [a] -> [a]
rotate n xs
    | n >= 0 = drop n xs ++ take n xs
    | otherwise = drop m xs ++ take m xs

    where
        m = length xs + n


-- Task 5
comb :: Int -> [a] -> [[a]]
comb 0 _ = [[]]
comb _ [] = []
comb n (x:xs) = map (x:) (comb (n - 1) xs) ++ comb n xs