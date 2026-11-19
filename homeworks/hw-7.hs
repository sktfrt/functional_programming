import Control.Applicative (ZipList(ZipList), getZipList)

infixl 5 >$<
infixl 5 >*<

f >$< xs = getZipList (fmap f (ZipList xs))
fls >*< xs = getZipList (ZipList fls <*> ZipList xs)


data Triple a = Tr a a a deriving (Eq,Show)

instance Functor Triple where
    fmap f (Tr x y z) = Tr (f x) (f y) (f z)

instance Applicative Triple where
    pure a = Tr a a a
    (<*>) (Tr f g h) (Tr x y z) = Tr (f x) (g y) (h z) 


data Tree a = Nil | Branch (Tree a) a (Tree a)   deriving (Eq, Show)

instance Functor Tree where
    fmap f Nil = Nil
    fmap f (Branch l x r) = Branch (fmap f l) (f x) (fmap f r)

instance Applicative Tree where
    pure a = let t = Branch t a t in t

    (<*>) Nil _ = Nil
    (<*>) _ Nil = Nil
    (<*>) (Branch l1 f r1) (Branch l2 x r2) = Branch (l1 <*> l2) (f x) (r1 <*> r2)


newtype Cmps f g x = Cmps { getCmps :: f (g x) }

instance (Functor f, Functor g) => Functor (Cmps f g) where
  fmap :: (a -> b) -> Cmps f g a -> Cmps f g b
  fmap f (Cmps x) = Cmps (fmap (fmap f) x)

instance (Applicative f, Applicative g) => Applicative (Cmps f g) where
  pure x = Cmps (pure (pure x))
  Cmps fg <*> Cmps x = Cmps (fmap (<*>) fg <*> x)  


divideList' :: (Show a, Fractional a) => [a] -> (String,a)
divideList' []     = ("1.0", 1)
divideList' (x:xs) = (/) <$> ("<-" ++ show x ++ "/", x) <*> divideList' xs


newtype Arr2 e1 e2 a = Arr2 { getArr2 :: e1 -> e2 -> a }
newtype Arr3 e1 e2 e3 a = Arr3 { getArr3 :: e1 -> e2 -> e3 -> a }

instance Functor (Arr2 e1 e2) where
  fmap f (Arr2 a) = Arr2 (\x y -> f (a x y))

instance Functor (Arr3 e1 e2 e3) where
  fmap f (Arr3 a) = Arr3 (\x y z -> f (a x y z))

instance Applicative (Arr2 e1 e2) where
  pure a = Arr2 (\_ _ -> a)
  (<*>) (Arr2 f) (Arr2 x) = Arr2 (\y z -> f y z (x y z))

instance Applicative (Arr3 e1 e2 e3) where
  pure a = Arr3 (\_ _ _ -> a)
  (<*>) (Arr3 f) (Arr3 x) = Arr3 (\y z w -> f y z w (x y z w))