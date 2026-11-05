# LECTURE 7

## Классы типов(интерфейс)

параматерический полиморфизм - реализация не зависят от типа данных  
специальлны(ad hoc) полиморфизм - противоположное параметрическому  

Класс типов - набор функций с сигнатурами  

```hs
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool

elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys -- Eq из за ==
```

```hs
instance Eq Bool where
    True == True = True
    False == False = True
    _ == _ = False
    x /= y = nit (x == y)
```

**никакие** стрелочные типы не являются предсатителями `Eq`  
поэтому сравнивать списки модно если мы можем сравнивать ее элементы  

```hs
instance Eq a => Eq [a] where
    [] == [] = True
    (x:xs) == (y:ys) = x == y && xs = ys
    _ == _ = False
```

### методы классов по умолчанию

```hs
class Eq a where
    x /= y = not (x == y)
    x == y = not (x /= y)
    {-# MINIMAL (==) | (/=) #-} -- указываем,ч то хотя бы нужно реализовать
```

---

`data Point a = Point a a deriving Eq` - позволяем сравнивать  
`deriving instance Show a => Show (Point a)` - можно отдельно с определенном флаге компиляции  

### расширение класса

```hs
class Eq a => Ord a where
    (<), (<=), (>=), (>) :: a -> a -> Bool

class (Eq a, Show a) => Num a where
    ...
```

### законы для классов типов

стнадарт говорит, что `Ord` имеет линейный порядок  
подразумевается что законы верны для любого представителя класса типов  

### не простые типы

```hs
class Functor f where
    fmap :: (a -> b) -> f a -> f b

instance Functor [] where
    fmap = map

instance Functor Maybe where
    fmap _ Nothing  = Nothing
    fmap f (Just a) = Just (f a)
```

### представители - сироты

путь в `T.hs` лежит `data T ..`, в `C.hs` лежит `class C ..`, куда пихать `instance CT`?  
если запихнуть в отдельный файл, то получается сирота  
а если подключить два файла с модулем, то получим конфликт  
давать имена нельзя, значит сиротиливость запрещена  

### еще про волшебные {-# #-}

Расщирение `GeneralizedNewtypeDeriving` - повзоляет генерировать предсатвителя клсса типов Num  

```hs
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
newtype Temperature = Temperature { getTemp :: Double }
    deriving (Num, Eq, Show)

{-# LANGUAGE DerivingLanguage #-}
```

### фантомные типы

```hs
newtype Temperature a = Temperature { getTemp :: Double } -- a появилась опа, причем не сипользуме ее в правой части
    deriving (Num, Eq, Show)

data Celsius
data Fahrenheit

comfortTemp :: Temperature Celsius
comfortTemp = 23
```

## стандартные классы типов

```hs
class (Eq a) => Ord a where
    compare ..
    <, <= ..

    compare x y = if x == y then EQ
                    else if x <= y LT
                    else EQ
```

```hs
class Enum a where
    succ, pred :: a -> a
    toEnum :: Int -> a
    fromEnum :: a -> Int

class Bounded a where
    minBound, maxBound :: a
```

```hs
class (Eq a, Show a) => Num a where
    x - y = x + negate y
    negate x = 0 - x

-- у Num есть два подкласса - Integral(через Real) and Frunctional
-- Автоматического привдеедния чисел от одного типа к другому нет!
```

### преобразование от целых и к цлеым

```hs
fromIntegral :: (Num b, Integral a) => a -> b
> sqrt (4::Int) -- error
> sqrt $ fromIntegral (4::Int)

ceiling, floor, truncate, round :: (RealFrac a, integral b) => a -> b
```

### преобразование к рациональным дробям

```hs
data Ratio a = !a :% !a deriving Eq
type Rational = Ratio Integer

-- но % нельзя использовать

> toRational 2.5 -- 5 % 2
> 10 % 5
err: not in scoped '%'
> import Data.Ratio

> toRational 4.9
428948289234832 % 42399240294 -- не 49 % 10
> approxRational 4.9 0.1
5 % 1
> approxRational 4.9 0.01
49 % 10
```

## Внутренняя реализация классов типов

вдохвлено VTable  

```hs
class EQ a where
    eq :: a -> a -> Bool
    ne :: a -> a -> Bool

data EQ a = MkEQ {
    eq :: a -> a -> Bool,
    ne :: a -> a -> Bool }


instance EQ Bool where
    eq x y = case (x, y) of (True, True) -> True
                            (False, False) -> True
                            (_, _)

dEQBool :: Eq Bool
dEQBool = MkEq {
    eq = \x y -> ...
    ne = \x y -> not $ eq dEQBool x y
}

instance EQ a => EQ [a] where
    ...

dEQList :: EQ a -> EQ [a]
dEQList d = MkEQ {
    ...
}

elem :: EQ a => a -> [a] -> Bool
elem :: EQ a -> a -> [a] -> Bool

-- ВАЖНО, СЛОЖНЫЙ БИЛЕТ ВЫШЕ
```
