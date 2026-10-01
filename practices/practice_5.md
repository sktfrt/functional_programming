# PRACTICE 5

```hs
\xy case xy of (x, y) -> ...
```

```hs
seq ((\True y -> "...") undefined) 42 = ?? --42
    (\True -> \y -> "...") -- undefined
-- т.к в первом случае case вставляется уже после двух аргументов
-- а во втором проверка проходит уже после \True 
```

`case f of {patterns}` - f подставляем в паттерны поочереди  

`repeate` and `replicate`
