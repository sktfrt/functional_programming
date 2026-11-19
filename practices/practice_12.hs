import Control.Monad
import Control.Monad.State

data Logged a = Logged String a deriving (Eq,Show)

instance Functor Logged where
  fmap = liftM

instance Applicative Logged where
  pure :: a -> Logged a
  pure a = Logged "" a 
  (<*>) = ap

instance Monad Logged where
  return = pure
  m >>= k = let Logged s a = m
                Logged s' b = k a
            in Logged (s' ++ s) b


write2log :: String -> Logged ()
write2log = flip Logged ()


nextId' :: State Integer Integer
nextId' = state $ \s -> (s, s + 1)
