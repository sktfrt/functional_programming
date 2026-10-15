import Prelude

data Tree a = Leaf | Node (Tree a) a (Tree a)

t1 = Node (Node (Node Leaf 5 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)
t2 = Node (Node Leaf 2 Leaf) 3 (Node Leaf 4 Leaf)
t3 = Node Leaf 42 Leaf
tInf1 n = Node (tInf1 (n+2)) n (Node Leaf 42 Leaf)
tInf2 n = Node (tInf2 (n+2)) n (tInf2 (3*n-1))

instance Functor Tree where
    fmap f Leaf = Leaf
    fmap f (Node l x r) = Node (fmap f l) (f x) (fmap f r)

elemTree' _ Leaf = False 
elemTree' elem (Node l x r) = elem == x || elemTree' elem l || elemTree' elem r

elemTree _ Leaf = False
elemTree elem (Node l x r) = helper 1 elem (Node l x r)
    where 
        helper t elem (Node Leaf x r) = elem == x || elemTree elem r
        helper t elem (Node l x Leaf) = elem == x || elemTree elem l

        helper t elem (Node l x r) = 
                    if t == 1
                        then helper 2 elem l
                    else if t == 2
                        then helper 1 elem r
                    else
                        True;


-- instance Show a => Show (Tree a) where
--     show Leaf = "{}"
--     show (Node l x r) = "<" ++ show l ++ show x ++ show r ++ ">"

instance Show a => Show (Tree a) where
    showsPrec _ Leaf = showString "{}"
    showsPrec _ (Node l x r) = showString "<" . shows l . shows x . shows r . showString ">"
