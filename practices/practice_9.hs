{-# LANGUAGE InstanceSigs #-}

data E l r = L l | R r
    deriving (Eq, Show)

instance Functor (E l) where
  fmap :: (a -> b) -> E l a -> E l b
  fmap f (L x) = L x
  fmap f (R y) = R (f y)

instance Applicative (E l) where
  pure :: a -> E l a
  pure a =  R a
  (<*>) :: E l (a -> b) -> E l a -> E l b
  (<*>) (L x) _ = L x
  (<*>) _ (L y) = L y
  (<*>) (R f) (R x) = R (f x)

{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE FlexibleContexts #-}

newtype Cmps f g x = Cmps { getCmps :: f (g x) }

instance (Functor f, Functor g) => Functor (Cmps f g) where
  fmap :: (a -> b) -> Cmps f g a -> Cmps f g b
  fmap f (Cmps x) = Cmps (fmap (fmap f) x)