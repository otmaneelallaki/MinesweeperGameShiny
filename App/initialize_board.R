initialize_board <- function(rowNumber, colNumber, MineNumber) {
  
  # Create a blank rowNumber x rowNumber game board
  board <- matrix(0, nrow = rowNumber, ncol = colNumber)
  
  # Randomly place MineNumber mines on the game board
  mine_indices <- sample(1:(rowNumber*colNumber), MineNumber, replace = FALSE)
  board[mine_indices] <- -1
  
  # Assign the appropriate number of mines to each button based on its adjacent buttons
  for (i in 1:rowNumber) {
    for (j in 1:colNumber) {
      if (board[i, j] != -1) {
        num_adjacent_mines <- sum(board[max(i-1,1):min(i+1,rowNumber), max(j-1,1):min(j+1,colNumber)] == -1)
        board[i, j] <- num_adjacent_mines
      }
    }
  }
  
  return(board)
}
