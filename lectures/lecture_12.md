# LECTURE 12

## Стандартные монады

### Монада Except

`transformers/mtl` - нужно скачать. чтобы ползоваться монадами, они не в сатндартной библиотеке  

```hs
newtype Except e a = Except { runExcept :: Either e a}
except = Except

instance Monad (Except e) where
    return = except . Right

    m >>= k = case runExcept m of
        Left e -> except $ Left e
        Right a -> k a
```

```hs
throwE = except . Left

m `catchE` h = case runExcept m of
    Left l -> h l
    Right r -> except $ Right r

do { action1; action2; action3 } `catchE` handler
```

```hs
instance Monoid e => Alaternative (Except e) where
    empty = except $ Left mempty
    x <|> y = except $ let alt = runExcept y in 
        case runExcept x of
            Left e -> either (Left . mappend e) Right e
            r -> r
```

### Монада Writer

обработка пары (лог, результат)  
`tell :: w -> Writer w ()` - пишем в лог  
`censor :: Monoid w => (w -> w) -> Writer w a -> Writer w a` - меняем лог  
`listen :: Monoid w => Writer w a -> Writer w (a, w)` - узнаем промежуточный результат  
`listens :: Monoid w => (w -> b) -> Writer w a -> Writer w (a, b)` - слушаем и изменяем лог  

### Монада Reader

```hs
instance Monad ((->) r) where
    return x =  \_ -> x
    m >>= k = \e -> k (m e) e
```

```hs
ask :: Reader r r

instance Monad (Reader r) where
    -- как выше
```

`asks :: (r -> a) -> Reader r a` - применяем функцию над окружением  
`local :: (r -> r) -> Reader r a -> Reader r a` - локально модифицируем окружение  

### Монада State

хотим объединить Writer и Reader  

```hs
... runState :: s -> (a, s)

instance Monad (State s) where
    return x = state $ \st -> (x, st)
    m >>= k = state $
        \st -> let (x, st') = runState m st
                m' = k x
               in runState m' st'
```

`runState, execState, evalState`  

`get :: State s s` - как у Reader  
`put :: s -> State s ()` - как у Writer  
`modify :: (s -> s) -> State s ()` - изменяем, что написано было  
`gets :: (s -> a) -> State s a`  

### Монада IO

```hs
getCharFromConsole :: RealWorld -> (RealWorld, Char) -- хотим как то так

newtype IO (State# RealWorld -> (# State# RealWorld, a #))
-- мы не имеем к нему доступа, как то связывается с функцией main
```

```hs
-- input
getChar :: IO Char -- magical
getLine :: IO String
getContents :: IO String

-- output
putChar :: Char -> IO () -- magical
putStr, putStrLn :: String -> IO ()
print :: Show a => a -> IO ()

--- input-output
interact :: (String -> String) -> IO ()
```

```hs
main = do
    putStrLn "Whats your name?"
    name <- getLine
    putStrLn $ "Hello, " ++ name ++ "!"
```
