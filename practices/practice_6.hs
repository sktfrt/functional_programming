import Data.Semigroup (Max(Max))
-- data OddList a = Single a | ConsOdd a (EvenList a)
--     deriving Show

data EvenList a = Nil | ConsEven a (OddList a)
    deriving Show

data OddList a = ConsOdd a (EvenList a)
    deriving Show

head Nil = Nothing
head (ConsEven x xs) = Just x

tail Nil = Nothing
tail (ConsEven x xs) = Just xs



type Symb = String 

infixr 3 :->
data Type = TVar Symb 
          | Type :-> Type
    deriving (Eq,Show)

arity :: Type -> Int
arity (TVar _) = 0
arity (_ :-> t2) =  1 + arity t2

order :: Type -> Int
order (TVar _ )= 0
order (t1 :-> t2) = max (order t1 + 1) (order t2) 


infixl 4 :@
data Term = Var Symb
          | Term :@ Term
          | Lam Symb Type Term
    deriving (Eq,Show)

freeVars :: Term -> [Symb]
freeVars (Var x) = [x]

boundVars :: Term -> [Symb]
boundVars = undefined