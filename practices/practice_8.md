# PRACTICE 8

("a", 5, True)  
("a", 3, False)  
 EQ   GT  
EQ <> GT = GT  

EQ - нейтральный  

```hs
EQ <> x = x
x <> _ = x
```

хотим из двуз функций получаться тоже функцию  

```hs
f, g :: a -> Monoid b
f <> g = \x -> f x <> g x
```
