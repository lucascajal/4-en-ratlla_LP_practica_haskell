import System.Random

--IMPORTANT: Per representar el board farem una matriu, on tindrem columnes x files! (invers)
-- a = [[1,0,0,0],[1,1,0,0],[1,1,1,0],[0,0,0,0],[1,1,1,1]]

{- 
b = [[0,0,0,0,0,0,0],[2,2,1,2,2,0,0],[1,2,1,1,2,0,0],[2,0,0,0,0,0,0],[1,0,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]
· · · · · · · ·
· · · · · · · ·
· O O · · · · ·
· O X · · · · ·
· X X · · · · ·
· O O · · · · ·
· O X O X X · ·

b = [[0,0,0,0,0,0,0],[2,2,1,2,2,0,0],[1,2,1,1,2,0,0],[2,0,0,0,0,0,0],[1,0,0,0,0,0,0],[1,0,0,0,0,0,0],[1,0,0,0,0,0,0],[0,0,0,0,0,0,0]]
· · · · · · · ·
· · · · · · · ·
· O O · · · · ·
· O X · · · · ·
· X X · · · · ·
· O O · · · · ·
· O X O X X X ·
-}

{- Smart ideas:
    - Calculate +1 element in row if both sides are free (just when having 3 chips?)
    - Toss chips where they have space avaliable arround them (minimum 4, ideal 7) in all directions
    - Count free spaces continuing a line as half points?
    - When tossing a chip, check that the move won't let the adversari win by putting one on top
-}

main :: IO ()
-- main program to play the game
main = do
       putStrLn "Board height: " 
       input2 <- getLine
       putStrLn "Board width: "
       input1 <- getLine

       let width = (read input1 :: Int)
       let height = (read input2 :: Int)

       putStrLn ("Board dimensions: " ++ (show width) ++ " x " ++ (show height))

       putStrLn ("Chips avaliable: " ++ show(width * height))

       putStrLn "First player (1 == human, 2 == computer): " 
       input3 <- getLine
       let player = (read input3 :: Int)

       let board = newBoard width height
       turn player board (width * height)

--Turn
turn player board movesLeft
    | movesLeft == 0 = do 
        putStrLn "Game ended in tie! No moves left"
        printBoard board
    | movesLeft == -1 = do 
        putStrLn "You are the winner!!!"
        printBoard board
    | movesLeft == -2 = do 
        putStrLn "Game lost :( you were crashed by a machine!"
        printBoard board
    | player == 1 = do
        printBoard board
        col <- inputCol board
        if (makesN board col player 4) then do
            turn 2 (makeMove 1 col board) (-1)
        else do
            turn 2 (makeMove 1 col board) (movesLeft-1)
    | otherwise = do
        --col <- randomCol board
        --let col = greedyCol board
        let col = smartCol board
        if (makesN board col player 4) then do
            turn 1 (makeMove 2 col board) (-2)
        else do
            turn 1 (makeMove 2 col board) (movesLeft-1)

--Returns a valid column given by the user
inputCol board = do
    putStrLn "Column: "
    input1 <- getLine
    let col = (read input1 :: Int) - 1
    if (correctCol board col) then do
        return col
    else do
        putStrLn "Wrong column. Please enter again."
        res <- inputCol board
        return res

--Returns a valid random column
randomCol board = do
    col <- randInt 0 ((boardWidth board)-1)
    if (correctCol board col) then do
        return col
    else do
        res <- randomCol board
        return res

--Returns a valid column selected by a greedy algorithm
greedyCol board 
    | not $ null wewin = head wewin
    | not $ null make3noLoss = head make3noLoss
    | not $ null make2noLoss = head make2noLoss
    | not $ null stopEnemyWin = head stopEnemyWin
    | not $ null make3 = head make3
    | not $ null make2 = head make2
    | otherwise = head cols

    where
        cols = [x | x <- [0..((boardWidth board)-1)], (correctCol board x)]
        stopEnemyWin = [x | x <- cols, (makesN board x 1 4)]
        wewin = [x | x <- cols, (makesN board x 2 4)]
        make3 = [x | x <- cols, (makesN board x 2 3)]
        make2 = [x | x <- cols, (makesN board x 2 2)]
        make3noLoss = [x | x <- make3, (x `elem` stopEnemyWin)]
        make2noLoss = [x | x <- make2, (x `elem` stopEnemyWin)]

--Returns a valid column selected by the smart algorithm
smartCol board
    | not $ null weWin = head weWin
    | not $ null make3noLoss = head make3noLoss
    | not $ null make2noLoss = head make2noLoss
    | not $ null stopEnemyWin = head stopEnemyWin
    | not $ null make3 = head make3
    | not $ null make2 = head make2
    | otherwise = head cols

    where
        cols = [x | x <- [0..((boardWidth board)-1)], (correctCol board x)]
        topLoss = [x | x <- cols, makesNsmart (makeMove 2 x board) x 1 4 , (correctCol (makeMove 2 x board) x)]
        safeCols = [x | x <- cols, not (x `elem` topLoss)]
        stopEnemyWin = [x | x <- cols, makesNsmart board x 1 4]
        weWin = [x | x <- cols, makesNsmart board x 2 4]
        make3 = [x | x <- safeCols, makesNsmart board x 2 3]
        make2 = [x | x <- safeCols, makesNsmart board x 2 2]
        make3noLoss = [x | x <- make3, (x `elem` stopEnemyWin)]
        make2noLoss = [x | x <- make2, (x `elem` stopEnemyWin)]

--Checks if column is valid
correctCol board col
    | col < 0 = False
    | col >= (boardWidth board) = False
    | otherwise = elem 0 (board !! col)

--DEPRECATED Checks if there are no moves left (there are no zeroes in board)
noMoves board = not $ or (map (elem 0) board)

randInt :: Int -> Int -> IO Int
-- randInt low high is an IO action that returns a
-- pseudo-random integer between low and high (both included).
randInt low high = do
    random <- randomIO :: IO Int
    let result = low + random `mod` (high - low + 1)
    return result

--Recursive board print
printBoard' board column line
    | (column == boardWidth board -1) && (line == 0) = do
        putStrLn c
    | (column == boardWidth board -1) = do
        putStrLn c
        printBoard' board 0 (line - 1)
    | otherwise = do
        putStr $ c ++ " "
        printBoard' board (column + 1) line
    where c = chipPrint $ boardPos board column line

--Converts data from the board to a more readable format
chipPrint n
    | n == 1 = "X"
    | n == 2 = "O"
    | otherwise = "·"

--Funció que imprimeix un board
printBoard board = do
    printBoard' board 0 ((boardHeight board) - 1)

--Creadora d'un board sense fitxes
newBoard width height = replicate width (replicate height 0)

--Retorna el valor de la posició indicada al tauler (0, 1 o 2)
boardPos board c l = (board !! c) !! l

--Alçada del board
boardHeight board = length (board !! 0)

--Amplada del board
boardWidth board = length board

--New board resulting from a move
makeMove player column board
    | column == 0 = ((addChip (board !! column) player):[])++(drop (column + 1) board)
    | column == (boardWidth board)-1 = (take (column) board)++((addChip (board !! column) player):[])
    | otherwise = (take (column) board)++((addChip (board !! column) player):[])++(drop (column + 1) board)

--Auxiliar de makeMove per afegir una fitxa a una columna
addChip list player
    | (head list) == 0 = player:(tail list)
    | otherwise = (head list):(addChip (tail list) player)

--Returns the height of the column
getHeight column
    | null column = 0
    | last column /= 0 = length column
    | otherwise = getHeight $ init column

--Returns column elements (with distance <= 3)
getCol board col player = under ++ (-player):over
    where
        n = board !! col
        row = getHeight n
        over = takeWhile (\x -> (x==0) || (x==player)) $ take 3 $ drop (row + 1) n
        under = reverse $ takeWhile (\x -> (x==0) || (x==player)) $ take 3 $ reverse $ take row n

--Returns row elements (with distance <= 3)
getRow board col player = left ++ (-player):right
    where 
        row = getHeight $ board !! col
        n = map (!! row) board
        right = takeWhile (\x -> (x==0) || (x==player)) $ take 3 $ drop (col + 1) n
        left = reverse $ takeWhile (\x -> (x==0) || (x==player)) $ take 3 $ reverse $ take col n

--Returns increasing diagonal elements (with distance <= 3)
getUpDiag board col player = left ++ (-player):right
    where
        row = getHeight $ board !! col
        left = reverse $ takeWhile (\x -> (x==0) || (x==player)) $ reverse $ getDiagRec board (col-1) (row-1) (-1) (-1) 3
        right = takeWhile (\x -> (x==0) || (x==player)) $ getDiagRec board (col+1) (row+1) 1 1 3

--Returns decreasing diagonal elements (with distance <= 3)
getDownDiag board col player = left ++ (-player):right
    where
        row = getHeight $ board !! col
        left = reverse $ takeWhile (\x -> (x==0) || (x==player)) $ reverse $ getDiagRec board (col-1) (row+1) (-1) 1 3
        right = takeWhile (\x -> (x==0) || (x==player)) $ getDiagRec board (col+1) (row-1) 1 (-1) 3

--Auxiliary recursive function to get diagonal elements
getDiagRec board col row dCol dRow count
    | (col<0) || (row<0) || (col>=boardWidth board) || (row>=boardHeight board) = []
    | (count==1) || (col==0) || (row==0) || ((col+1)==boardWidth board) || ((row+1)==boardHeight board) = (boardPos board col row):[]
    | dCol < 0 = (getDiagRec board (col+dCol) (row+dRow) dCol dRow (count-1))++(boardPos board col row):[]
    | otherwise = ((boardPos board col row):[])++(getDiagRec board (col+dCol) (row+dRow) dCol dRow (count-1))

--Checks if, given a player, board, column and target line size, a move of the player to the column makes him achieve a linesize of 4 
makesN :: [[Int]] -> Int -> Int -> Int -> Bool
makesN board col player n = (makesN' h player n) || (makesN' v player n) || (makesN' uD player n) || (makesN' dD player n)
    where
        h = map abs $ getRow board col player
        v = map abs $ getCol board col player
        uD = map abs $ getUpDiag board col player
        dD = map abs $ getDownDiag board col player

makesN' :: [Int] -> Int -> Int -> Bool
makesN' line player n
    | (length line) < n = False
    | otherwise = (take n line == target) || (makesN' (tail line) player n)
    where
        target = replicate n player

--Modified makesN: When line has free space on both sides, adds one; when space avaliable <4 discards line 
makesNsmart :: [[Int]] -> Int -> Int -> Int -> Bool
makesNsmart board col player n = (makesNsmart' h player n 0) || (makesNsmart' v player n 0) || (makesNsmart' uD player n 0) || (makesNsmart' dD player n 0)
    where
        h = map abs $ getRow board col player
        v = map abs $ getCol board col player
        uD = map abs $ getUpDiag board col player
        dD = map abs $ getDownDiag board col player

makesNsmart' :: [Int] -> Int -> Int -> Int -> Bool
makesNsmart' line player n desp
    | length line < 4 = False
    | length recLine < n = False
    | otherwise = (take n recLine == target) || (take (n+1) recLine == smartTarget) || (makesNsmart' line player n (desp+1))
    where
        target = replicate n player
        smartTarget = [0] ++ (drop 1 target) ++ [0]
        recLine = drop desp line
{-
--Returns smart max line size for a column move: When line has free space on both sides, adds one; when space avaliable <4 discards line 
maxLine :: [[Int]] -> Int -> Int -> Int
maxLine board col player = maximum vec
    where
        h = map abs $ getRow board col player
        v = map abs $ getCol board col player
        uD = map abs $ getUpDiag board col player
        dD = map abs $ getDownDiag board col player
        vec = [(maxLine' h player), (maxLine' v player), (maxLine' uD player), (maxLine' dD player)]
    
maxLine' :: [Int] -> Int -> Int
maxLine' line player
    | (length line) < 4 = 0
    | (head line == 0) && (last line == 0) = (div (sum line) player) + 1
    | otherwise = div (sum line) player
-}