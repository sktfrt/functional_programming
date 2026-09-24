# PRACTICE 4

новый дедлайн, тепперь жеский дедлайн один, до дня занятия  
но в связи с ассесментом нам перенсут!!! ура

`I = \x.x` = `id`  
`K = \xy.x` = `const`  
`C = \fxy.fyx` = `flip`  
`B = \fgx.f(gx)` = `(.)`  

`Int` - обычное 64 битное число  
`Integer` - как в питоне, произвольная длина

## -

```hs
ghci> 5 * (-3)
-15
ghci> 5 * -3
<interactive>:2:1: error: [GHC-88747]
    Precedence parsing error
        cannot mix ‘*’ [infixl 7] and prefix `-' [infixl 6] in the same infix expression

ghci> 5*-3
<interactive>:3:2: error: [GHC-88464]
    Variable not in scope: (*-) :: t0 -> t1 -> t
    Suggested fix:
      Perhaps use one of these:
        ‘*’ (imported from Prelude), ‘-’ (imported from Prelude),
        ‘**’ (imported from Prelude)

ghci> 
-- так как минус захардкожен
-- оператор *-
```

---

`/=` - не равно  

---

## succ

```hs
ghci> succ 41
42
ghci> succ 'z'
'{'
ghci> succ pi
4.141592653589793
```

## mod, rem, /

```hs
ghci> mod 42 10
2
ghci> rem 42 10
2
ghci> mod (-42) 10
8
ghci> rem (-42) 10
-2
ghci> 42 `mod` 10
2
ghci> 42 `rem` 10
2
ghci> 42 / 10
4.2
ghci> 1/0
Infinity
ghci> 1 `div` 0
*** Exception: divide by zero
```

## ^, **

```hs
ghci> 10 ^ 10
10000000000
ghci> 10 ** 10
1.0e10
ghci> 1000 ** 1000
Infinity
```

## sqrt

`f $ x = f x`

```hs
ghci> sqrt(sqrt 16)
2.0
ghci> sqrt $ sqrt 16
2.0
ghci> (sqrt.sqrt)16
2.0
ghci> sqrt.sqrt $ 16
2.0
```

`undefined` = расходимость(⊥. имеет тип альфа для любого альфа) - используется, как `throw NotImplementedException`

под тип `forall a.a` подходит только расходящиеся типы(понять почему)

`error` - well, error

`:set` - сколько времени и сколько байт использовалась операция  
`:unset`

`:i div` - info about ..  
`:doc div` - documentation  

```hs
ghci> :t 7
7 :: Num a => a
ghci> :t 7.0
7.0 :: Fractional a => a
```

```hs
ghci> :t (+)
(+) :: Num a => a -> a -> a
ghci> :t (-)
(-) :: Num a => a -> a -> a
ghci> :t (/)
(/) :: Fractional a => a -> a -> a
```

```hs
ghci> :{
ghci| a = 5
ghci| b = 10
ghci| :}
ghci> a
5
ghci> a = b; b = 10
```

```hs
ghci> :{
ghci| if 5 > 1
ghci| then 100
ghci| else -1
ghci| :}
100
```

```hs
ghci> f = \x -> 42
ghci> f x = 42
ghci> f = \ _ -> 42
ghci> f _ = 42
ghci> f = const 42
```

```bash
gchi file.hs
or
gchi
gchi> :l file.hs
```

`NoMonomorfismRestriction` - флаг, чтоб типы нормально ставились  

