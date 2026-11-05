import Data.List
import Data.Foldable
data P =  P {fN :: String, lN :: String, age :: Int} deriving (Show)
compare' x y = (compare (fN x) (fN y)) <> (compare (lN x) (lN y))

compare `on` fN = \x y -> compare (fN x) (fN y)
-- при подстановке для всех fN lN получим что везде лишний x y, их как раз можно заменит f <> g

-- f, g :: a -> Monoid b
-- f <> g = \x -> f x <> g x

-- compare'' = (compare'' `on` fN) <> (compare'' `on` lN)

newtype Endo a = Endo { appEndo :: a -> a }

instance Semigroup (Endo a) where
    Endo f <> Endo g = Endo (f . g)

instance Monoid (Endo a) where
    mempty = Endo id


f = mconcat $ map Endo [(+5), (*3), (^2)]
-- appEndo f 2 = 17

join = foldr1 $ \a b -> a ++ ", " ++ b

or' = foldr1 $ \a b -> a || b
or'' = foldr (||) False

length' = foldr1 $ \a b -> 1 + b
length'' = foldr (\_ b -> 1 + b) 0
lenght''' = foldl' (const . succ) 0 -- ' форсирует вычисление, чтобы не было переполнения стека

maximum' = foldr1 $ \a b -> if (a > b) then a else b
maximum'' = foldr (\a b -> if (a > b) then a else b) (error "empty list")
maximum''' = foldl' max

head' = foldr1 $ \a b -> a
head'' = foldr (\a b -> a) (error "empty list")
head''' = foldr1 const

last' = foldr1 $ \a b -> b
last'' = foldr (\a b -> b) (error "empty list")
last''' = foldl1' $ flip const

-- filter' f = foldr1 $ \a b -> if f a then a : b else b
filter'' f = foldr (\x -> if f x then (x:) else id) []

map' f = foldr ((:) . f) []

-- take' = ..