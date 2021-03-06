-- http://learnyouahaskell.com/for-a-few-monads-more

import Control.Monad.Writer 

gcd' :: Int -> Int -> Writer [String] Int  
gcd' a b  
    | b == 0 = do  
        tell ["Finished with " ++ show a]  
        return a  
    | otherwise = do  
        tell [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)]  
        gcd' b (a `mod` b) 

  
gcdReverse :: Int -> Int -> Writer [String] Int  
gcdReverse a b  
    | b == 0 = do  
        tell ["Finished with " ++ show a]  
        return a  
    | otherwise = do  
        result <- gcdReverse b (a `mod` b)  
        tell [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)]  
        return result   

newtype DiffList a = DiffList { getDiffList :: [a] -> [a] }  

toDiffList :: [a] -> DiffList a  
toDiffList xs = DiffList (xs++)  
  
fromDiffList :: DiffList a -> [a]  
fromDiffList (DiffList f) = f []  

instance Monoid (DiffList a) where  
    mempty = DiffList (\xs -> [] ++ xs)  
    (DiffList f) `mappend` (DiffList g) = DiffList (\xs -> f (g xs))  

gcd'' :: Int -> Int -> Writer (DiffList String) Int  
gcd'' a b  
    | b == 0 = do  
        tell (toDiffList ["Finished with " ++ show a])  
        return a  
    | otherwise = do  
        result <- gcd'' b (a `mod` b)  
        tell (toDiffList [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)])  
        return result

finalCountDown :: Int -> Writer (DiffList String) ()  
finalCountDown 0 = do  
    tell (toDiffList ["0"])  
finalCountDown x = do  
    finalCountDown (x-1)  
    tell (toDiffList [show x])   

finalCountDown' :: Int -> Writer [String] ()  
finalCountDown' 0 = do  
    tell ["0"]  
finalCountDown' x = do  
    finalCountDown' (x-1)  
    tell [show x]  

keepSmall :: Int -> Writer [String] Bool  
keepSmall x  
    | x < 4 = do  
        tell ["Keeping " ++ show x]  
        return True  
    | otherwise = do  
        tell [show x ++ " is too large, throwing it away"]  
        return False 

powerset :: [a] -> [[a]]  
powerset xs = filterM (\x -> [True, False]) xs  

main = do
  mapM_ putStrLn . fromDiffList . snd . runWriter $ gcd'' 110 34
  print $ fst $ runWriter $ filterM  keepSmall [9,1,5,2,1,3]
  mapM_ putStrLn .  snd $ runWriter $ filterM  keepSmall [9,1,5,2,1,3]
  print $ powerset [1,2,3]



