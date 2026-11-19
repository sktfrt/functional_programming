import Control.Applicative (Alternative(..))
import Data.Char

{-# LANGUAGE InstanceSigs #-}

data Result a = Ok a | Error String 
  deriving (Eq,Show)

instance Functor Result where
  fmap :: (a -> b) -> Result a -> Result b
  fmap f (Ok x) = Ok (f x)
  fmap f (Error s) = Error s

instance Foldable Result where
  foldMap :: Monoid m => (a -> m) -> Result a -> m
  foldMap _ (Error s) = mempty
  foldMap f (Ok x) = f x

instance Traversable Result where
  traverse :: Applicative f => (a -> f b) -> Result a -> f (Result b)
  traverse f = sequenceA . fmap f

  sequenceA (Error s) = pure (Error s)  
  sequenceA (Ok x) = fmap Ok x



{-# LANGUAGE InstanceSigs #-}

data NEList a = Single a | Cons a (NEList a)
  deriving (Eq,Show)

instance Functor NEList where
  fmap :: (a -> b) -> NEList a -> NEList b
  fmap f (Single a) = Single (f a)
  fmap f (Cons a tail) = Cons (f a) (fmap f tail)

instance Foldable NEList where
  foldMap :: Monoid m => (a -> m) -> NEList a -> m
  foldMap f (Single a) = f a
  foldMap f (Cons a tail) = f a <> foldMap f tail

instance Traversable NEList where
  sequenceA :: Applicative f => NEList (f a) -> f (NEList a)
  sequenceA (Single a) = fmap Single a
  sequenceA (Cons a tail) = Cons <$> a <*> sequenceA tail


{-# LANGUAGE InstanceSigs #-}
newtype Parser tok a =
  Parser { runParser :: [tok] ->  Maybe ([tok],a) }

charA :: Parser Char Char
charA = Parser f where
  f (c:cs) | c == 'A' = Just (cs,c)
  f _                 = Nothing

satisfy :: (tok -> Bool) -> Parser tok tok
satisfy pr = Parser f where
  f (c:cs) | pr c  = Just (cs,c)
  f _              = Nothing

lower :: Parser Char Char
lower = satisfy isLower

char :: Char -> Parser Char Char
char c = satisfy (== c)

digit :: Parser Char Int
digit = digitToInt <$> satisfy isDigit

instance Functor (Parser tok) where
  fmap :: (a -> b) -> Parser tok a -> Parser tok b
  fmap g (Parser p) = Parser $ (fmap . fmap . fmap) g p

instance Applicative (Parser tok) where
  pure :: a -> Parser tok a
  pure x = Parser $ \s -> Just (s, x)
  (<*>) :: Parser tok (a -> b) -> Parser tok a -> Parser tok b
  Parser u <*> Parser v = Parser f where
    f xs = case u xs of 
      Nothing       -> Nothing
      Just (xs', g) -> case v xs' of 
        Nothing        -> Nothing
        Just (xs'', x) -> Just (xs'', g x)

multiplication :: Parser Char Int
multiplication = (*) <$> digit <* char '*' <*> digit

instance Alternative (Parser tok) where
  empty :: Parser tok a
  empty = Parser $ \_ -> Nothing
  (<|>) :: Parser tok a -> Parser tok a -> Parser tok a
  Parser u <|> Parser v = Parser f where 
    f xs = case u xs of
      Nothing -> v xs
      z       -> z


nat :: Parser Char Int
nat = Parser $ runParser (foldl (\acc x -> acc * 10 + x) 0 <$> (some digit))







