import System.Random

--IMPORTANT: Per representar el board farem una matriu, on tindrem columnes x files! (invers)

main :: IO ()
-- main program to play the game
main = do
       putStrLn "Board width: "
       input1 <- getLine
       putStrLn "Board height: " 
       input2 <- getLine

       let width = (read input1 :: Int)
       let height = (read input2 :: Int)

       putStrLn ("Board dimensions: " ++ (show width) ++ " x " ++ (show height))

       putStrLn ("Chips avaliable: " ++ show(width * height))

       putStrLn "First player (1 == human, 2 == computer): " 
       input3 <- getLine
       let player = (read input3 :: Int)

       let board = newBoard width height
       printBoard board

--Human turn
turn 1 board 
    | noMoves board = do putStrLn "Game finished! No moves left"
    | otherwise = 

--Computer turn
turn 2 board =
    | noMoves board = do putStrLn "Game finished! No moves left"
    | otherwise = 

--Returns True if there are no moves left (there are no zeroes in board), False otherwise
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
        putStrLn (show ((board !! column) !! line))
    | (column == boardWidth board -1) = do
        putStrLn (show ((board !! column) !! line))
        printBoard' board 0 (line - 1)
    | otherwise = do
        putStr ((show ((board !! column) !! line)) ++ " ")
        printBoard' board (column + 1) line

--Funció que imprimeix un board
printBoard board = do
    printBoard' board 0 ((boardHeight board) - 1)

--Creadora d'un board sense fitxes
newBoard width height = replicate width (replicate height 0)

--Alçada del board
boardHeight board = length (board !! 0)

--Amplada del board
boardWidth board = length board

{-
--Fa una tirada
makeMove player column board
    | (player /= 1) && (player /= 2) = do
        putStrLn "ERROR: Wrong player id"
    | (column < 0) || (column >= (boardWidth board)) = do
        putStrLn "ERROR: Column out of bounds"
    | not (elem 0 (board !! column)) = do
        putStrLn "ERROR: Column is full"
    | otherwise = (take (column - 1) board) : (addChip (board !! column) player) : (drop column board)
-}
makeMove player column board
    | column == 0 = ((addChip (board !! column) player):[])++(drop (column + 1) board)
    | column == (boardWidth board)-1 = (take (column) board)++((addChip (board !! column) player):[])
    | otherwise = (take (column) board)++((addChip (board !! column) player):[])++(drop (column + 1) board)

--Auxiliar de makeMove per afegir una fitxa a una columna
addChip list player
    | (head list) == 0 = player:(tail list)
    | otherwise = (head list):(addChip (tail list) player)