# LECTURE 4

## Введение в Haskell

### Язык Haskell

использует технология **REPL**  
**Hoogle** - инструмент поиска по документации  

### ОП

1) выражение(Expressions)
2) объявление(Declaration)
3) модуль(Modules)

#### Expressions

```hs
-- все пишется в GCHi
13 * 3 + 3
"Hello" ++ 'w' : "orld"
not False
```

*Кортежи* - `(42, "Hello world")`

- от двух до 62 значений
- кортежи разных размеров относятся к разными типам  
- допустима префиксная нотация: `(,,) False "ABC" 42 --> (False, "ABS", 42)`

*Списки* - картеж с одним типом, `[1, 2, 3]`, `['H', 'e', 'l', 'l', 'o'] -->(GHCi) "Hello"`  

#### Declaration

```hs
x = 42               -- глобальное
aBC = let z = x + y  -- глобавльное aBC, локальное z
    in z ^ 2         -- отступ для let
y = 2 + 3            -- глобальное

-- первый символ индентификатора должен быть в нижнем регистре
-- в GHCi тоже можно делать связывание
```

```hs
-- в GHCi, pattern binding
-- образец = конструктор, мисфиксные операторы
(x, y) = ('A', 21*2)         -- x = 'A', y = 42
[u, v, w] = reverse "Hi!"    -- w = 'H'
[p, q, r] = reverse "Hello!" -- exception
```

```hs
foo x y = 10 * x + y
fortyFoo = foo 2 22

foo' x = \y -> 10 * x + y
foo'' = \x y -> 10 * x + y 
-- то же самое, штрихи вместо перечисления, foo1 == foo`, foo2 = foo``
```

```hs
-- log по основанию 2
lg x = logBase 2 x
lg' = \x -> logBase 2 x
lg'' = logBase 2 -- бесточечный стиль
```

```hs
fst (x, y) = x
snd (x, y) = y

fstOfSnd (x, (y, z)) = y
```

```hs
-- связывние однократное
z = 1
z = 2               -- ошибка
q q = \q -> q       -- ок, это K*, переменная ссылается на ближайшую область видимости

p p p = p           -- ошибка
p = \p p -> p       -- ошибка
p = \p -> (\p -> p) -- ок

-- в интерпритаторе можно повторное присваивание
```

```hs
roots a b c = 
    (
        ...
        ...
    )
nRoots = -- начало нового объявления
    if ...
    then ...
    else ...
```

```hs
factorial0 = if n > 1
             then n * factorial0 (n - 1)
             else 1

factorial1 = if n == 0 -- уйдет в бесконечность при отрицательном
             then 1
             else n * factorial1 (n - 1)

-- хотим исключения
```

**Библиотечная константа `undefined`**

```hs
GHCi> undefined
*** Exception

bot = 1 + bot -- тоже indefined, непродуктивная расходимость, ничо полезного сделать нельзя
fortyTwos = 42 : fortyTwos -- undefined, продуктивная расходимость, так как это СГНФ
-- 42 : (42 : (42 : ....))

GHCi> take 5 fortyTwos
[42, 42, 42, 42, 42]
```

**Функция `error`**

```hs
factorial n =
    if n < 0
    then error "negative arg"

GHCi> factorial(-3)
*** Eception: negative arg
```

Техника **аккумулирующего параметра**

```hs
factorial' n = helper 1 n
helper acc n =  if n > 1
                then helper (acc * n) (n - 1)
                else acc
-- храним результат в специальном хранилище, и не плодим вызовы функций
```

`where` обеспечивает локальное связывание вспомогателных конструкций

```hs
roots' a b c = ((a / aboba) + yaaazz)
    where {aboba = 5; yaaazz = 1221}

-- или
roots'' = ...
    where aboba = 5
          yaaaxx = 1221

-- локальное связывние рабоает и для функций
fact'' n` = helper 1 n'
    where helper acc n = ...

-- это лучше, так как мы не засоряем глобальную область видимости
```

`let` - то же что и `where`, только мы сначала пишем связывания, причем `let` - это выражение, а `where` - конструкция

```hs
(let i = 3 in 2 * i)^2
(2 * i where i = 3)^2 -- так нельзя
```

**`Guard`** - `|`, `where` позволяет проверять переменные до первого истинного  
`otherwise` = `True`

```hs
roots a b c | d > 0 = 2
            | d == 0 = 1
            | d < 0 = 0
        where d = b ^ 2 - 4 * a * c
```

#### Modules

программа = набор модулей(1 модуль = 1 файл, имя фафла и модуля совпадают), упраляют простарнствами имен,

```hs
module A (foo, bar) where -- называем модуль и говорим чем можно пользоваться
import B (f, g, h)        -- импорт модуля В и говорим, что хотим
foo = f g
bar = ...

B.f = .. -- пробелы нельзя

```

```hs
import qualified B (f, g, h) -- обязываем писать полное имя (B.f, B.g)
```

### Базовые типы

Базовые типы:

- `Bool`, `Char`, `Int`(Integer), `Float`, `Double`  
- Тип функции:  `type1 -> type2`  
- Тип кортежа: `(type1, type2)`, списка: `[type1]`  
- Единичный тип: `()`  

```hs
GHCi> [1, 2, 3] :: [Double]
GHCi> [1, 2, 3] :: [] Double -- еще пример мисфиксного оператора на уровне типов
```

Объявление типа данных - `data`

`data Bool = True | False`  

`True::Bool` == коструктор данных :: констуктор типов

```hs
not :: Bool -> Bool
not True = False
not False = True
-- можно определять не полностью
-- можно было не писать тип not, можно в интерпритаторе просить вывести тип и ctrl C ctrl V
```

`_` - wildcard(джокер) == пофиг на имя
`:type` - узнать тип

```hs
and :: Bool -> Bool -> Bool
and True True = True
and _ _ = False 
```

#### Полиморфизм

можно подсавить любой тип

```hs
GHCi> k x1 x2 = x1
GHCi> :type k1
k :: p1 -> p2 -> p1

GHCi> :type k 'x'
k 'x' :: p2 -> Char
```

в `GHC Core` реализовано `System F`, то есть мы можем ставить разные флаги в интерпритатор(почитай документацию)  

```hs
GHCi> :t k
k :: forall {p1} {p2}. p1 -> p2 -> p1
```

#### Специальный полиморфзим

можно подставить ограничение на тип

```hs
GHCi> bas x y = 10 * x + y
GHCi> :t bas
bas :: Num a => a -> a -> a -- Num a это контекст, то есть все переменные обязаны быть Num
```

Функции высших порядко == функции, содержащие стрелочные типы в качестве аргументов
