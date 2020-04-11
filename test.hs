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
       turn player board

--Turn
turn player board 
    | noMoves board = do 
        putStrLn "Game finished! No moves left"
        printBoard board
    | player == 1 = do
        printBoard board
        col <- inputCol board
        turn 2 (makeMove 1 col board)
    | otherwise = do
        col <- randomCol board
        turn 1 (makeMove 2 col board)        

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

--Checks if column is valid
correctCol board col
    | col < 0 = False
    | col >= (boardWidth board) = False
    | otherwise = elem 0 (board !! col)


--Checks if there are no moves left (there are no zeroes in board)
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
    where c = chipPrint $ (board !! column) !! line

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