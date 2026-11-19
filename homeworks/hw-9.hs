surround :: a -> a -> [a] -> [a]
surround x y zs = do 
  z <- zs
  [x, z, y]


lookups :: (Eq k) => k -> [(k,v)] -> [v]
lookups x ys = do 
  (k, v) <- ys
  if k == x then [v] else []


factor2 :: Integer -> [(Integer, Integer)]
factor2 n = do 
  x <- [1..floor (sqrt (fromIntegral n))]
  if (n `mod` x == 0) then [(x, n `div` x)] else []


absDiff :: Num a => [a] -> [a]
absDiff xs = do 
  (x, y) <- zip xs (drop 1 xs)
  [abs (x - y)]


data OddC a = Un a | Bi a a (OddC a) deriving (Eq,Show)


concat3OC :: OddC a -> OddC a -> OddC a -> OddC a
concat3OC = 
  \x y z -> case x of
    Un a -> case y of
      Un b -> Bi a b z
      Bi b c ys -> Bi a b (concat3OC (Un c) ys z)
    Bi a b xs -> case y of
      Un c -> Bi a b (concat3OC xs (Un c) z)
      Bi c d ys -> Bi a b (concat3OC xs (Bi c d ys) z)


concatOC :: OddC (OddC a) -> OddC a
concatOC = 
  \x -> case x of
    Un a -> a
    Bi a b xs -> concat3OC a b (concatOC xs)


instance Functor OddC where
  fmap f x = case x of
    Un a -> Un (f a)
    Bi a b xs -> Bi (f a) (f b) (fmap f xs)

instance Applicative OddC where
  pure = Un
  mf <*> mx = mf >>= (\f -> fmap f mx)

instance Monad OddC where
  return = pure
  m >>= k = concatOC (fmap k m)
  