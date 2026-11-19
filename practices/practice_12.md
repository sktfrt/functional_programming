# PRACTICE 1221

`mapM == traverse`  
`sequence_` - делает то же, что и seq, но показывает только эффект  

```hs
print "first" `seq` print "second" -- second
```

```hs
instance Functor (Reader r) where
    fmap = liftM

instance Applicative (Reader r) where
    pure = return
    (<*>) = ap
-- чтобы не писать каждый раз

local' :: (r -> r') -> Reader r' a -> Reader r a -- это идея важная, она обобщается на многие конструкции
```
