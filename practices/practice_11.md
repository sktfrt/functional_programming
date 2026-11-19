# PRACTICE 11

```hs
do b <- [True, False, False]
    when b [] -- если True то условие
    return 42;
-- итого [42, 42]

when :: (Monad m) => Bool -> m () -> m ()
guard :: (Monad m, Alternative m) => Bool -> m ()

filter` p xs = do x <- xs
    guard $ p x
    return x

replicate` n x = do _ <- [1..n]
    return x
```
