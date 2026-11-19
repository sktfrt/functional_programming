# LECTURE 11

## Монады

### Класс типов Monad

Стрелка Клейсли -  `a -> m b`, обеспечивает зависимость эффекта от вычисления  

```hs
class Apllicative m => Monoid m where
    (>>=) :: m a -> (a -> m b) -> m b --bind
    m1 >> m2 = m1 >>= \_ -> m2 --simple bind

    return :: a -> m a
    return = pure

toKleisli :: Monad m => (a -> b) -> (a -> m b)
toKleisli f = return . f
```

`=<<` = flip `(>>=)`  

### Монада Maybe

```hs
instance Monad Maybe where
    Just x >>= k = k x -- вынимаем аргумент из контекста и передаем стрелке клейсли
    Nothing >>= _ = Nothing

    Just _ >> m = m
    Nothing >> _ = Nothing

    return = Just
```

```hs
return a >>= k = k a
m >>= return = m
(m >>= k) >>= k` = m >>= (\x -> k x >>= k`)
```

с помощью лямбд мы можем явно использовать вынимаемый аргумент в коде  
можно комбинировать и не свзяывать в лямбду переменные, которые нам не нужны  

`do - нотация` - как писать императивный код не рисуя 100500 лямбд  

```hs
do {e} = e
do (e; sts) = e >> do {sts}
do {p <- e; sts} = e >>= \p -> do {sts}
do {let v = exp; sts} = let v = exp in do {sts}
-- или вместо {} и ; использовать отступы
```

### Класс типов MonadFail

хотим уметь сопоставлять ответ с желаемым(pattern matching)  

```hs
fail :: String -> m a
fail = error -- по умолчанию

-- например можно
fail = Nothing

class Monad m => MonadFail m where
    fail:: String -> m a

instance MonadFail Maybe where
    fail _ = Nothing
```

`fail s >>= k = fail s`

### Список как монада

```hs
instance Monad [] where
    xs >>= k = concat (map k xs)
    return x = [x]

instance MonadFail [] where
    fail _ = []
```

`join :: m (m a) -> m a`  

```hs
join . return = id -- упаковываем в коробочку и сразу распаковываем
join . fmap return = id -- аналогично
join . fmap join = join . join -- тип m(m(m(a)))
```
