data Expr = Val Int | Add Expr Expr deriving Show

eval :: Expr -> Int
eval (Val x) = x
eval (Add x y) = eval x + eval y

render :: Expr -> String
render (Val x) = show x
render (Add x y) = "(" ++ render x ++ " + " ++ render y ++ ")"

expr1 = Add (Val 1) (Val 2)
