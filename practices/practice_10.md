# PRACTICE 10

```hs
sequenceA [] = pure []
sequenceA (x:xs) = (:) <$> x <*> sequenceA xs

seqA [R 'A', R 'B', R 'C'] = R "ABC"
seqA [R 'A', L 'B', R 'C'] = L 'B'

traverse f = seqA . fmap f

traverse (:[]) [1, 2, 3, 4] = [[1, 2, 3, 4]]
-- так как :[] это pure то и получить мы ничего не можем кроме pure 
```

любят спршивать как выражается some и any выражаются друг через друга на эказмене
