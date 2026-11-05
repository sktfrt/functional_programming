# LECTURE 3

## Свертки и развертки

### Свертки списков

правая свертка:

```hs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z [] = z
foldr f z (x:xs) = z `f` (foldr f z xs)
-- вычисления сразу

sum = foldr (+) 0
concat = foldr (++) []
allOdd = flodr (\n b -> add n && b) True
```

левая свертка:

```hs
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f z [] = z
foldl f z (x:xs) = foldl f (z `f` x) xs
-- здесь мы не будем фосировать вычисления, пока не дойдем до []

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f z [] = z
foldl' f z (x:xs) = acc `seq` foldl' f acc xs
    where acc = f z x
-- форсируем
```

```hs
foldr1 _ [x] = x
foldr1 f (x:xs) = f x (foldr1 f xs)
foldr1 _ [] = error ""
-- если мы знаем что список не пустой
-- аналогично для foldl1
```

*сканы* - список последовательных шагов свертки

```hs
scanl (#) z [a, b, ...] == [z, z # a, (z # a) # b, ...]

scanl 
scanl _ z [] = [z]
scanl (#) z (x:xs) = пупупу
```

### Развертки и оптимизации

```hs
unfold :: (b -> (a, b)) -> b -> [a] -- идеально для бесконечных списков

unfoldr :: (b -> Maybe (a, b)) -> b -> [a]

iterate f z = [z, fz, f(fz), ...]
iterate f = unfoldr (\x -> Just (x, f x))
```

`build` - нет в стандартной библиотеке

```hs
build :: (forall b. (a -> b -> b) -> b -> b) -> [a] -- список в кодировке черча -> обычный список
build g = g (:) []
```

```hs
foldr f z (build g) == g f z
```

### Полугруппы и моноиды

```hs
infixr 6 <>
class Semigroup a where
    (<>) :: a -> a -> a

    sconcat :: NonEmpty a -> a -- смотрим сами

    stimes :: Integral b => b -> a -> a
    stimes = stimesDefault
    -- stimes n e = e <> e <> .. <> e  n раз, сложность logn

(x <> y) z == x <> (y <> z) -- закон

-- полугруппа относительно конкатенации
instance Semigroup [a] where
    (<>) == (++)
```

```hs
class Semigroup a => Monoid a where
    mempty :: a -- нейтральный
    mempty = mconcat []

    -- просто имя для ромибика, иногда существует, но уже не акутален
    mappend :: a -> a -> a
    mappend = (<>)

    mconcat :: [a] -> a
    mconcat = foldr mappend mempty

mempty <> x = x
x <> mempty = x

instance Monoid [a] where
    mempty = []
    mconcat = concat
```

```hs
newtype All = All { getAll :: Bool }
    deriving (Eq, Show, Read, Ord, Bounded)

instance Semigroup All where
    All x <> All y = All (x && y)
    stimes = stimesIdemponentMonoid

newtype Any = Any { getAny :: Bool }
    deriving (Eq, Show, Read, Ord, Bounded)

instance Semigroup Any where
    Any x <> Any y = Any (x || y)
    stimes = stimesIdemponentMonoid
```

```hs
ewtype Sum = Sum { getSum :: a }
    deriving (Eq, Show, Read, Ord, Bounded)

instance Num a => Semigroup (Sum a) where
    Sum x <> Sum y = Sum (x + y)

instance Num a => Monoid (Sum a) where
    mempty = Sum 0
```

```hs
instance Num a => Semigroup (Product a) where
    (<>) = coerce ((*) :: a -> a -> a)

instance Ord a => Semigroup (Min a) where
    (<>) = coerce (min @a)
```

### Классы типов Foldable

```hs
class Foldable t where
    flodr, flodr' :: ..

    foldl foldl' :: ..

    ....

    fold :: Monoid m => t m -> m -- t m == [] m = [m]
    fold = foldMap id

    foldMap :: Monoid m => (a -> m) -> t a -> m
    foldMap f = foldr (mappend . f) mempty
```
