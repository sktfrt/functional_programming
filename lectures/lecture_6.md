# LECTURE 5

## Типы данных

### Алгебраические типы данных и сопоставление с образом  

#### тип суммы

`data` - пользовательские тип данных  
e.g `data TC = DC1 | .. | DCk`

```hs
data CardinalDirection = North | East | South | West
    deriving Show 

data Bool = True | False
data Unit = Unit -- безопасно
data Ordering = LT | EQ | GT
data Empty -- пустой тип, можно не писать равенство
```

```hs
hasPole :: CardinalDirection -> Bool
hasPole North = True
hasPole South = True
hasPole _ = False

isAnswer :: Integer -> Bool -- можно использовать стандартные типы данных как образец
isAnswer 42 = True
isAnswer _ = False
```

**семаника сопоставления с образцом**: сверху вниз, слева направо  
сопоставления с образцом происходит *энергично*  

#### тип произведения  

`data TC = DC TC1 ... TCk; k >= 0`

```hs
data PointDouble = PtD Double Double
    deriving ShowDouble

> :type PtD
PtD :: Double -> Double -> PointDouble

midPointDouble :: PointDouble -> PointDouble -> PointDouble
midPointDouble (PtD x1 y1) (PtD x2 y2) = PtD ((x1 + x2) / 2) ((y1 + y2) / 2)
```

```hs
data Box = Box Int -- два указателя
newtype Box = Box Int -- один
```

типы можно делать *полиморфными*  

```hs
data Point a = Pt a a
    deriving Show

> :type Pt
Pt :: a -> a -> Point a
```

`*` - обозначение простого типа
`:kind` - система типов над системой типов  

```hs
> :kind ->
-> :: * -> * -> *

42::Int
Int::* -- щас пытаются заменить * на Type
```

```hs
midPoint :: Fractional a => Point a -> Point a -> Point a
midPoint (Pt x1 y1) (Pt x2 y2) = Pt ((x1 + x2) / 2) ((y1 + y2) / 2)
-- haskell сам понимает тип данных: сложение -> Num, деление -> Fractional
```

#### тип, использующий и сумму и произведение

```hs
data Maybe a = Nothing | Just a --  либо ничего либо сам а
maybe :: b -> (a -> b) -> Maybe a -> b
find :: (a -> Bool) -> [a] -> Maybe a

data Either a b = Left a | Right b
either :: (a -> c) -> (b -> c) -> Either a b -> c

head' :: [a] -> Either String a
head' (x:_) = Right x
head' [] = Left "head': empty list"
```

`Either Bool | Ordering`  - 2 + 3 то есть 5 значений  
`Either (Bool, Ordering)` - 2 * 3 то есть 6 значений  
`Bool -> Ordering` == `Ordering ^ Bool` = 3 ^ 2 = 9  

#### экспоненциальные типы

```hs
data Emdom a = Endom (a -> a)

appEndom :: Endom a -> a -> a -- пользовательский $
appEndom (Endom f) = f

> e = Endom (\n -> 2 * n + 3)
> :t e
e :: Num a => Endom a
> :t appEndom e
appEndom e :: Num a => a -> a
```

#### рекурсивные типы

```hs
data Nat = Zero | Suc Nat
    deriving Show

> :t Zero
Zero :: Nat
> :t Suc
Suc :: Nat -> Nat
> two = Suc (Suc Zero)

pred (Suc n) = n;
pred Zero = Zero;

> pred two
Suc Zero
```

```hs
data List a = Nil | Cons a (List a)
    deriving Show
```

### Образцы : дополнительные сведения

`case ... of ...`  

#### as - образец

```hs
dupFirst (x:xs) = x:x:xs
dupFirst' ys@(x:xs) = x:ys -- вводим псведоним
```

#### ленивые образцы

```hs
(***) f g ~(x, y) = (f x, g y) -- делает образец ленивым
```

#### образцы в let выражениях

```hs
> let x:xs = "ABC" in xs ++ xs
```

#### образцы в лямбда абстракциях

`head''' = \(x:_) -> x`

#### охранные образцы

```hs
firstOdd  xs | Just x <- find odd xs = x
             | otherwise             = 0
```

### Типы данных : дополнительные сведения

```hs
data Point a = Pt { ptX :: a, ptY :: a }

> myPt = Pt 3 2
> ptX myPt 
3

data Point a = Pt { ptX = 2, ptY = 3 }

absP Pt {ptX = x, ptY = y} = sqrt (x ^ 2 + y ^ 2)
absP' (Pt x y) = sqrt (x ^ 2 + y ^ 2)
```

#### type

```hs
type String = [Char]

type EC = Either Char
```

#### newtype

== `data` но с ограничениями

```hs
newtype AgeNT = AgeNT Int
data AgeDT = AgeDT Int

ignoreNT (AgeNT n) = 42
ignoreDT (AgeDT n) = 42

> ignoreNT undefined
42
> ignoreDT undefined
error
```

`newtype` стирает конструкторы  

#### флаг `!`

`!` - позволяет форсировать вычисление

```hs
infinx 6 :+
data Complex a = !a :+ !a
```
