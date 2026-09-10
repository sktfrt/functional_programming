# Практика 2

*слабая головная нормальная форма* - когда стоит лямбда + что угодно  
*головная нормальная форма* - 0 - n лямбд + переменная в конце слева  
нормальная форма влечет сразу гнф

**пример** гнф но не нф: b((l x.x)x)  

power' эта экв l nm. mn  
омега 0 = I эта экв 1  
омега 1 = 1 1 = 1  
омега 2 = 2 2 = power' 2 2 = 4  
омега 3 = 27 и тд  

**каррированная функция** - (Int) -> (Int) -> Int (вместо (Int, Int) -> Int)  

curry =  l fxy. f(pair xy)  
uncurry = l fp. f (fst p) (snd p)  
uncurry = l fp. pf

## вычитаем числа черча

принято, что 0, уменьшенное на 1 - это 0

```kotlin
var acc = (0,0)
for (_ in 0 until n){
    acc = acc(acc.second, acc.second + 1)
}
return acc.first
```

```haskell
zp = pair 0 0  
sp = l p. pair(snd p) (succ(snd p))  
pred = l n. fst (n sp zp) 
```

minus = l ab. b pred a  

```kotlin
var acc = X
for (i in 0 until n){
    acc = F(i, acc)
}
return acc
```

xp = l x.pair x 0  
fp = l fp. pair(f(fst p)(snd p))(succ (snd p))  
rec = l fxn. fst(n (fp f)(xp x))  

cons = l x xs c n. cx(xs c n)  
nil = l cn. n  
null = l xs. xs (l xy. fls) tru  

foldr = l f x xs . xs f x  

l xs. xs (l xy. x) ОМЕГА  - пустой == мусор  
l xs. xs (l xy. x) - завтсалвяем пользователя добавлять доп параметр

## Y комбинатор

```py
def f(x): return f
```

FX = F -> F = lx.F -> F = Y l fx.f = YK  
