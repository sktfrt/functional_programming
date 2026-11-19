import Control.Applicative

data Triple a = Tr a a a  deriving (Eq,Show)

instance Functor Triple where
    fmap f (Tr x y z) = Tr (f x) (f y) (f z)

instance Applicative Triple where
    pure a = Tr a a a
    (<*>) (Tr f g h) (Tr x y z) = Tr (f x) (g y) (h z) 

instance Foldable Triple where 
    foldMap f (Tr x y z) = f x <> f y <> f z

instance Traversable Triple where
    sequenceA (Tr x y z) = Tr <$> x <*> y <*> z


data Tree a = Nil | Branch (Tree a) a (Tree a)   deriving (Eq, Show)

instance Functor Tree where
    fmap f Nil = Nil
    fmap f (Branch l x r) = Branch (fmap f l) (f x) (fmap f r)

instance Applicative Tree where
    pure a = let t = Branch t a t in t

    (<*>) Nil _ = Nil
    (<*>) _ Nil = Nil
    (<*>) (Branch l1 f r1) (Branch l2 x r2) = Branch (l1 <*> l2) (f x) (r1 <*> r2)

instance Foldable Tree where
    foldMap f Nil = mempty
    foldMap f (Branch l x r) = foldMap f l <> f x <> foldMap f r

instance Traversable Tree where
    sequenceA Nil = pure Nil
    sequenceA (Branch l x r) = Branch <$> sequenceA l <*> x <*> sequenceA r


newtype Cmps f g x = Cmps { getCmps :: f (g x) } deriving (Eq,Show) 

instance (Functor f, Functor g) => Functor (Cmps f g) where
  fmap :: (a -> b) -> Cmps f g a -> Cmps f g b
  fmap f (Cmps x) = Cmps (fmap (fmap f) x)

instance (Applicative f, Applicative g) => Applicative (Cmps f g) where
  pure x = Cmps (pure (pure x))
  Cmps fg <*> Cmps x = Cmps (fmap (<*>) fg <*> x)  

instance (Foldable f, Foldable g) => Foldable (Cmps f g) where
    foldMap f (Cmps x) = foldMap (foldMap f) x

instance (Traversable f, Traversable g) => Traversable (Cmps f g) where
    sequenceA (Cmps x) = Cmps <$> sequenceA (fmap sequenceA x)


newtype Parser a = Parser { apply :: String -> [(a, String)] }

parse :: Parser a -> String -> [a]
parse p = map fst . filter (null . snd) . apply p

instance Functor Parser where
  fmap f (Parser x) = Parser (\s -> map (\(res, rest) -> (f res, rest) ) (x s))

instance Applicative Parser where
  pure x = Parser (\s -> [(x, s)])
  (<*>) (Parser f) (Parser x) = Parser (\s -> concatMap (\(g, s') -> map (\(y, s'') -> (g y, s'')) (x s')) (f s))

instance Alternative Parser where
  empty = Parser (\s -> [])
  (<|>) (Parser x) (Parser y) = Parser (\s -> x s ++ y s)


class Functor f => Monoidal f where
  unit  :: f ()
  (*&*) :: f a -> f b -> f (a,b)

instance Monoidal [] where
  unit = [()]
  xs *&* ys = [ (x,y) | x <- xs, y <- ys ]
  
instance Monoidal ZipList where
  unit = ZipList (repeat ())
  (ZipList xs) *&* (ZipList ys) = ZipList (zip xs ys)

instance Monoidal Maybe where
  unit = Just ()
  (*&*) Nothing _ = Nothing
  (*&*) _ Nothing = Nothing
  (*&*) (Just x) (Just y) = Just (x,y)

instance Monoid s => Monoidal ((,) s) where
  unit = (,) mempty ()
  (*&*) (s1, x) (s2, y) = (s1 <> s2, (x,y))

instance Monoidal ((->) e) where
  unit = \_ -> ()
  (*&*) f g = \x -> (f x, g x)

unit' :: Applicative f => f ()
unit' = pure ()

pair' :: Applicative f => f a -> f b -> f (a,b)
pair' = liftA2 (,)

pure' :: Monoidal f => a -> f a
pure' x = fmap (const x) unit

ap' :: Monoidal f => f (a -> b) -> f a -> f b
ap' fg fx = fmap (\(g, x) -> g x) (fg *&* fx)