module Lab1 where

import Test.QuickCheck
import Test.QuickCheck.Property (Result (testCase))

sort :: [Int] -> [Int]
sort [] = []
sort (x : xs) = sort smaller ++ [x] ++ sort larger
  where
    smaller = [a | a <- xs, a <= x]
    larger = [b | b <- xs, b > x]

sum' :: [Int] -> Int
sum' = foldl (+) 0

max' :: [Int] -> Int
max' = foldr max 0

min' :: [Int] -> Int
min' = foldr min 0

allSubLists :: [Int] -> [[Int]]
allSubLists [] = []
allSubLists (x : xs) = [take n (x : xs) | n <- [1 .. length (x : xs)]] ++ allSubLists xs

allIsAndJs :: [Int] -> [(Int, Int)]
allIsAndJs xs = [(i, j) | i <- [1 .. length xs], j <- [i .. length xs]]

sumSubLists :: [[Int]] -> [Int]
sumSubLists = map sum'

zipAll :: [Int] -> [(Int, Int)] -> [[Int]] -> [(Int, (Int, Int), [Int])]
zipAll [] _ _ = []
zipAll (x : xs) (y : ys) (z : zs) = (x, y, z) : zipAll xs ys zs

filterSubLists :: [Int] -> [(Int, (Int, Int), [Int])] -> [(Int, (Int, Int), [Int])]
filterSubLists [] _ = []
filterSubLists (x : xs) ys = [(y, ijs, sublist) | (y, ijs, sublist) <- ys, y == x] ++ filterSubLists xs ys

testList :: [Int]
testList = [-1, 2, -3, 4, -5]

allSums :: [Int] -> [Int]
allSums xs = [min' xs .. max' xs]

result :: [Int] -> [(Int, (Int, Int), [Int])]
result xs = filterSubLists (allSums xs) (zipAll sums (allIsAndJs xs) (allSubLists xs))
  where
    sums = sumSubLists (allSubLists xs)

printNLists :: Int -> [(Int, (Int, Int), [Int])] -> IO ()
printNLists _ [] = return ()
printNLists 0 _ = return ()
printNLists n ((x, (i, j), sublist) : xs) = do
  putStrLn ("Sum: " ++ show x ++ " Indices: " ++ show i ++ " " ++ show j ++ " Sublist: " ++ show sublist)
  printNLists (n - 1) xs
  return ()

smallestKsest :: Int -> [Int] -> IO ()
smallestKsest k xs = printNLists k (result xs)

testList1 :: [Int]
testList1 = [x * (-1) ^ x | x <- [1 .. 100]]

k1 :: Int
k1 = 15

testList2 :: [Int]
testList2 = [24, -11, -34, 42, -24, 7, -19, 21]

k2 :: Int
k2 = 6

testCase1 :: IO ()
testCase1 = smallestKsest k1 testList1

testCase2 :: IO ()
testCase2 = smallestKsest k2 testList2
