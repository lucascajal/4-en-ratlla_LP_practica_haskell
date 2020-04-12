import System.Random

--IMPORTANT: Per representar el board farem una matriu, on tindrem columnes x files! (invers)
-- a = [[1,0,0,0],[1,1,0,0],[1,1,1,0],[0,0,0,0],[1,1,1,1]]

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
       turn player board (width * height)

--Turn
turn player board movesLeft
    | movesLeft == 0 = do 
        putStrLn "Game finished! No moves left"
        printBoard board
    | player == 1 = do
        printBoard board
        col <- inputCol board
        if (makesFour board col player) then do
            turn 2 (makeMove 1 col board) 0
        else do
            turn 2 (makeMove 1 col board) (movesLeft-1)
    | otherwise = do
        col <- randomCol board
        if (makesFour board col player) then do
            turn 1 (makeMove 2 col board) 0
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
        over = take 3 $ drop (row + 1) n
        under = reverse $ take 3 $ reverse $ take row n

--Returns row elements (with distance <= 3)
getRow board col player = left ++ (-player):right
    where 
        row = getHeight $ board !! col
        n = map (!! row) board
        right = take 3 $ drop (col + 1) n
        left = reverse $ take 3 $ reverse $ take col n

--Returns increasing diagonal elements (with distance <= 3)
getUpDiag board col player = left ++ (-player):right
    where
        row = getHeight $ board !! col
        left = getDiagRec board (col-1) (row-1) (-1) (-1) 3
        right = getDiagRec board (col+1) (row+1) 1 1 3

--Returns decreasing diagonal elements (with distance <= 3)
getDownDiag board col player = left ++ (-player):right
    where
        row = getHeight $ board !! col
        left = getDiagRec board (col-1) (row+1) (-1) 1 3
        right = getDiagRec board (col+1) (row-1) 1 (-1) 3

--Auxiliary recursive function to get diagonal elements
getDiagRec board col row dCol dRow count
    | (col<0) || (row<0) || (col>=boardWidth board) || (row>=boardHeight board) = []
    | (count==1) || (col==0) || (row==0) || ((col+1)==boardWidth board) || ((row+1)==boardHeight board) = (boardPos board col row):[]
    | dCol < 0 = (getDiagRec board (col+dCol) (row+dRow) dCol dRow (count-1))++(boardPos board col row):[]
    | otherwise = ((boardPos board col row):[])++(getDiagRec board (col+dCol) (row+dRow) dCol dRow (count-1))

makesFour board col player = (makesFour' h player) || (makesFour' v player) || (makesFour' uD player) || (makesFour' dD player)
    where
        h = map abs $ getRow board col player
        v = map abs $ getCol board col player
        uD = map abs $ getUpDiag board col player
        dD = map abs $ getDownDiag board col player

makesFour' line player
    | (length line) < 4 = False
    | (length line) == 4 = (line == target)
    | otherwise = (take 4 line == target) || (makesFour' (tail line) player)
    where
        target = replicate 4 player