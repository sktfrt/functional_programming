# LECTURE 10

## Использование аппликативных функторов

### Аппликативные парсеры

*парсер* - программа, принимающая на вход строку и возвращающая нек структуру данных  

```hs
type Parser a = String -> Maybe (String, a)
type Parser tok a = [tok] -> Maybe ([tok], a) -- обобщение

newtype Parser tok a = Parser { runParser :: [tok] -> Maybe ([tok], a) }

charA :: Parser Char Char
charA = Parser f where
    f (c:cs) | c == 'A' = Just (cs, s)
    f _ = Nothing

satisfy pr = Parser f where
    f (c:cs) | pr c = Just (cs, s)
    f _ = Nothing

lower = satisfy isLower
char c = satisfy (== c)
```

```hs
digit :: Parser Char Int
digit = digitToInt <$> satisfy isDigit

instance Functor (Parser tok) where
    fmap g = Parser . (fmap . fmap . fmap) g . runParser

instance Applicative (Parser tok) where
    pure x = Parser $ \s -> Just (s, x)
    Parser u <*> Parser v = Parser f where ...
```

существует `deriving (Functor)`

```hs
multiplication = (*) <$> digit <* char '*' <*> digit -- "5*6"
```

### Класс типов Alternative

```hs
class Applicative f => Alternative f where
    empty :: f a
    (<|>) :: f a -> f a -> f a

infixl 3 <|>

instance ALternative [] where
    empty = []
    (<|>) = (++)

instance Alternative Maybe where
    empty = Nothing
    Nothing <|> m = m
    m <|> _ = m
```

с помощью альтернативы можно построить парсер, который будет искать первый удачный парс  

```hs
lowers = (:) <$> lower <*> lowers <|> pure ""
```

так как конструкция почти одинаковая, можно ее обобщить

```hs
class Apllicative f => Alternative f where
    some, many ...
    some v = (:) <$> v <*> many v
    many v = some v <|> pure []
```

### Классы типов Traversable

хотим уметь [f a] -> f [a]  
или более обще t (f a) -> f (t a)

```hs
class (Functor t, Foldable t) => Traversable t where
    sequenceA = traverse id
    traverse g = sequenceA . fmap g
```

`deriving (Traversable)` тоже есть  
